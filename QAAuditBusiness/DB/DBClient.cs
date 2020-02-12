using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using QAAuditBusiness.Models;

namespace QAAuditBusiness.DB
{
    public class DBClient
    {
        private readonly string cnxString = ConfigurationManager.ConnectionStrings["db"].ToString();
        internal IEnumerable<AuditMain> GetaAuditMain(int SourceInfoId = 0, DateTime? LastAudited = null)
        {
            SqlConnection conn = null;
            SqlDataReader dr = null;
            List<AuditMain> audits = new List<AuditMain>();

            try
            {
                conn = new SqlConnection(cnxString);
                conn.Open();
                SqlCommand cmd = new SqlCommand();
                cmd.Connection = conn;
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.CommandText = "dbo.QA_Audit_sel_main";

                cmd.Parameters.AddWithValue("@SourceInfoid", DbType.String).Value = SourceInfoId;
                cmd.Parameters.AddWithValue("@Last_Audited", DbType.DateTime).Value = LastAudited;

                using (dr = cmd.ExecuteReader())
                {
                    while (dr.HasRows && dr.Read())
                    {
                        AuditMain audit = new AuditMain();
                        audit.SourceInfoId = dr.GetInt32(0); 
                        audit.SourceType = dr.GetString(1);
                        audit.SourceName = dr.GetString(2);
                        audit.PriorityID = dr.GetInt32(3);
                        audit.SourcePoints = dr.GetInt32(4);
                        audit.LastAudited = dr.IsDBNull(5) ? DateTime.MinValue : dr.GetDateTime(5);
                        audit.SourceIsActive = dr.GetBoolean(6);
                        audit.SourcePass = dr.GetBoolean(7);
                        audit.TotalRecords = dr.GetInt32(8);
                        audit.PassedRecords = dr.GetInt32(10);//dr.GetInt32(9) failed records;                                          
                        audit.PriorityName = dr.GetString(11);                    
                        
                        audits.Add(audit);
                    }
                    dr.Close();
                }
            }
            catch (Exception e)
            { }
            finally
            {
                if (conn.State == ConnectionState.Open) conn.Close();
                
                if (conn != null)
                {
                    conn.Close();
                }
            }

            return audits;
        }

        internal IEnumerable<AuditQuestions> GetAuditQuestions(int Id)
        {
            SqlConnection conn = null;
            SqlDataReader dr = null;
            List<AuditQuestions> questions = new List<AuditQuestions>();

            try
            {
                conn = new SqlConnection(cnxString);
                conn.Open();
                SqlCommand cmd = new SqlCommand();
                cmd.Connection = conn;
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.CommandText = "dbo.QA_Audit_sel_question";

                cmd.Parameters.AddWithValue("@idtestdata", DbType.String).Value = Id;

                using (dr = cmd.ExecuteReader())
                {
                    while (dr.HasRows && dr.Read())
                    {
                        AuditQuestions q = new AuditQuestions();
                        q.Id = dr.GetInt32(0);
                        q.QuestionNumber = dr.GetInt32(1);
                        q.Question= dr.GetString(2);
                        q.SourcePass = dr.IsDBNull(3) ? false : dr.GetBoolean(3);
                        q.Notes = dr.IsDBNull(4) ? string.Empty : dr.GetString(4);
                        q.VerifiedBy = dr.IsDBNull(5) ? string.Empty : dr.GetString(5);
                        q.VerifiedOn = dr.IsDBNull(6) ? string.Empty : dr.GetString(6);
                        questions.Add(q);
                    }
                    dr.Close();
                }
            }
            catch (Exception e)
            { }
            finally
            {
                if (conn.State == ConnectionState.Open) conn.Close();

                if (conn != null)
                {
                    conn.Close();
                }
            }

            return questions;
        }

        internal IEnumerable<AuditArchive> GetAuditArchive(int SourceInfoId = 0, int id = 0, bool isActive = false)
        {
            SqlConnection conn = null;
            SqlDataReader dr = null;
            List<AuditArchive> archives = new List<AuditArchive>();

            try
            {
                conn = new SqlConnection(cnxString);
                conn.Open();
                SqlCommand cmd = new SqlCommand();
                cmd.Connection = conn;
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.CommandText = "dbo.QA_Audit_sel_main_archive";

                cmd.Parameters.AddWithValue("@SourceInfoid", DbType.String).Value = SourceInfoId;
                cmd.Parameters.AddWithValue("@id", DbType.Int32).Value = id;
                cmd.Parameters.AddWithValue("@isActive", DbType.Int32).Value = Convert.ToInt32(isActive);

                using (dr = cmd.ExecuteReader())
                {
                    while (dr.HasRows && dr.Read())
                    {
                        AuditArchive archive = new AuditArchive();
                        archive.Id = dr.GetInt32(0);
                        archive.SourceInfoId = dr.GetInt32(1);
                        archive.IsActive = dr.GetBoolean(2);
                        archive.StartTime = dr.GetDateTime(3);
                        archive.EndTime = dr.IsDBNull(4) ? DateTime.MinValue : dr.GetDateTime(4);
                        archive.CreatedBy = dr.GetString(5);
                        archive.SourcePass = dr.GetBoolean(6);
                        archives.Add(archive);
                    }
                    dr.Close();
                }
            }
            catch (Exception e)
            { }
            finally
            {
                if (conn.State == ConnectionState.Open) conn.Close();

                if (conn != null)
                {
                    conn.Close();
                }
            }

            return archives;
        }

        internal IEnumerable<AuditTestData> GetAuditTestData(int SourceInfoId, int id = 0)
        {
            SqlConnection conn = null;
            SqlDataReader dr = null;
            List<AuditTestData> testdata = new List<AuditTestData>(); ;
            try
            {
                conn = new SqlConnection(cnxString);
                conn.Open();
                SqlCommand cmd = new SqlCommand();
                cmd.Connection = conn;
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.CommandText = "dbo.QA_Audit_sel_test_data";

                cmd.Parameters.AddWithValue("@Sourceinfoid", DbType.Int32).Value = SourceInfoId;
                cmd.Parameters.AddWithValue("@id", DbType.Int32).Value = id;

                using (dr = cmd.ExecuteReader())
                {
                    while (dr.Read())
                    {
                        AuditTestData data = new AuditTestData();
                        data.Id = dr.GetInt32(0);
                        data.SourceInfoId = dr.GetInt32(1);
                        data.Names = dr.GetString(2);
                        data.DOB = dr.GetString(3);
                        data.CaseNumber = dr.GetString(4);
                        data.DataScript = dr.GetString(5);
                        data.Origin = dr.GetString(6);
                        data.CreatedOn = dr.GetDateTime(7);
                        data.SourcePass = dr.IsDBNull(8) ? false : dr.GetBoolean(8);
                        testdata.Add(data);
                    }
                    dr.Close();
                }

            }
            catch (Exception e)
            { }
            finally
            {
                if (conn.State == ConnectionState.Open) conn.Close();
               
                if (conn != null)
                {
                    conn.Close();
                }
            }

            return testdata;
        }

        internal bool UpdateAuditQuestions(IEnumerable<AuditQuestions> questions)
        {
            bool flag = false;
            SqlConnection conn = null;

            try
            {
                conn = new SqlConnection(cnxString);
                conn.Open();
                SqlCommand cmd = new SqlCommand();
                cmd.Connection = conn;
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.CommandText = "dbo.QA_Audit_upd_question";
                
                foreach(AuditQuestions q in questions)
                {
                    cmd.Parameters.Clear();
                    cmd.Parameters.AddWithValue("@id", DbType.Int32).Value = q.Id;
                    cmd.Parameters.AddWithValue("@QuestionNumber", DbType.Int32).Value = q.QuestionNumber;
                    cmd.Parameters.AddWithValue("@PassFail", DbType.Int32).Value = Convert.ToInt32(q.SourcePass);
                    cmd.Parameters.AddWithValue("@Notes", DbType.String).Value = q.Notes;
                    cmd.Parameters.AddWithValue("@VerifyBy", DbType.String).Value = q.VerifiedBy;

                    cmd.ExecuteNonQuery();
                }

                flag = true;

            }
            catch (Exception e)
            {
                flag = false;
            }
            finally
            {
                if (conn.State == ConnectionState.Open) conn.Close();
                if (conn != null)
                {
                    conn.Close();
                }
            }

            return flag;

        }

        internal bool UpdateAuditDetail(AuditQuestions audit)
        {
            bool flag = false;
            SqlConnection conn = null;

            try
            {
                conn = new SqlConnection(cnxString);
                conn.Open();
                SqlCommand cmd = new SqlCommand();
                cmd.Connection = conn;
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.CommandText = "dbo.QA_Audit_upd_secondary";

                cmd.Parameters.AddWithValue("@Sourceinfoid", DbType.String).Value = audit.Id;
                cmd.Parameters.AddWithValue("@QuestionNumber", DbType.Int32).Value = audit.QuestionNumber;
                cmd.Parameters.AddWithValue("@PassFail", DbType.Int32).Value = Convert.ToInt32(audit.SourcePass);
                cmd.Parameters.AddWithValue("@Notes", DbType.Int32).Value = audit.Notes;
                cmd.Parameters.AddWithValue("@VerifyBy", DbType.Int32).Value = audit.VerifiedBy;

                cmd.ExecuteNonQuery();
                flag = true;

            }
            catch (Exception e)
            {
                flag = false;
            }
            finally
            {
                if (conn.State == ConnectionState.Open) conn.Close();
                if (conn != null)
                {
                    conn.Close();
                }
            }

            return flag;
        }

        internal bool UpdateArchive(AuditArchive audit)
        {
            bool flag = false;
            SqlConnection conn = null;

            try
            {
                conn = new SqlConnection(cnxString);
                conn.Open();
                SqlCommand cmd = new SqlCommand();
                cmd.Connection = conn;
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.CommandText = "dbo.QA_Audit_upd_archive_main";

                cmd.Parameters.AddWithValue("@id", DbType.Int32).Value = audit.Id;
                cmd.Parameters.AddWithValue("@PassFail", DbType.Int32).Value = audit.SourcePass;
                cmd.Parameters.AddWithValue("@isActive", DbType.Int32).Value = audit.IsActive;
                cmd.Parameters.AddWithValue("@StartTime", DbType.Date).Value = audit.StartTime;
                cmd.Parameters.AddWithValue("@EndTime", DbType.Date).Value = audit.EndTime;

                cmd.ExecuteNonQuery();
                flag = true;

            }
            catch (Exception e)
            {
                flag = false;
            }
            finally
            {
                if (conn.State == ConnectionState.Open) conn.Close();
                if (conn != null)
                {
                    conn.Close();
                }
            }

            return flag;
        }

        internal bool InsertAuditArchive(int SourceInfoId, string CreatedBy)
        {
            bool flag = false;
            SqlConnection conn = null;

            try
            {
                conn = new SqlConnection(cnxString);
                conn.Open();
                SqlCommand cmd = new SqlCommand();
                cmd.Connection = conn;
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.CommandText = "dbo.QA_Audit_ins_main_archive";

                cmd.Parameters.AddWithValue("@Sourceinfoid", DbType.String).Value =SourceInfoId;
                cmd.Parameters.AddWithValue("@CreatedBy", DbType.Int32).Value = CreatedBy;

                cmd.ExecuteNonQuery();
                flag = true;

            }
            catch (Exception e)
            {
                flag = false;
            }
            finally
            {
                if (conn.State == ConnectionState.Open) conn.Close();
                if (conn != null)
                {
                    conn.Close();
                }
            }

            return flag;
        }

        internal bool UpdateAuditMain(AuditMain audit)
        {
            bool flag = false;
            SqlConnection conn = null;

            try
            {
                conn = new SqlConnection(cnxString);
                conn.Open();
                SqlCommand cmd = new SqlCommand();
                cmd.Connection = conn;
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.CommandText = "dbo.QA_Audit_upd_main";

                cmd.Parameters.AddWithValue("@Sourceinfoid", DbType.Int32).Value = audit.SourceInfoId;
                cmd.Parameters.AddWithValue("@PriorityName", DbType.String).Value = audit.PriorityName;
                cmd.Parameters.AddWithValue("@Points", DbType.Int32).Value = audit.SourcePoints;
                cmd.Parameters.AddWithValue("@SourceIsActive", DbType.Int32).Value = Convert.ToInt32(audit.SourceIsActive);                

                int result = cmd.ExecuteNonQuery();
                flag = true;

            }
            catch (Exception e)
            {
                flag = false;
            }
            finally
            {
                if (conn.State == ConnectionState.Open) conn.Close();                
                if (conn != null)
                {
                    conn.Close();
                }
            }

            return flag;
        }

        internal IEnumerable<Priority> GetAllPriority(int id =0)
        {
            SqlConnection conn = null;
            SqlDataReader dr = null;
            List<Priority> priorities = new List<Priority>();

            try
            {
                conn = new SqlConnection(cnxString);
                conn.Open();
                SqlCommand cmd = new SqlCommand();
                cmd.Connection = conn;
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.CommandText = "dbo.QA_Audit_sel_priority";

                cmd.Parameters.AddWithValue("@id", DbType.Int32).Value = id;

                using (dr = cmd.ExecuteReader())
                {
                    while (dr.Read())
                    {
                        Priority priority = new Priority();
                        priority.Id = dr.GetInt32(0);
                        priority.Name = dr.GetString(1);

                        priorities.Add(priority);
                    }
                    dr.Close();
                }

            }
            catch (Exception e)
            { }
            finally
            {
                if (conn.State == ConnectionState.Open) conn.Close();
                if (conn != null)
                {
                    conn.Close();
                }
            }

            return priorities;
        }

        internal IEnumerable<AuditTestDataArchive> GetAuditTestDataArchive(int SourceInfoId = 0, int id = 0)
        {
            SqlConnection conn = null;
            SqlDataReader dr = null;
            List<AuditTestDataArchive> archives = new List<AuditTestDataArchive>();

            try
            {
                conn = new SqlConnection(cnxString);
                conn.Open();
                SqlCommand cmd = new SqlCommand();
                cmd.Connection = conn;
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.CommandText = "dbo.QA_Audit_sel_archive_test_data";

                cmd.Parameters.AddWithValue("@SourceInfoid", DbType.String).Value = SourceInfoId;
                cmd.Parameters.AddWithValue("@id", DbType.Int32).Value = id;

                using (dr = cmd.ExecuteReader())
                {
                    while (dr.HasRows && dr.Read())
                    {
                        AuditTestDataArchive archive = new AuditTestDataArchive();
                        archive.Id = dr.GetInt32(0);
                        archive.IdMain = dr.GetInt32(1);
                        archive.SourceInfoId = dr.GetInt32(2);
                        archive.Names = dr.GetString(3);
                        archive.DOB = dr.GetString(4);
                        archive.CaseNumber = dr.GetString(5);
                        archive.DataScript = dr.GetString(6);
                        archive.Origin = dr.GetString(7);
                        archive.CreatedOn = dr.IsDBNull(8) ? DateTime.MinValue : dr.GetDateTime(8);
                        archive.SourcePass = dr.IsDBNull(9) ? false : dr.GetBoolean(9);
                        archives.Add(archive);
                    }
                    dr.Close();
                }
            }
            catch (Exception e)
            { }
            finally
            {
                if (conn.State == ConnectionState.Open) conn.Close();

                if (conn != null)
                {
                    conn.Close();
                }
            }

            return archives;
        }

        internal IEnumerable<AuditQuestionsArchive> GetAuditQuestionsArchive(int idmain = 0, int idtestdata = 0)
        {
            SqlConnection conn = null;
            SqlDataReader dr = null;
            List<AuditQuestionsArchive> archives = new List<AuditQuestionsArchive>();

            try
            {
                conn = new SqlConnection(cnxString);
                conn.Open();
                SqlCommand cmd = new SqlCommand();
                cmd.Connection = conn;
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.CommandText = "dbo.QA_Audit_sel_archive_question";

                cmd.Parameters.AddWithValue("@idmain", DbType.String).Value = idmain;
                cmd.Parameters.AddWithValue("@idtestdata", DbType.Int32).Value = idtestdata;

                using (dr = cmd.ExecuteReader())
                {
                    while (dr.HasRows && dr.Read())
                    {
                        AuditQuestionsArchive archive = new AuditQuestionsArchive();
                        archive.Id = dr.GetInt32(1);
                        archive.IdMain = dr.GetInt32(0);
                        archive.QuestionNumber = dr.GetInt32(2);
                        archive.Question = dr.GetString(3);
                        archive.SourcePass = dr.IsDBNull(4) ? false : dr.GetBoolean(4);
                        archive.Notes = dr.IsDBNull(5) ? string.Empty : dr.GetString(5);
                        archive.VerifiedBy = dr.IsDBNull(6) ? string.Empty : dr.GetString(6);
                        archive.VerifiedOn = dr.IsDBNull(7) ? string.Empty : dr.GetString(7);
                        archives.Add(archive);
                    }
                    dr.Close();
                }
            }
            catch (Exception e)
            { }
            finally
            {
                if (conn.State == ConnectionState.Open) conn.Close();

                if (conn != null)
                {
                    conn.Close();
                }
            }

            return archives;
        }

    }
}
