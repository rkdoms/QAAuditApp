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
                CreateGrid();              
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

        protected void CreateGrid()
        {
            grid1.DataSource = LoadData();
            grid1.DataBind();
        }

        protected void RebindGrid(object sender, EventArgs e)
        {
            CreateGrid();
        }

        protected void grid1_UpdateCommand(object sender, Obout.Grid.GridRecordEventArgs e)
        {
            SqlConnection conn = null;
            DataTable dt = new DataTable();

            try
            {
                int isActive = e.Record["SourceIsActive"].ToString() == "true" ? 1 : 0;
                int passFail = e.Record["PassFail"].ToString() == "true" ? 1 : 0;


                string cnxString = ConfigurationManager.ConnectionStrings["db"].ToString();
                conn = new SqlConnection(cnxString);
                conn.Open();
                SqlCommand cmd = new SqlCommand();
                cmd.Connection = conn;
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.CommandText = "dbo.upd_audit_main";

                cmd.Parameters.AddWithValue("@id", DbType.Int32).Value = e.Record["id"].ToString();
                cmd.Parameters.AddWithValue("@PriorityName", DbType.String).Value = e.Record["Name"].ToString();
                cmd.Parameters.AddWithValue("@Points", DbType.Int32).Value = e.Record["Points"].ToString();
                cmd.Parameters.AddWithValue("@SourceIsActive", DbType.Int32).Value = isActive;
                cmd.Parameters.AddWithValue("@PassFail", DbType.Int32).Value = passFail;

                cmd.ExecuteNonQuery();
            }
            catch(Exception err)
            { }
            finally
            {
                if (conn.State == ConnectionState.Open) conn.Close();

                if (conn != null)
                {
                    conn.Close();
                }
            }
        }
    }
}