
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
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

        protected void Page_Load(object sender, EventArgs e)
        {
            SessionCode = Request.QueryString["SessionCode"];
            tbxCode.Text = SessionCode;
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

            SqlCommand delete = new SqlCommand("DELETE g FROM [userGroups] g INNER JOIN [Sessions] s on s.[groupID] = g.[groupID] Where g.[UserID] = '@user' AND s.[sessionCode] = @code", conn);
            delete.Parameters.AddWithValue("@user", CurrentUser);
            delete.Parameters.AddWithValue("@code", SessionCode);
            delete.ExecuteNonQuery();

            conn.Close();
        }

        protected void Close_Click(object sender, EventArgs e)
        {
            SqlConnection conn = new SqlConnection("Server=tcp:prj300repeat.database.windows.net,1433;Initial Catalog=FestivalFriendFinder;Persist Security Info=False;User ID=Sean;Password=P@ssword;MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;");
            conn.Open();

            SqlCommand deleteQ = new SqlCommand("DELETE g FROM [userGroups] g INNER JOIN [Sessions] s on s.[groupID] = g.[groupID] Where g.[UserID] = '@user' AND s.[sessionCode] = @code" , conn);
            deleteQ.Parameters.AddWithValue("@user", CurrentUser);
            deleteQ.Parameters.AddWithValue("@code", SessionCode);
            deleteQ.ExecuteNonQuery();


            SqlCommand deleteSession = new SqlCommand("DELETE SessionCode From Sessions where SessionCode = @code");
            deleteSession.Parameters.AddWithValue("@code", SessionCode);
            deleteSession.ExecuteNonQuery();

            conn.Close();

        }
    }
}