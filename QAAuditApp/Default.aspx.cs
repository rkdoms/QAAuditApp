using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using QAAuditBusiness;
using QAAuditBusiness.Implementation;
using QAAuditBusiness.Models;

namespace QAAuditApp
{
    public partial class _Default : Page
    {
        private readonly IAudit serv = new Audit();
        protected void Page_Load(object sender, EventArgs e)
        {
            Response.Redirect("/AuditQueue");
            //if (!Page.IsPostBack)
            //{
            //   IEnumerable<AuditMain> audits = serv.GetAllAudit(false);
            //   AuditMain audit = serv.GetAuditBySourceInfoId(2224, true);
            //}
        }
    }
}