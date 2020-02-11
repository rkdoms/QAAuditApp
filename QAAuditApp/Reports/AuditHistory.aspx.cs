using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using QAAuditBusiness;
using QAAuditBusiness.Implementation;
using QAAuditBusiness.Models;
using Newtonsoft.Json;
using System.Web.UI.WebControls;

namespace QAAuditApp
{
    public partial class AuditHistory : Page
    {
        int Sourceinfoid = 0;
        private readonly IAudit serv = new Audit();
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {
                Int32.TryParse(Request.QueryString.Get("Sourceinfoid"), out Sourceinfoid);
                string id = Request.QueryString.Get("auditId");

                IEnumerable<AuditArchive> history = serv.GetAllArchive(Sourceinfoid, false);

                ddl_history.Items.Clear();
                ddl_history.Items.Add(new ListItem("Select an option",""));

                foreach (AuditArchive audit in history)
                {
                    string option = audit.SourceInfoId.ToString() + " - " + audit.StartTime.ToString() + " - " + audit.EndTime.ToString();
                    ddl_history.Items.Add(new ListItem(option, audit.Id.ToString()));                    
                }
                if (!string.IsNullOrEmpty(id)) ddl_history.Items.FindByValue(id).Selected = true;
            }
        }

        protected void CreateGridAndHeaderInfo(bool headerInfo = false)
        {
            Int32.TryParse(Request.QueryString.Get("Sourceinfoid"), out Sourceinfoid);
            //Sourceinfoid = 2224;
            AuditMain audit = serv.GetAuditBySourceInfoId(Sourceinfoid, true);
            //todo: if all qstns are passed, show finishing answering button.
            grid1.Visible = true;
            grid1.DataSource = audit.TestData;
            grid1.DataBind();
        }

        protected void RebindGrid(object sender, EventArgs e)
        {
            CreateGridAndHeaderInfo();
        }


        protected void grid1_UpdateCommand(object sender, Obout.Grid.GridRecordEventArgs e)
        {
            try
            {
                IEnumerable<AuditQuestions> result = JsonConvert.DeserializeObject<IEnumerable<AuditQuestions>>(e.Record["QuestionJson"].ToString());
                serv.UpdateAuditQuestions(result);
            }
            catch (Exception err)
            { }
        }

        protected void btn_start_audit_Click(object sender, EventArgs e)
        {
            Int32.TryParse(Request.QueryString.Get("Sourceinfoid"), out Sourceinfoid);
            //Sourceinfoid = 2224;
            if (serv.InsertArchiveAudit(Sourceinfoid, System.Security.Principal.WindowsIdentity.GetCurrent().Name))
            {
                Response.Redirect(Request.RawUrl);
            }
        }

        protected void btn_end_audit_Click(object sender, EventArgs e)
        {
            Int32.TryParse(Request.QueryString.Get("Sourceinfoid"), out Sourceinfoid);
            //Sourceinfoid = 2224;
            AuditArchive activeArchive = serv.GetActiveArchive(Sourceinfoid, 0);
            if (activeArchive != null)
            {
                activeArchive.IsActive = false;
                activeArchive.SourcePass = true;
                activeArchive.EndTime = DateTime.Now;
                serv.UpdateArchive(activeArchive);
                Response.Redirect(Request.RawUrl);
            }
        }

        protected void ddl_history_SelectedIndexChanged(object sender, EventArgs e)
        {

        }
    }
}