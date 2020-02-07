using Newtonsoft.Json;
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
        [JsonProperty("Id")]
        public int Id { get; set; }
        [JsonProperty("QuestionNumber")]
        public int QuestionNumber { get; set; }
        [JsonProperty("Question")]
        public string Question { get; set; }
        [JsonProperty("VerifiedBy")]
        public string VerifiedBy { get; set; }
        [JsonProperty("SourcePass")]
        public bool SourcePass { get; set; }
        [JsonProperty("VerifiedOn")]
        public string VerifiedOn { get; set; }
        [JsonProperty("Notes")]
        public string Notes { get; set; }
    }
}
