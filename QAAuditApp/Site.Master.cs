using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace QAAuditApp
{
    public partial class SiteMaster : MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            lb_path.Text = Request.Path.Replace("default.aspx", string.Empty);
            lb_path.Text = lb_path.Text.Substring(1, lb_path.Text.Length -1);
            lb_path.Text = lb_path.Text.Trim() == string.Empty ? "Home" : lb_path.Text.Replace("/", " > ");
        }

        public string LabelPath
        {
            get
            {
                return lb_path.Text;
            }
            set
            {
                lb_path.Text = value;
            }
        }
    }
}