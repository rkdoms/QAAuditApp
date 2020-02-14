using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using QAAuditBusiness;
using QAAuditBusiness.Implementation;
using QAAuditBusiness.Models;
using Newtonsoft.Json;


namespace QAAuditApp
{
    public partial class Details : Page
    {
        int Sourceinfoid = 0;
        private readonly IAudit serv = new Audit();
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {            
                Int32.TryParse(Request.QueryString.Get("Sourceinfoid"), out Sourceinfoid);
                //Sourceinfoid = 2224;
                if (Sourceinfoid == 0) Response.Redirect("Default.aspx", true);
                else
                {
                    lnk_see_all.NavigateUrl = lnk_see_all.NavigateUrl + "?SourceInfoid=" + Sourceinfoid.ToString();
                    IEnumerable<AuditArchive> history = serv.GetAllArchive(Sourceinfoid).Take(3);
                    gv_lastest.DataSource = history;
                    gv_lastest.DataBind();

                    AuditArchive activeArchive = serv.GetActiveArchive(Sourceinfoid, 0);
                    if (activeArchive != null)
                    {
                        startTimeActive.Value = activeArchive.StartTime.ToString("dd-MM-yyyy HH:mm:ss");
                        endTimeActive.Value = activeArchive.EndTime.ToString("dd-MM-yyyy HH:mm:ss");
                    }
                    if (activeArchive != null && activeArchive.EndTime > DateTime.Now)
                    {
                        CreateGridAndHeaderInfo(true);
                    }
                    else
                    {
                        if (activeArchive != null)
                        {
                            activeArchive.IsActive = false;
                            serv.UpdateArchive(activeArchive);
                            Response.Redirect(Request.RawUrl);
                        }

                        btn_confirm_start_audit.Visible = true;                       
                        AuditMain audit = serv.GetAuditBySourceInfoId(Sourceinfoid, true);
                        lb_sourceinfoid.Text = Sourceinfoid.ToString();
                        lb_sourcename.Text = audit.SourceName;
                        lb_sourcetype.Text = audit.SourceType;
                        lb_lastaudited.Text = audit.LastAudited.ToString(); ;
                        lb_passfail.Text = audit.SourcePass == true ? "Passed" : "Failed";
                        lb_url.Text = audit.SourceUrl;
                    }
                }
            }
        }

        protected void CreateGridAndHeaderInfo(bool headerInfo = false)
        {
            Int32.TryParse(Request.QueryString.Get("Sourceinfoid"), out Sourceinfoid);
            //Sourceinfoid = 2224;
            AuditMain audit = serv.GetAuditBySourceInfoId(Sourceinfoid, true);
            //todo: if all qstns are passed, show finishing answering button.
            if (headerInfo)
            {
                lb_sourceinfoid.Text = Sourceinfoid.ToString();
                lb_sourcename.Text = audit.SourceName;
                lb_sourcetype.Text = audit.SourceType;
                lb_lastaudited.Text = audit.LastAudited.ToString(); ;
                lb_passfail.Text = audit.SourcePass == true ? "Passed" : "Failed";
            }
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
                serv.UpdateAuditQuestions(result, Session["UserName"].ToString());                                   
            }
            catch(Exception err)
            { }
        }
        
        protected void btn_start_audit_Click(object sender, EventArgs e)
        {
            Int32.TryParse(Request.QueryString.Get("Sourceinfoid"), out Sourceinfoid);
            //Sourceinfoid = 2224;
            if (serv.InsertArchiveAudit(Sourceinfoid, Session["UserName"].ToString()))
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
                activeArchive.SourcePass = Convert.ToBoolean(auditStatus.Value);
                activeArchive.EndTime = DateTime.Now;
                activeArchive.QATeamNotes = txt_qa_team_notes.Text;
                serv.UpdateArchive(activeArchive);
                Response.Redirect(Request.RawUrl);
            }
        }

    }
}