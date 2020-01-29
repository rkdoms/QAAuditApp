using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace QAAuditApp
{
    public partial class _Default : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {
                grid1.DataSource = LoadData();
                grid1.DataBind();
            }
        }

        protected DataTable LoadData()
        {
            SqlConnection conn = null;
            SqlDataAdapter da = null;
            DataTable dt = new DataTable();

            try
            {
                string cnxString = ConfigurationManager.ConnectionStrings["db"].ToString();
                conn = new SqlConnection(cnxString);
                conn.Open();
                SqlCommand cmd = new SqlCommand();
                cmd.Connection = conn;
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.CommandText = "dbo.sel_audit_main";

                cmd.Parameters.AddWithValue("@Source", DbType.String).Value = DBNull.Value;
                cmd.Parameters.AddWithValue("@Last_Audited", DbType.DateTime).Value = DBNull.Value;

                da = new SqlDataAdapter(cmd);
                da.Fill(dt);

            }
            catch
            { }
            finally
            {
                if (conn.State == ConnectionState.Open) conn.Close();

                if (conn != null)
                {
                    conn.Close();
                }
            }
            /*
            dt.Columns.Add("SupplierID");
            dt.Columns.Add("CompanyName");
            dt.Columns.Add("Address");
            dt.Columns.Add("Country");
            dt.Columns.Add("dummy5");


            for (int i = 1; i < 1000; i++)
            {
                DataRow row = dt.NewRow();
                row["SupplierID"] = i.ToString();
                row["CompanyName"] = "Dummy1 " + i.ToString();
                row["Address"] = "Dummy2" + i.ToString();
                row["Country"] = "Dummy3 " + i.ToString();

                dt.Rows.Add(row);
            }
            dt.AcceptChanges();
            */
            return dt;
        }

    }
}