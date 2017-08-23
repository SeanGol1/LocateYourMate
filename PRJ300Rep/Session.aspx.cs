
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Globalization;
using System.Linq;
using System.Net;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace PRJ300Rep
{
    public partial class Session : Page
    {
        public string CurrentUser = "";
        public string SessionCode = "";
        public List<IpInfo> group = new List<IpInfo>();
        public string JSArray = "";

        protected void Page_Load(object sender, EventArgs e)
        {
            SessionCode = Request.QueryString["SessionCode"];
            tbxCode.Text = "<strong>" + SessionCode + "</strong>";
            CurrentUser = User.Identity.Name;


            string adminID = "";

            SqlConnection conn = new SqlConnection("Server=tcp:prj300repeat.database.windows.net,1433;Initial Catalog=FestivalFriendFinder;Persist Security Info=False;User ID=Sean;Password=P@ssword;MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;");
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

            ////send users in group  to javascript 
            //SqlCommand GetUsers = new SqlCommand("Select UserID from Usergroups inner join [Groups] on [Groups].[Id] = [UserGroups].[GroupId] Inner Join [Sessions] on [Groups].[Id] = [Sessions].[groupID] where SessionCode = @code", conn);
            //GetUsers.Parameters.AddWithValue("@code", SessionCode);
            //using (SqlDataReader reader = GetUsers.ExecuteReader())
            //{
            //    if (reader.Read())
            //    {
            //        group.Add(string.Format("{0}", reader["UserID"]));
            //    }
            //}

            


            // Get the IP  and insert it into a database

            string userIP = GetUserIP();

            SqlCommand AddIp = new SqlCommand("Update [AspNetUsers] set [IPAddress] = @ip  WHERE [UserName] = @name", conn);
            AddIp.Parameters.AddWithValue("@ip", userIP);
            AddIp.Parameters.AddWithValue("@name", CurrentUser);
            int result2 = AddIp.ExecuteNonQuery();

            SqlCommand GetIp = new SqlCommand("select [UserName], [IPAddress] FROM [AspNetUsers] WHERE [UserName] = @name", conn);
            GetIp.Parameters.AddWithValue("@name", CurrentUser);
            using (SqlDataReader reader = GetIp.ExecuteReader())
            {
                if (reader.Read())
                {
                    foreach (var item in reader)
                    {
                        string Name = string.Format("{0}", reader["Name"]);
                        string IPAddress = string.Format("{1}", reader["IPAddress"]);
                        IpInfo ipuser = new IpInfo(Name, IPAddress);
                        group.Add(ipuser);
                    }

                }
            }
JSArray = JsonConvert.SerializeObject(group);
            //Show Close Session button only for an admin
            if (adminID == User.Identity.Name)
                Close.Visible = true;
            else
                Close.Visible = false;

            conn.Close();

        }

        protected void leave_Click(object sender, EventArgs e)
        {

            SqlConnection conn = new SqlConnection("Server=tcp:prj300repeat.database.windows.net,1433;Initial Catalog=FestivalFriendFinder;Persist Security Info=False;User ID=Sean;Password=P@ssword;MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;");
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

            SqlConnection conn = new SqlConnection("Server=tcp:prj300repeat.database.windows.net,1433;Initial Catalog=FestivalFriendFinder;Persist Security Info=False;User ID=Sean;Password=P@ssword;MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;");
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

        public static string GetUserIP()
        {

            // gets the ip in Json format to send back to load function
            IpInfo ipInfo = new IpInfo();

            try
            {
                string info = new WebClient().DownloadString("http://ipinfo.io/");
                ipInfo = JsonConvert.DeserializeObject<IpInfo>(info);

            }
            catch (Exception)
            {
                ipInfo.Ip = null;
            }

            return ipInfo.Ip;
        }

    }
}