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
using Newtonsoft.Json.Linq;
using System.Web.Script.Serialization;

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

            switch (op)
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
            string conn = ConfigurationManager.ConnectionStrings["db"].ConnectionString;
            SqlConnection con = new SqlConnection(conn);
            con.Open();
            string strSelect = "SELECT source, count(source) q FROM [dbo].[QA_Audit_main] WHERE passFail = 0 group by source";
            SqlCommand cmd = new SqlCommand(strSelect, con);
            SqlDataReader myReader = cmd.ExecuteReader();
            // cmd.Parameters.Add is depreciated, use AddWithValue
            //cmd.Parameters.AddWithValue("@id", Uid);
            string sources = string.Empty;
            string data = string.Empty;

            //AccessDataSource: { ARR,SOR}, value: { 1,2,1}
            while (myReader.Read())
            {
                // Assuming your desired value is the name as the 3rd field
                sources += "\"" + myReader.GetValue(0).ToString() + "\",";
                data += myReader.GetValue(1).ToString() + ",";
            }

            myReader.Close();
            con.Close();

            string result = "{\"result\": {\"source\": [" + sources.Remove(sources.Length - 1) + "] , \"data\": [" + data.Remove(data.Length - 1) + "]}}";
            /*JavaScriptSerializer j = new JavaScriptSerializer();
            object a = j.Deserialize(result, typeof(object));
            return a.ToString();*/
            return result;
        }

        [System.Web.Services.WebMethod]
        public static string GetCurrentTime(string name)
        {
            return "Hello " + name + Environment.NewLine + "The Current Time is: " + DateTime.Now.ToString();
        }

    }
}