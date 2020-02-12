using QAAuditBusiness;
using QAAuditBusiness.Implementation;
using QAAuditBusiness.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Script.Serialization;
using Newtonsoft.Json;

namespace QAAuditApp.Ajax
{
    public partial class HistoryQuestions : System.Web.UI.Page
    {
        private readonly IAudit serv = new Audit();
        protected void Page_Load(object sender, EventArgs e)
        {
            int idtestdata, idmain = 0;
            Int32.TryParse(Request.QueryString.Get("idtestdata"), out idtestdata);
            Int32.TryParse(Request.QueryString.Get("idmain"), out idmain);
            string json = string.Empty;

            IEnumerable<AuditQuestionsArchive> questions = serv.GetAuditQuestionsArchive(idmain, idtestdata);            

            json = new JavaScriptSerializer().Serialize(questions);// JsonConvert.SerializeObject(questions, settings);  //;

            Response.Write(json);
        }
    }
}