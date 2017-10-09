using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace PRJ300Rep
{
    public partial class _Default : Page
    {
        string selItem = "";
        public List<string> SessionCodes = new List<string>();
        protected void Page_Load(object sender, EventArgs e)
        {
            
            try
            {

                SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["AzureConnectionString"].ToString());
                conn.Open();

                //delete all sessions that have timed out
                SqlCommand timeout = new SqlCommand("delete from Sessions where Timeout < @date", conn);
                timeout.Parameters.AddWithValue("@date", DateTime.Now);
                int result2 = timeout.ExecuteNonQuery();

                
                string SessionID = "";
                SqlCommand curSessions = new SqlCommand("Select sessionCode from [Sessions]  Inner JOIN [Groups] on [Groups].[Id] = [Sessions].[groupID] INNER JOIN [userGroups] on [userGroups].GroupID = [Groups].[Id] Where [userGroups].[UserID] = @userid ", conn);
                curSessions.Parameters.AddWithValue("@userid", User.Identity.Name);                
                SessionCodes.Clear();
                using (SqlDataReader reader = curSessions.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        SessionID = string.Format("{0}", reader["sessionCode"]);
                        SessionCodes.Add(SessionID);
                    }
                }
                conn.Close();


               
               
            }
            catch (Exception ex)
            {
                ex.InnerException.ToString();
            }

            HttpCookie UserId = new HttpCookie("UserID");
            UserId.Value = User.Identity.Name;
            Response.Cookies.Add(UserId);
            
        }

        protected void continue_Click(object sender, EventArgs e)
        {
            int code = 0;
            int codecheck = 1;
            string username = User.Identity.Name;
            DateTime timeout;

            if (tbxTimeout.Text != "")
                timeout = DateTime.Now.AddHours(Convert.ToDouble(tbxTimeout.Text));
            else
                timeout = DateTime.Now.AddHours(24); //set default timeout to 24 hours

            if (username != "")
            {

                SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["AzureConnectionString"].ToString());
                conn.Open();

                while (codecheck != -1)
                {
                    code = NewSessionCode();
                    SqlCommand checkPin = new SqlCommand("Select sessionCode from [Sessions] Where sessionCode = @pin", conn);
                    checkPin.Parameters.AddWithValue("@pin", code);
                    codecheck = checkPin.ExecuteNonQuery();
                }

                SqlCommand newGroup = new SqlCommand("Insert into Groups(AdminID) output INSERTED.Id Values (@AdminID)", conn);
                newGroup.Parameters.AddWithValue("@AdminID", username);
                int GroupID = (int)newGroup.ExecuteScalar();

                SqlCommand NewUserGroup = new SqlCommand("Insert into UserGroups(GroupId,UserID) Values (@GroupID,@UserID)", conn);
                NewUserGroup.Parameters.AddWithValue("@GroupID", GroupID);
                NewUserGroup.Parameters.AddWithValue("@UserID", username);
                int result2 = NewUserGroup.ExecuteNonQuery();

                SqlCommand NewSession = new SqlCommand("Insert into Sessions(SessionCode,groupID,Timeout) Values(@pin,@groupid,@timeout)", conn);
                NewSession.Parameters.AddWithValue("@pin", code);
                NewSession.Parameters.AddWithValue("@groupid", GroupID);
                NewSession.Parameters.AddWithValue("@timeout", timeout);
                int result = NewSession.ExecuteNonQuery();

                conn.Close();

                Response.Redirect("Session.aspx?SessionCode=" + code);
            }
        }
        protected void codeSubmit_Click(object sender, EventArgs e)
        {
            string code = inputcode.Text;
            string user = User.Identity.Name;
            string GroupID = "";
            string codecheck = "";
           // selItem = lbxSessionlist.SelectedValue;
            if (code == "")
            {
                code = selItem;
            }

            SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["AzureConnectionString"].ToString());
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

            if (GroupID != "" && selItem == "")
            {
                SqlCommand joinGroup = new SqlCommand("Insert into userGroups(GroupID,UserID) Values (@groupid,@userid)", conn);
                joinGroup.Parameters.AddWithValue("@userid", user);
                joinGroup.Parameters.AddWithValue("@groupid", GroupID);
                int result1 = joinGroup.ExecuteNonQuery();
            }
            conn.Close();

            Response.Redirect("Session.aspx?SessionCode=" + code);
        }


        public int NewSessionCode()
        {
            Random randGen = new Random();
            int code = randGen.Next(100000, 999999);
            return code;
        }

        protected void lbxSessionlist_SelectedIndexChanged(object sender, EventArgs e)
        {
            //selItem = lbxSessionlist.SelectedValue;
        }

    }
}

