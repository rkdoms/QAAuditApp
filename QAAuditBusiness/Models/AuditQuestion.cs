using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.Text;

namespace QAAuditBusiness.Models
{
    [Serializable]
    [DataContract]
    public class AuditQuestions
    {
        public int Id { get; set; }
        public int QuestionNumber { get; set; }
        public string Question { get; set; }
        public string VerifiedBy { get; set; }
        public bool SourcePass { get; set; }
        public string VerifiedOn { get; set; }
        public string Notes { get; set; }
        public string TestRecordId { get; set; }
    }
}
