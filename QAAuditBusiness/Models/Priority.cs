using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.Text;

namespace QAAuditBusiness.Models
{
    [Serializable]
    [DataContract]
    public class Priority
    {
        public int Id { get; set; }
        public string Name { get; set; }
    }
}
