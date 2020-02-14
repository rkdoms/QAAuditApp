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

                IEnumerable<AuditArchive> distinctSources = serv.GetDistinctArchive();

                ddl_sourceinfoid.DataSource = distinctSources;
                ddl_sourceinfoid.DataTextField = "SourceName";
                ddl_sourceinfoid.DataValueField = "SourceInfoId";
                ddl_sourceinfoid.DataBind();
                ddl_sourceinfoid.Items.Insert(0, new ListItem("Select a Source", ""));


                if (Sourceinfoid > 0)
                {
                    try
                    {
                        ddl_sourceinfoid.Items.FindByValue(Sourceinfoid.ToString()).Selected = true;
                        ddl_sourceinfoid_SelectedIndexChanged(null, null);
                        if (idmain > 0) {
                            ddl_history.SelectedIndex = -1;
                            ddl_history.Items.FindByValue(Sourceinfoid.ToString() + "|" + idmain.ToString()).Selected = true;
                            ddl_history_SelectedIndexChanged(null, null);
                        }                      
                    }
                    catch(Exception err) { }
                }
                               
            }
        }

        protected void ddl_history_SelectedIndexChanged(object sender, EventArgs e)
        {
            string[] ids = ddl_history.SelectedValue.Split('|');            
            Int32.TryParse(ids[0], out Sourceinfoid);
            Int32.TryParse(ids[1], out idmain);
            IEnumerable<AuditArchive> history = (IEnumerable<AuditArchive>)ViewState["history"];
            AuditArchive a = history.Where(p => p.Id.ToString() == ids[1]).SingleOrDefault();
            lb_qa_team_notes.Text = a.QATeamNotes;
            loadTestData(Sourceinfoid, idmain);        
        }

        protected void ddl_sourceinfoid_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (ddl_sourceinfoid.SelectedValue != string.Empty)
            {
                Int32.TryParse(ddl_sourceinfoid.SelectedValue, out Sourceinfoid);
                grid1.Visible = false;
                IEnumerable<AuditArchive> history = serv.GetAllArchiveByStatus(Sourceinfoid, false);

                ddl_history.Items.Clear();
                ddl_history.Items.Add(new ListItem("Select a Historical Audit", ""));

                if (history.Count() > 0)
                {
                    ddl_status.Enabled = true;
                    ddl_status.SelectedIndex = 0;
                    ddl_history.Enabled = true;
                    ddl_history.SelectedIndex = 0;

                    foreach (AuditArchive audit in history)
                    {
                        string status = audit.SourcePass ? "Passed" : "Failed";
                        string option = " Date [ " + audit.StartTime.ToString() + " - " + audit.EndTime.ToString() + "], Status " + status;
                        ddl_history.Items.Add(new ListItem(option, audit.SourceInfoId.ToString() + "|" + audit.Id.ToString()));
                    }

                    ViewState["history"] = history;
                }
            }
            else
            {
                ddl_status.Enabled = false;
                ddl_status.SelectedIndex = -1;
                ddl_history.Enabled = false;
                ddl_history.SelectedIndex = -1;
            }

        }

        protected void ddl_status_SelectedIndexChanged(object sender, EventArgs e)
        {
            grid1.Visible = false;
            bool statusSelected = ddl_status.SelectedValue == "1" ? true: false;
            IEnumerable<AuditArchive> history = (IEnumerable<AuditArchive>)ViewState["history"];
            ddl_history.Items.Clear();
            ddl_history.Items.Add(new ListItem("Select a Historical Audit", ""));
            foreach (AuditArchive audit in history)
            {
                string status = audit.SourcePass ? "Passed" : "Failed";
                string option = " Date [ " + audit.StartTime.ToString() + " - " + audit.EndTime.ToString() + "], Status " + status;
                if(ddl_status.SelectedValue == string.Empty || statusSelected == audit.SourcePass)
                    ddl_history.Items.Add(new ListItem(option, audit.SourceInfoId.ToString() + "|" + audit.Id.ToString()));
            }
        }

        protected void loadTestData(int Sourceinfoid, int idmain)
        {
            IEnumerable<AuditArchive> history = (IEnumerable<AuditArchive>)ViewState["history"];

            AuditArchive audit = history.Where(p => p.SourceInfoId == Sourceinfoid && p.Id == idmain).SingleOrDefault();

            lb_sourceinfoid.Text = Sourceinfoid.ToString();
            lb_sourcename.Text = audit.SourceName;
            lb_created.Text = audit.CreatedBy;
            lb_passfail.Text = audit.SourcePass == true ? "Passed" : "Failed";
            lb_url.Text = audit.SourceUrl;

            grid1.Visible = true;
            pnl_main.Visible = true;
            grid1.DataSource = serv.GetAuditTestDataArchive(Sourceinfoid, idmain); ;
            grid1.DataBind();          
        }
    }
}