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
            
            switch(op)
            {
                case "failsPerSource":
                    result = failsPerSource(vals);
                    break;
                case "AvgFails":
                    result = AvgFails(vals);
                    break;
                case "AvgFailsPerSource":
                    result = AvgFailsPerSource(vals);
                    break;
                    
                default:
                        
                    break;
            }
            lit_result.Text = result;
        }

        protected static string failsPerSource(string Vals)
        {
            string conn = ConfigurationManager.ConnectionStrings["db"].ConnectionString;
            SqlConnection con = new SqlConnection(conn);
            con.Open();
            string strSelect = "select COUNT(case when t1.PassFail = 0 then 1 end) failPerSource, SourceType from [dbo].[QA_Audit_main] t1 group by SourceType";
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
                sources += "\""+myReader.GetValue(1).ToString() + "\",";
                data += myReader.GetValue(0).ToString() + ",";
            }

            myReader.Close();
            con.Close();

            string result = "{\"result\": {\"source\": [" + sources.Remove(sources.Length - 1) + "] , \"data\": [" + data.Remove(data.Length - 1) + "]}}";
            /*JavaScriptSerializer j = new JavaScriptSerializer();
            object a = j.Deserialize(result, typeof(object));
            return a.ToString();*/
            return result;
        }



        protected static string AvgFailsPerSource(string Vals)
        {
            string conn = ConfigurationManager.ConnectionStrings["db"].ConnectionString;
            SqlConnection con = new SqlConnection(conn);
            con.Open();
            string strSelect = "select COUNT(case when t1.PassFail = 0 then 1 end) * 100 / (select count(s1.SourceInfoId) from[dbo].[QA_Audit_main] s1 where s1.SourceType = t1.SourceType) averageFail,SourceType from[dbo].[QA_Audit_main] t1 group by SourceType";
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
                sources += "\"" + myReader.GetValue(1).ToString() + "\",";
                data += myReader.GetValue(0).ToString() + ",";
            }

            myReader.Close();
            con.Close();

            string result = "{\"result\": {\"source\": [" + sources.Remove(sources.Length - 1) + "] , \"data\": [" + data.Remove(data.Length - 1) + "]}}";
            /*JavaScriptSerializer j = new JavaScriptSerializer();
            object a = j.Deserialize(result, typeof(object));
            return a.ToString();*/
            return result;
        }

        protected static string AvgFails(string Vals)
        {
            string conn = ConfigurationManager.ConnectionStrings["db"].ConnectionString;
            SqlConnection con = new SqlConnection(conn);
            con.Open();
            string strSelect = "select COUNT(case when a.PassFail = 1 then 1 end) * 100 / (select count(SourceInfoId) from [dbo].[QA_Audit_main]) from [dbo].[QA_Audit_main] as a ";
            SqlCommand cmd = new SqlCommand(strSelect, con);
            SqlDataReader myReader = cmd.ExecuteReader();
            // cmd.Parameters.Add is depreciated, use AddWithValue
            //cmd.Parameters.AddWithValue("@id", Uid);
            string sources = string.Empty;
            string data = string.Empty;

            //AccessDataSource: { ARR,SOR}, value: { 1,2,1}

            while (myReader.Read())
            {
                data = myReader.GetInt32(0).ToString(); //The 0 stands for "the 0'th column", so the first column of the result.
                                                        // Do somthing with this rows string, for example to put them in to a list
            }

            myReader.Close();
            con.Close();

            string result = "{\"result\": {\"source\": null , \"data\": [" + data + "]}}";
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