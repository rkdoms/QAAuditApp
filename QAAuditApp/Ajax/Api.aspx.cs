using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace QAAuditApp.Ajax
{
    public partial class Api : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            string op = Request.QueryString.Get("op");
            string vals = Request.QueryString.Get("vals");
            string result = "default";

            switch(op)
            {
                case "pieChart":
                    result = pieChart(vals);
                    break;
                default:
                        
                    break;
            }
            lit_result.Text = result;
        }

        protected string pieChart(string values)
        {
            return values;
        }

        [System.Web.Services.WebMethod]
        public static string GetCurrentTime(string name)
        {
            return "Hello " + name + Environment.NewLine + "The Current Time is: " + DateTime.Now.ToString();
        }

    }
}