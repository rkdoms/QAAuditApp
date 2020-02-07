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
    public partial class Questions : System.Web.UI.Page
    {
        private readonly IAudit serv = new Audit();
        protected void Page_Load(object sender, EventArgs e)
        {
            int id = 0;
            Int32.TryParse(Request.QueryString.Get("id"), out id);
            string json = string.Empty;

            IEnumerable<AuditQuestions> questions = serv.GetAuditQuestions(id);            

            json = new JavaScriptSerializer().Serialize(questions);// JsonConvert.SerializeObject(questions, settings);  //;

            Response.Write(json);
        }
    }
}