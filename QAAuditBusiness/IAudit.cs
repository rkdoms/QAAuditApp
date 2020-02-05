using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.ServiceModel;
using System.Text;
using QAAuditBusiness.Models;

namespace QAAuditBusiness
{

    [ServiceContract]
    public interface IAudit
    {
        [OperationContract]
        IEnumerable<AuditMain> GetAllAudit(bool loadDetail);
        [OperationContract]
        AuditMain GetAuditBySourceInfoId(int SourceInfoId, bool loadDetail);
        [OperationContract]
        bool UpdateAuditMain(AuditMain audit);
        [OperationContract]
        bool UpdateAuditDetail(AuditDetail audit);
        [OperationContract]
        IEnumerable<Priority> GetAllPriority();
        [OperationContract]
        Priority GetPriorityById(int id);
        [OperationContract]
        AuditArchive GetActiveArchive(int SourceInfoId, int id);
        AuditArchive GetArchive(int id);
        IEnumerable<AuditArchive> GetAllArchive(int SourceInfoId, bool isActive);
        bool InsertArchiveAudit(int SourceInfoId, string CreatedBy);
        bool UpdateArchive(AuditArchive audit);
    }
}
