using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace QAAuditApp.Ajax
{
    public partial class Questions : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            string id = Request.QueryString.Get("id");
            string json = string.Empty;

            switch(id)
            {
                case "1":
                    json = @"{""AuditQuestion"":[{""Id"":1,""Question"":""is simply dummy text of the printing and typesetting industry. is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s"",""Notes"":""n1""},{""Id"":2,""Question"":""is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s"",""Notes"":""n2""},{""Id"":3,""Question"":""is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s"",""Notes"":""""},{""Id"":4,""Question"":""q4"",""Notes"":""n4""},{""Id"":5,""Question"":""q5"",""Notes"":""n5""}]}";
                    break;
                default:
                    json = @"{""AuditQuestion"":[{""Id"":1,""Question"":""q1fg"",""Notes"":""n1fdg""},{""Id"":2,""Question"":""q2345"",""Notes"":""n2345""}]}";
                    break;
            }
            
            Response.Write(json);
        }
    }
}