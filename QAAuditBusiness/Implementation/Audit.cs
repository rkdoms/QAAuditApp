using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using QAAuditBusiness.Models;
using QAAuditBusiness.DB;

namespace QAAuditBusiness.Implementation
{
    public class Audit : IAudit
    {
        private readonly DBClient dbClient = new DBClient();
        public IEnumerable<AuditMain> GetAllAudit(bool loadDetail)
        {         
            IEnumerable<AuditMain> audits = dbClient.GetaAuditMain(0);
       
            if(loadDetail) getDetail(ref audits);

            return audits;
        }

        public AuditMain GetAuditBySourceInfoId(int SourceInfoId, bool loadDetail)
        {
            IEnumerable<AuditMain> audits = dbClient.GetaAuditMain(SourceInfoId);

            if (loadDetail) getDetail(ref audits);

            return audits.SingleOrDefault();
        }

        public IEnumerable<Priority> GetAllPriority()
        {
            return dbClient.GetAllPriority(0);
        }

        public Priority GetPriorityById(int id)
        {
            return dbClient.GetAllPriority(id).SingleOrDefault();
        }

        public bool UpdateAuditMain(AuditMain audit)
        {
           return dbClient.UpdateAuditMain(audit);
        }

        public bool UpdateAuditDetail(AuditDetail audit)
        {
            return dbClient.UpdateAuditDetail(audit);
        }

        private void getDetail(ref IEnumerable<AuditMain> audits)
        {
            foreach (AuditMain mainAudit in audits)
            {
                IEnumerable<AuditDetail> details = new List<AuditDetail>();
                details = dbClient.GetAuditDetails(mainAudit.SourceInfoId);
                mainAudit.AuditDetail = details;
            }
        }

        public AuditArchive GetActiveArchive(int SourceInfoId, int id)
        {
            return dbClient.GetAuditArchive(SourceInfoId, id, true).SingleOrDefault();
        }

        public AuditArchive GetArchive(int id)
        {
            return dbClient.GetAuditArchive(0, id, false).First();
        }

        public IEnumerable<AuditArchive> GetAllArchive(int SourceInfoId, bool isActive)
        {
            return dbClient.GetAuditArchive(SourceInfoId, 0, false);
        }

        public bool InsertArchiveAudit(int SourceInfoId, string CreatedBy)
        {
            return dbClient.UpdateAuditArchive(SourceInfoId, CreatedBy);
        }

        public bool UpdateArchive(AuditArchive audit)
        {
            return dbClient.UpdateArchive(audit);
        }

    }
}
