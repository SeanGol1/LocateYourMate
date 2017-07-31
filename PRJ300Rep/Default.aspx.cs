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

            SqlConnection conn = new SqlConnection("Server=tcp:prj300repeat.database.windows.net,1433;Initial Catalog=FestivalFriendFinder;Persist Security Info=False;User ID=Sean;Password=P@ssword;MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;");
            conn.Open();

            SqlCommand command = new SqlCommand("Insert into Sessions(SessionCode)", conn);
            command.Parameters.AddWithValue("@zip", "india");
            // int result = command.ExecuteNonQuery();
            using (SqlDataReader reader = command.ExecuteReader())
            {
                if (reader.Read())
                {
                    Console.WriteLine(String.Format("{0}", reader["id"]));
                }
            }

            conn.Close();
        }
        protected void codeSubmit_Click(object sender, EventArgs e)
        {

        }
    }
}