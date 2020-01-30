using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

namespace QAAuditApp.Ajax
{
    public partial class Api : System.Web.UI.Page
    {
        private string con;

        protected void Page_Load(object sender, EventArgs e)
        {
            string op = Request.QueryString.Get("op");
            string vals = Request.QueryString.Get("vals");
            string result = "defaultssss";
            
            switch(op)
            {
                case "pieChart":
                    result = PieChart(vals);
                    break;
                default:
                        
                    break;
            }
            lit_result.Text = result;
        }

        protected static string PieChart(string Vals)
        {
            return "ok";
        }

        

        [System.Web.Services.WebMethod]
        public static string GetCurrentTime(string name)
        {
            return "Hello " + name + Environment.NewLine + "The Current Time is: " + DateTime.Now.ToString();
        }

    }
}