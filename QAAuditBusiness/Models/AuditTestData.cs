using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.Text;

namespace QAAuditBusiness.Models
{
    [Serializable]
    [DataContract]
    public class AuditTestData
    {
        public int Id { get; set; }
        public int SourceInfoId { get; set; }
        public string Names { get; set; }
        public string DOB { get; set; }
        public string CaseNumber { get; set; }
        public string DataScript { get; set; }
        public string SourceUrl { get; set; }
        public string Origin { get; set; }
        public DateTime CreatedOn { get; set; }
        public bool SourcePass { get; set; }
        public bool Answered{ get; set; }
        public IEnumerable<AuditQuestions> Question { get; set; }
        public string QuestionJson { get; set; }
    }

    public class AuditTestDataArchive : AuditTestData
    {
        public int IdMain { get; set; }
    }
}
