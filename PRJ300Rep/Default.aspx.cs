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

        }

        protected void continue_Click(object sender, EventArgs e)
        {
            Random randGen = new Random();
            int code = randGen.Next(100000, 999999);
            string username = User.Identity.Name;

            if (username != "")
            {

                SqlConnection conn = new SqlConnection("Server=tcp:prj300repeat.database.windows.net,1433;Initial Catalog=FestivalFriendFinder;Persist Security Info=False;User ID=Sean;Password=P@ssword;MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;");
                conn.Open();

                SqlCommand NewSession = new SqlCommand("Insert into Sessions(SessionCode) Values(@pin)", conn);
                NewSession.Parameters.AddWithValue("@pin", code);
                int result = NewSession.ExecuteNonQuery();

                //SqlCommand getUserID = new SqlCommand("Select Id from AspNetUsers Where UserName = '@username'", conn);
                //getUserID.Parameters.AddWithValue("@username", username);
                //string UserID = Convert.ToString(getUserID.ExecuteNonQuery());

                SqlCommand newGroup = new SqlCommand("Insert into Groups(AdminID) Values (@AdminID)", conn);
                newGroup.Parameters.AddWithValue("@AdminID", username);
                int result1 = newGroup.ExecuteNonQuery();

                string GroupID = "";
                    SqlCommand getGroupID = new SqlCommand("Select Id from [Groups] Where AdminID = @UserID", conn);
                    getGroupID.Parameters.AddWithValue("@UserID", username);

                    using (SqlDataReader reader = getGroupID.ExecuteReader())
                    {
                        if(reader.Read())
                        {
                            GroupID = string.Format("{0}", reader["Id"]);
                        }
                    }


                        //GroupID = (String)getGroupID.ExecuteScalar();
                

                


                SqlCommand NewUserGroup = new SqlCommand("Insert into UserGroups(GroupId,UserID) Values (@GroupID,@UserID)", conn);
                NewUserGroup.Parameters.AddWithValue("@GroupID", GroupID);
                NewUserGroup.Parameters.AddWithValue("@UserID", username);
                int result2 = NewUserGroup.ExecuteNonQuery();

                conn.Close();
            }


            /*using (SqlDataReader reader = command.ExecuteReader())
            {
                if (reader.Read())
                {
                    Console.WriteLine(String.Format("{0}", reader["id"]));
                }
            }
            */


            Response.Redirect("Session.aspx?SessionCode=" + code);
        }
        protected void codeSubmit_Click(object sender, EventArgs e)
        {

        }
    }
}