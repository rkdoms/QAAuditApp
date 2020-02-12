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
        public IEnumerable<AuditMain> GetAllAudit(bool loadTestData)
        {         
            IEnumerable<AuditMain> audits = dbClient.GetaAuditMain(0);
       
            if(loadTestData) getTestData(ref audits);

            return audits;
        }

        public IEnumerable<AuditQuestions> GetAuditQuestions(int Id)
        {
            return dbClient.GetAuditQuestions(Id);
        }

        public AuditMain GetAuditBySourceInfoId(int SourceInfoId, bool loadTestData)
        {
            IEnumerable<AuditMain> audits = dbClient.GetaAuditMain(SourceInfoId);

            if (loadTestData) getTestData(ref audits);

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

        public bool UpdateAuditQuestions(IEnumerable<AuditQuestions> questions)
        {
            return dbClient.UpdateAuditQuestions(questions);
        }

        private void getTestData(ref IEnumerable<AuditMain> audits)
        {
            foreach (AuditMain mainAudit in audits)
            {
                IEnumerable<AuditTestData> testdata = new List<AuditTestData>();
                testdata = dbClient.GetAuditTestData(mainAudit.SourceInfoId);
                mainAudit.TestData = testdata;
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
            return dbClient.InsertAuditArchive(SourceInfoId, CreatedBy);
        }

        public bool UpdateArchive(AuditArchive audit)
        {
            return dbClient.UpdateArchive(audit);
        }

        public IEnumerable<AuditTestDataArchive> GetAuditTestDataArchive(int SourceInfoId, int idMain)
        {
            return dbClient.GetAuditTestDataArchive(SourceInfoId, idMain);
        }

        public IEnumerable<AuditQuestionsArchive> GetAuditQuestionsArchive(int idMain, int idTestData)
        {
            return dbClient.GetAuditQuestionsArchive(idMain, idTestData);
        }
    }
}
