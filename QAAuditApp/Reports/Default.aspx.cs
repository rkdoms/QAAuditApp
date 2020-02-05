using QAAuditBusiness;
using QAAuditBusiness.Implementation;
using QAAuditBusiness.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace QAAuditApp
{
    public partial class Reports_Default : Page
    {
        private readonly IAudit serv = new Audit();
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {
                CreateGrid();              
            }
        }

        protected IEnumerable<AuditMain> LoadData()
        {
            IEnumerable<AuditMain> dt = new List<AuditMain>();

            try
            {
                dt = serv.GetAllAudit(false);
            }
            catch(Exception e)
            { }

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
            try
            {
                //int isActive = e.Record["SourceIsActive"].ToString() == "true" ? 1 : 0;
                //int passFail = e.Record["SourcePass"].ToString() == "true" ? 1 : 0;

                AuditMain audit = new AuditMain();

                audit.SourceInfoId = Int32.Parse(e.Record["SourceInfoId"].ToString());
                audit.PriorityName = e.Record["PriorityName"].ToString();
                audit.SourcePoints = Int32.Parse(e.Record["SourcePoints"].ToString());
                audit.SourceIsActive = e.Record["SourceIsActive"].ToString() == "true" ? true : false;
                audit.SourcePass = e.Record["SourcePass"].ToString() == "true" ? true : false;

                serv.UpdateAuditMain(audit);
            }
            catch(Exception err)
            { }
        }

        protected void Priority_Load(object sender, EventArgs e)
        {
            DropDownList ddl = sender as DropDownList;

            ddl.DataSource = serv.GetAllPriority(); ;
            ddl.DataTextField = "Name";
            ddl.DataValueField = "id";
            ddl.DataBind();

        }
    }
}