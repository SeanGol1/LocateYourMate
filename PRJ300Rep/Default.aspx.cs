using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace PRJ300Rep
{
    public partial class _Default : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            SqlConnection conn = new SqlConnection("Server=tcp:prj300repeat.database.windows.net,1433;Initial Catalog=FestivalFriendFinder;Persist Security Info=False;User ID=Sean;Password=P@ssword;MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;");
            conn.Open();
            string SessionID = "";
            SqlCommand curSessions = new SqlCommand("Select sessionCode from [Sessions]  Inner JOIN [Groups] on [Groups].[Id] = [Sessions].[groupID] INNER JOIN [userGroups] on [userGroups].GroupID = [Groups].[Id] Where [userGroups].[UserID] = @userid ", conn);
            curSessions.Parameters.AddWithValue("@userid", User.Identity.Name);

            List<string> SessionCodes = new List<string>();
            using (SqlDataReader reader = curSessions.ExecuteReader())
            {
                while (reader.Read())
                {                    
                    SessionID = string.Format("{0}", reader["sessionCode"]);
                    SessionCodes.Add(SessionID);
                }
            }
                       
            conn.Close();

            lbxSessionlist.DataSource = SessionCodes;
            lbxSessionlist.SelectedIndex = -1;
            lbxSessionlist.DataBind();
      
            //blst.DataSource = SessionCodes;

        }

        protected void continue_Click(object sender, EventArgs e)
        {
            int code = 0;
            int codecheck = 1;
            string username = User.Identity.Name;
            DateTime timeout = calTimeout.SelectedDate;
            if (username != "")
            {
                SqlConnection conn = new SqlConnection("Server=tcp:prj300repeat.database.windows.net,1433;Initial Catalog=FestivalFriendFinder;Persist Security Info=False;User ID=Sean;Password=P@ssword;MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;");
                conn.Open();

                while (codecheck != -1)
                {
                    code = NewSessionCode();
                    SqlCommand checkPin = new SqlCommand("Select sessionCode from [Sessions] Where sessionCode = @pin", conn);
                    checkPin.Parameters.AddWithValue("@pin", code);
                    codecheck = checkPin.ExecuteNonQuery();
                }

                SqlCommand newGroup = new SqlCommand("Insert into Groups(AdminID) Values (@AdminID)", conn);
                newGroup.Parameters.AddWithValue("@AdminID", username);
                int result1 = newGroup.ExecuteNonQuery();

                string GroupID = "";
                SqlCommand getGroupID = new SqlCommand("Select Id from [Groups] Where AdminID = @UserID", conn);
                getGroupID.Parameters.AddWithValue("@UserID", username);

                using (SqlDataReader reader = getGroupID.ExecuteReader())
                {
                    if (reader.Read())
                    {
                        GroupID = string.Format("{0}", reader["Id"]);
                    }
                }

                SqlCommand NewUserGroup = new SqlCommand("Insert into UserGroups(GroupId,UserID) Values (@GroupID,@UserID)", conn);
                NewUserGroup.Parameters.AddWithValue("@GroupID", GroupID);
                NewUserGroup.Parameters.AddWithValue("@UserID", username);
                int result2 = NewUserGroup.ExecuteNonQuery();

                SqlCommand NewSession = new SqlCommand("Insert into Sessions(SessionCode,groupID,timeout) Values(@pin,@groupid,@timeout)", conn);
                NewSession.Parameters.AddWithValue("@pin", code);
                NewSession.Parameters.AddWithValue("@groupid", GroupID);
                NewSession.Parameters.AddWithValue("@timeout", timeout);
                int result = NewSession.ExecuteNonQuery();

                conn.Close();
            }


            Response.Redirect("Session.aspx?SessionCode=" + code);
        }
        protected void codeSubmit_Click(object sender, EventArgs e)
        {
            string code = inputcode.Text;
            string user = User.Identity.Name;
            string GroupID = "";
            string codecheck = "";
            SqlConnection conn = new SqlConnection("Server=tcp:prj300repeat.database.windows.net,1433;Initial Catalog=FestivalFriendFinder;Persist Security Info=False;User ID=Sean;Password=P@ssword;MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;");
            conn.Open();


            SqlCommand checkPin = new SqlCommand("Select * from [Sessions] Where sessionCode = @pin", conn);
            checkPin.Parameters.AddWithValue("@pin", code);
            using (SqlDataReader reader = checkPin.ExecuteReader())
            {
                if (reader.Read())
                {
                    codecheck = string.Format("{0}", reader["sessionCode"]);
                    if (codecheck == code)
                    {
                        GroupID = string.Format("{0}", reader["groupID"]);
                    }
                    else
                    {
                        string script = "<script type=\"text/javascript\">alert('Session Code Not Found!');</script>";
                        ClientScript.RegisterClientScriptBlock(this.GetType(), "Alert", script);
                    }
                }
            }


            if (GroupID != "")
            {
                SqlCommand joinGroup = new SqlCommand("Insert into userGroups(GroupID,UserID) Values (@groupid,@userid)", conn);
                joinGroup.Parameters.AddWithValue("@userid", user);
                joinGroup.Parameters.AddWithValue("@groupid", GroupID);
                int result1 = joinGroup.ExecuteNonQuery();

                Response.Redirect("Session.aspx?SessionCode=" + code);
            }
            conn.Close();
        }



        public int NewSessionCode()
        {
            Random randGen = new Random();
            int code = randGen.Next(100000, 999999);
            return code;
        }

        protected void lbxSessionlist_SelectedIndexChanged(object sender, EventArgs e)
        {
            Response.Redirect("Session.aspx?sessionCode=" + lbxSessionlist.SelectedValue);
        }
    }
}
