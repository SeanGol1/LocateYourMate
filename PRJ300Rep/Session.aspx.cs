using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace PRJ300Rep
{
    public partial class Session : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            string SessionCode = Request.QueryString["SessionCode"];
            tbxCode.Text = SessionCode;



        }
    }
}