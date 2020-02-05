using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.Text;

namespace QAAuditBusiness.Models
{
    [Serializable]
    [DataContract]
    public class AuditArchive
    {
        public int Id { get; set; }
        public int SourceInfoId { get; set; }
        public AuditMain AuditMain { get; set; }
        public DateTime StartTime { get; set; }
        public DateTime EndTime { get; set; }
        public bool SourcePass { get; set; }
        public bool IsActive { get; set; }
        public string CreatedBy { get; set; }
    }
}
