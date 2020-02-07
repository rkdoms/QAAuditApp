using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.Text;

namespace QAAuditBusiness.Models
{
    [Serializable]
    [DataContract]
    public class AuditMain
    {
        public int SourceInfoId { get; set; }
        public string SourceType { get; set; }
        public string SourceName { get; set; }
        public bool SourcePass { get; set; }
        public DateTime LastAudited { get; set; }
        public int PriorityID { get; set; }
        public string PriorityName { get; set; }
        public int SourcePoints { get; set; }
        public bool SourceIsActive { get; set; }
        public int TimesAudited { get; set; }
        public int PendingAudit { get; set; }
        public IEnumerable<AuditTestData> TestData{ get; set; }
    }
}
