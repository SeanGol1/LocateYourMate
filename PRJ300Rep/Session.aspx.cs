
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Globalization;
using System.Linq;
using System.Net;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;


namespace PRJ300Rep
{
    //[ScriptService]
    public partial class Session : Page
    {
        public string CurrentUser = "";
        public string SessionCode = "";       
        public List<UserLocation> users = new List<UserLocation>();
        public List<MarkerLocation> markers = new List<MarkerLocation>();
        public string JSArray = "";
        public string JSMarkerArray = "";
        public string adminID = "";

        protected void Page_Load(object sender, EventArgs e)
        {
            //get sessioncode from querystring and display 
            SessionCode = Request.QueryString["SessionCode"];
            tbxCode.Text = "<strong>" + SessionCode + "</strong>";

            CurrentUser = User.Identity.Name;            

            SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["AzureConnectionString"].ToString());
            conn.Open();

            SqlCommand getAdmin = new SqlCommand("Select AdminID from Groups inner join [Sessions] on [Groups].[Id] = [Sessions].[groupID] where SessionCode = @code", conn);
            getAdmin.Parameters.AddWithValue("@code", SessionCode);
            using (SqlDataReader reader = getAdmin.ExecuteReader())
            {
                if (reader.Read())
                {
                    adminID = string.Format("{0}", reader["AdminID"]);
                }
            }

            /*//get users from the database and send it to the client side 
            SqlCommand GetUsers = new SqlCommand("select UserID from UserGroups join Sessions on UserGroups.GroupID = Sessions.groupID where SessionCode = @code", conn);
            GetUsers.Parameters.AddWithValue("@code", SessionCode);
            users.Clear();
            using (SqlDataReader reader = GetUsers.ExecuteReader())
            {
                while (reader.Read())
                {
                    string Name = string.Format("{0}", reader["UserID"]);
                    users.Add(Name);
                }
            }*/

             
                 
            



            //Show Close Session button only for an admin
            if (adminID == User.Identity.Name)
                Close.Visible = true;
            else
                Close.Visible = false;


         

            //Save Locations in the database
            string lat;
            string lng;
            lat = hdnLat.Value;            
            lng = hdnLng.Value;
            
            SqlCommand UpdateLocation = new SqlCommand("UPDATE [AspNetUsers] SET [lat] = @latit, [lng] = @lngit WHERE [AspNetUsers].[Username] = @currentUser", conn);
            UpdateLocation.Parameters.AddWithValue("@currentUser", CurrentUser);
            UpdateLocation.Parameters.AddWithValue("@latit", lat);
            UpdateLocation.Parameters.AddWithValue("@lngit", lng);
            int result2 = UpdateLocation.ExecuteNonQuery();

            //InsertStageLocation
            string stagelat;
            string stagelng;
            stagelat = hdnlatStage.Value;
            stagelng = hdnlngStage.Value;
            if (stagelat != "" && stagelng !="")
            {
                SqlCommand GetMarkers = new SqlCommand("select * from [Markers] where [type] = 'stage' AND [SessionCode] = @code", conn);
                GetMarkers.Parameters.AddWithValue("@code", SessionCode);
                int result = GetMarkers.ExecuteNonQuery();
                if (result == -1){
                    SqlCommand InsertStageLocation = new SqlCommand("Insert into Markers(lat,lng,type,SessionCode) Values (@lats,@lngs,'stage',@code)", conn);
                    InsertStageLocation.Parameters.AddWithValue("@lats", stagelat);
                    InsertStageLocation.Parameters.AddWithValue("@lngs", stagelng);
                    InsertStageLocation.Parameters.AddWithValue("@code", SessionCode);
                    int result3 = InsertStageLocation.ExecuteNonQuery();
                }

                else
                {
                    SqlCommand UpdateStageLocation = new SqlCommand("UPDATE [Markers] SET [lat] = @lats, [lng] = @lngs WHERE [type] = 'stage' AND [SessionCode] = @code", conn);                    
                    UpdateStageLocation.Parameters.AddWithValue("@lats", stagelat);
                    UpdateStageLocation.Parameters.AddWithValue("@lngs", stagelng);
                    UpdateStageLocation.Parameters.AddWithValue("@code", SessionCode);
                    int result4 = UpdateStageLocation.ExecuteNonQuery();
                }
                hdnlatStage.Value = "";
                hdnlngStage.Value = "";
            }



            //get users (name and Local) from the database
            string slat = "";
            string slng = "";

            SqlCommand GetGroupLocation = new SqlCommand("select Username, lat, lng from [AspNetUsers] join [userGroups] on UserID = AspNetUsers.Username join Sessions on UserGroups.GroupID = Sessions.groupID where SessionCode = @code", conn);
            GetGroupLocation.Parameters.AddWithValue("@code", SessionCode);
            users.Clear();
            using (SqlDataReader reader = GetGroupLocation.ExecuteReader())
            {
                while (reader.Read())
                {
                    string Name = string.Format("{0}", reader["Username"]);
                    if (lat != "" && lng != "")
                    {
                        slat = string.Format("{0}", reader["lat"]);
                        slng = string.Format("{0}", reader["lng"]);
                    }

                    users.Add(new UserLocation(Name,slat,slng));
                }
            }

            JSArray = JsonConvert.SerializeObject(users);

            //Read Marker Locations
            SqlCommand GetMarkerLocations = new SqlCommand("select type, lat, lng from [Markers] Where [SessionCode] = @code", conn);
            GetMarkerLocations.Parameters.AddWithValue("@code", SessionCode);
            markers.Clear();
            using (SqlDataReader reader = GetMarkerLocations.ExecuteReader())
            {
                while (reader.Read())
                {
                    string type = string.Format("{0}", reader["type"]);
                    string stlat = string.Format("{0}", reader["lat"]);
                    string stlng = string.Format("{0}", reader["lng"]);                    

                    markers.Add(new MarkerLocation(type, stlat, stlng));
                }
            }

            JSMarkerArray = JsonConvert.SerializeObject(markers);    

            conn.Close();

        }


        protected void leave_Click(object sender, EventArgs e)
        {

            SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["AzureConnectionString"].ToString());
            conn.Open();

            SqlCommand delete = new SqlCommand("Delete u1 From usergroups as u1 Inner Join Groups as g on g.Id = u1.groupID Inner Join Sessions as s On s.groupID = g.Id where u1.UserID = @user AND s.SessionCode = @code", conn);
            delete.Parameters.AddWithValue("@user", CurrentUser);
            delete.Parameters.AddWithValue("@code", SessionCode);
            delete.ExecuteNonQuery();

            conn.Close();
            Response.Redirect("Default.aspx");

        }

        protected void Close_Click(object sender, EventArgs e)
        {

            SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["AzureConnectionString"].ToString());
            conn.Open();

            SqlCommand deleteQ = new SqlCommand("Delete u1 From usergroups as u1 Inner Join Groups as g on g.Id = u1.groupID Inner Join Sessions as s On s.groupID = g.Id output deleted.groupID where u1.UserID = @user AND s.SessionCode = @code", conn);
            deleteQ.Parameters.AddWithValue("@user", CurrentUser);
            deleteQ.Parameters.AddWithValue("@code", SessionCode);
            int GroupID = (int)deleteQ.ExecuteScalar();
            deleteQ.ExecuteNonQuery();


            SqlCommand deleteSession = new SqlCommand("DELETE SessionCode From Sessions where SessionCode = @code", conn);
            deleteSession.Parameters.AddWithValue("@code", SessionCode);
            deleteSession.ExecuteNonQuery();

            SqlCommand deleteGroup = new SqlCommand("DELETE From Groups where Id = @gid", conn);
            deleteSession.Parameters.AddWithValue("@gid", GroupID);
            deleteSession.ExecuteNonQuery();

            conn.Close();
            Response.Redirect("Default.aspx");

        }
    }
}