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
    public partial class Details : Page
    {
        int Sourceinfoid = 0;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {            
                Int32.TryParse(Request.QueryString.Get("Sourceinfoid"), out Sourceinfoid);
                if (Sourceinfoid == 0) Response.Redirect("Default.aspx", true);
                else
                {
                    LoadCase();
                    CreateGrid();
                }
            }
        }

        protected void LoadCase()
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
                cmd.CommandText = "dbo.QA_Audit_sel_main";

                cmd.Parameters.AddWithValue("@Sourceinfoid", DbType.Int32).Value = Sourceinfoid;

                da = new SqlDataAdapter(cmd);
                da.Fill(dt);

            }
            catch (Exception e)
            { }
            finally
            {
                if (conn.State == ConnectionState.Open) conn.Close();

                if (conn != null)
                {
                    conn.Close();
                }
            }

            lb_sourceinfoid.Text = Sourceinfoid.ToString();
            lb_sourcename.Text = dt.Rows[0]["Source"].ToString();
            lb_sourcetype.Text = dt.Rows[0]["SourceType"].ToString();
            lb_lastaudited.Text = dt.Rows[0]["Last_Audited"].ToString();
            lb_passfail.Text = dt.Rows[0]["PassFail"].ToString() ;
        }

        protected DataTable LoadData(int Sourceinfoid)
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
                cmd.CommandText = "dbo.QA_Audit_sel_secondary";

                cmd.Parameters.AddWithValue("@Sourceinfoid", DbType.Int32).Value = Sourceinfoid;

                da = new SqlDataAdapter(cmd);
                da.Fill(dt);

            }
            catch(Exception e)
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
            Int32.TryParse(Request.QueryString.Get("Sourceinfoid"), out Sourceinfoid);
            grid1.DataSource = LoadData(Sourceinfoid);
            grid1.DataBind();
        }

        protected void RebindGrid(object sender, EventArgs e)
        {
            Int32.TryParse(Request.QueryString.Get("Sourceinfoid"), out Sourceinfoid);
            CreateGrid();
            LoadCase();
        }

        protected void grid1_UpdateCommand(object sender, Obout.Grid.GridRecordEventArgs e)
        {
            SqlConnection conn = null;
            DataTable dt = new DataTable();

            try
            {
                int passFail = e.Record["PassFail"].ToString() == "true" ? 1 : 0;


                string cnxString = ConfigurationManager.ConnectionStrings["db"].ToString();
                conn = new SqlConnection(cnxString);
                conn.Open();
                SqlCommand cmd = new SqlCommand();
                cmd.Connection = conn;
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.CommandText = "dbo.QA_Audit_upd_secondary";

                cmd.Parameters.AddWithValue("@Sourceinfoid", DbType.String).Value = e.Record["Sourceinfoid"].ToString();
                cmd.Parameters.AddWithValue("@QuestionNumber", DbType.Int32).Value = e.Record["QuestionNumber"].ToString();
                cmd.Parameters.AddWithValue("@PassFail", DbType.Int32).Value = passFail;
                cmd.Parameters.AddWithValue("@Notes", DbType.Int32).Value = e.Record["Notes"].ToString();
                cmd.Parameters.AddWithValue("@VerifyBy", DbType.Int32).Value = System.Security.Principal.WindowsIdentity.GetCurrent().Name;
                
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