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
    public partial class Reports_Default2 : Page
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
            gv.DataSource = LoadData();
            gv.DataBind();
        }

        protected void RebindGrid(object sender, EventArgs e)
        {
            CreateGrid();
        }

    }
}