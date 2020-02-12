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

namespace QAAuditApp.History
{
    public partial class Default : Page
    {
        int Sourceinfoid, idmain = 0;
        private readonly IAudit serv = new Audit();
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {
                Int32.TryParse(Request.QueryString.Get("Sourceinfoid"), out Sourceinfoid);
                Int32.TryParse(Request.QueryString.Get("idmain"), out idmain);

                IEnumerable<AuditArchive> history = serv.GetAllArchive(Sourceinfoid, false);

                ddl_history.Items.Clear();
                ddl_history.Items.Add(new ListItem("Select a Historical Audit",""));

                foreach (AuditArchive audit in history)
                {
                    string status = audit.SourcePass ? "Passed" : "Failed";
                    string option = "SourceInfoID: " + audit.SourceInfoId.ToString() + ", Date [ " + audit.StartTime.ToString() + " - " + audit.EndTime.ToString() + "], Status " + status;
                    ddl_history.Items.Add(new ListItem(option, audit.SourceInfoId.ToString() + "|" + audit.Id.ToString()));                    
                }
                if (idmain > 0 && Sourceinfoid > 0)
                {
                    try
                    {
                        ddl_history.Items.FindByValue(Sourceinfoid.ToString() + "|" + idmain.ToString()).Selected = true;
                        ddl_history_SelectedIndexChanged(null, null);
                    }
                    catch { }
                }
                               
            }
        }

        protected void ddl_history_SelectedIndexChanged(object sender, EventArgs e)
        {
            string[] ids = ddl_history.SelectedValue.Split('|');            
            Int32.TryParse(ids[0], out Sourceinfoid);
            Int32.TryParse(ids[1], out idmain);
            loadTestData(Sourceinfoid, idmain);        
        }

        protected void loadTestData(int Sourceinfoid, int idmain)
        {
            grid1.Visible = true;
            grid1.DataSource = serv.GetAuditTestDataArchive(Sourceinfoid, idmain); ;
            grid1.DataBind();          
        }
    }
}