CREATE VIEW [DV].[Fact_Activity] AS WITH cte_act AS 
(
SELECT
CONVERT(CHAR(66),ISNULL(ASAT.ActivityHash,CAST(0x0 AS BINARY(32))),1) AS ActivityHash
,'ADAPT.PROP_ACTIVITY_GEN' AS RecordSource
,CONVERT(CHAR(66),ISNULL(LAC.CaseHash,CAST(0x0 AS BINARY(32))),1) AS CaseHash
,CASE WHEN ASAT.ActivityType IS NULL THEN CONVERT(CHAR(66),ISNULL(NULL,CAST(0x0 AS BINARY(32))),1) ELSE CONVERT(CHAR(66),CAST(HASHBYTES('SHA2_256',CAST(CAST(ASAT.ActivityType AS BIGINT) AS VARCHAR)) AS BINARY(32)),1) END AS ActivityTypeHash
,CONVERT(CHAR(66),ISNULL(NULL,CAST(0x0 AS BINARY(32))),1) AS ActivityOwningEmployeeHash
,CONVERT(CHAR(66),ISNULL(NULL,CAST(0x0 AS BINARY(32))),1) AS ActivityCreatedByEmployeeHash
,CONVERT(CHAR(66),ISNULL(NULL,CAST(0x0 AS BINARY(32))),1) AS ActivityCompletedByEmployeeHash
,CASE WHEN ASAT.ActivityStatus IS NULL THEN CONVERT(CHAR(66),ISNULL(NULL,CAST(0x0 AS BINARY(32))),1) ELSE CONVERT(CHAR(66),CAST(HASHBYTES('SHA2_256',CAST(CAST(ASAT.ActivityStatus AS BIGINT) AS VARCHAR)) AS BINARY(32)),1) END AS ActivityStatusHash
,CONVERT(CHAR(66),ISNULL(NULL,CAST(0x0 AS BINARY(32))),1) AS EmploymentSiteHash
,CONVERT(CHAR(66),ISNULL(NULL,CAST(0x0 AS BINARY(32))),1) AS RequestorStatusHash
,CASE WHEN ASAT.ActivityHoursSpent IS NULL THEN 0 ELSE ASAT.ActivityHoursSpent END AS ActivityHoursSpent
,CASE WHEN ASAT.ActivityHoursScheduled IS NULL THEN 0 ELSE ASAT.ActivityHoursScheduled END AS ActivityHoursScheduled
,-1 AS ActivityAddedDateKey
,CASE WHEN ASAT.ActivityStartDate IS NULL THEN -1 ELSE CAST(CONVERT(CHAR(8),ASAT.ActivityStartDate,112) AS INT)END AS ActivityStartDateKey
,-1 AS ActivityStartTimeKey
,-1 AS ActivityDueTimeKey
,CASE WHEN ASAT.ActivityCompleteDate IS NULL THEN -1 ELSE CAST(CONVERT(CHAR(8),ASAT.ActivityCompleteDate,112) AS INT)END AS ActivityCompleteDateKey
,-1 AS ActivityCompletedTimeKey
,-1 AS ActivityLastUpdatedDate
,1 AS IsActivity
,CASE WHEN ASAT.ActivityStatus = '8252582' THEN 1 ELSE 0 END AS IsOpenActivity
,CASE WHEN ASAT.ActivityStatus IN ('99998270421','8253525','99998270420','8252581') THEN 1 ELSE 0 END AS IsClosedActivity
,CASE WHEN ASAT.ActivityDueDate IS NULL THEN -1 ELSE CAST(CONVERT(CHAR(8),ASAT.ActivityDueDate,112) AS INT)END AS ActivityDueDateKey
,CASE WHEN ASAT.ActivityHoursScheduled IS NULL THEN 0 ELSE (ASAT.ActivityHoursScheduled * 60) END AS BookedDurationMinutes
,NULL AS ActivityIsActionPlanComplete
,NULL AS IsRebooked
,CASE WHEN ASAT.ActivityIsMandatory = 'Yes' THEN 1 ELSE 0 END AS ActivityIsMandatory
,CASE WHEN ASAT.ActivityIsLTURelated = 'Yes' THEN 1 ELSE 0 END AS ActivityIsLTURelated
,CASE WHEN ASAT.ActivityIsNEORelated = 'Yes' THEN 1 ELSE 0 END AS ActivityIsNEORelated
,NULL AS IsAttended
,NULL AS IsDidNotAttend
,NULL AS IsCancelled
,NULL AS IsMethodF2F
,NULL AS TotalDNA
,NULL AS IsMethodF2FAttended
,NULL AS IsAttendedWithCE
,NULL AS IsMethodF2FDidNotAttended
FROM DV.SAT_Activity_Adapt_Core ASAT
LEFT JOIN DV.LINK_Case_Activity LAC ON LAC.ActivityHash = ASAT.ActivityHash
LEFT JOIN DV.SAT_Entity_SoftDelete_Adapt_Core SESAC ON SESAC.EntityHash = ASAT.ActivityHash AND SESAC.IsCurrent = 1
WHERE
ASAT.IsCurrent = 1
AND SESAC.EntityHash IS NULL
UNION ALL
SELECT
CONVERT(CHAR(66),ISNULL(S_IA.ActivityHash,CAST(0x0 AS BINARY(32))),1) AS ActivityHash
,'ICONI.Meeting' AS RecordSource
,CONVERT(CHAR(66),ISNULL(L_CA.CaseHash,CAST(0x0 AS BINARY(32))),1) AS CaseHash
,CONVERT(CHAR(66),ISNULL(S_IA.ActivityType,CAST(0x0 AS BINARY(32))),1)  AS ActivityTypeHash
,CONVERT(CHAR(66),ISNULL(S_IA.ActivityOwningEmployee,CAST(0x0 AS BINARY(32))),1) AS ActivityOwningEmployeeHash
,CONVERT(CHAR(66),ISNULL(NULL,CAST(0x0 AS BINARY(32))),1) AS ActivityCreatedByEmployeeHash
,CONVERT(CHAR(66),ISNULL(NULL,CAST(0x0 AS BINARY(32))),1) AS ActivityCompletedByEmployeeHash
,CASE WHEN S_IA.ActivityStatus IS NULL THEN CONVERT(CHAR(66),ISNULL(NULL,CAST(0x0 AS BINARY(32))),1) ELSE CONVERT(CHAR(66),CAST(HASHBYTES('SHA2_256',CAST(S_IA.ActivityStatus AS VARCHAR)) AS BINARY(32)),1) END AS ActivityStatusHash
,CONVERT(CHAR(66),ISNULL(L_AES.EmploymentSiteHash,CAST(0x0 AS BINARY(32))),1) AS EmploymentSiteHash
,CONVERT(CHAR(66),ISNULL(NULL,CAST(0x0 AS BINARY(32))),1) AS RequestorStatusHash
,NULL AS ActivityHoursSpent
,NULL AS ActivityHoursScheduled
,CASE WHEN S_IA.meet_added_date IS NULL THEN -1 ELSE CAST(CONVERT(CHAR(8),S_IA.meet_added_date,112) AS INT)END AS ActivityAddedDateKey
,CASE WHEN S_IA.ActivityStartDate IS NULL THEN -1 ELSE CAST(CONVERT(CHAR(8),S_IA.ActivityStartDate,112) AS INT)END AS ActivityStartDateKey
,NULL AS ActivityStartTimeKey
,-1 AS ActivityDueDateKey
,NULL AS ActivityDueTimeKey 
,CASE WHEN S_IA.ActivityCompletedDate IS NULL THEN -1 ELSE CAST(CONVERT(CHAR(8),S_IA.ActivityCompletedDate,112) AS INT)END AS ActivityCompletedDateKey
,NULL AS ActivityCompletedTimeKey 
,CASE WHEN S_IA.LastUpdatedDate IS NULL THEN -1 ELSE CAST(CONVERT(CHAR(8),S_IA.LastUpdatedDate,112) AS INT)END AS ActivityLastUpdatedDateKey
,1 AS IsActivity
,CASE WHEN S_IA.ActivityCompletedDate IS NULL THEN 1 ELSE 0 END AS IsOpenActivity
,CASE WHEN S_IA.ActivityCompletedDate IS NOT NULL THEN 1 ELSE 0 END AS IsClosedActivity
,S_IA.ActivityBookedDuration AS BookedDurationMinutes
,CASE WHEN ISNULL(S_IA.ActivityIsActionPlanComplete, '') = '' THEN -1 WHEN S_IA.ActivityIsActionPlanComplete = 'Yes' THEN 1 WHEN S_IA.ActivityIsActionPlanComplete = 'No' THEN 0 END AS ActivityIsActionPlanComplete
,CASE WHEN ISNULL(S_IA.ActivityIsRebooked, '') = '' THEN -1 WHEN S_IA.ActivityIsRebooked = 'Yes' THEN 1 WHEN S_IA.ActivityIsRebooked = 'No' THEN 0 END AS IsRebooked
,CASE WHEN ISNULL(S_IA.ActivityIsMandatory, '') = '' THEN -1 WHEN S_IA.ActivityIsMandatory = 'Yes' THEN 1 WHEN S_IA.ActivityIsMandatory = 'No' THEN 0 END AS ActivityIsMandatory
,NULL AS ActivityIsLTURelated
,NULL AS ActivityIsNEORelated
,CASE WHEN S_IA.ActivityStatus = 'Attended' THEN 1 ELSE 0 END IsAttended
,CASE WHEN S_IA.ActivityStatus = 'Did Not Attend' THEN 1 ELSE 0 END IsDidNotAttend
,CASE WHEN S_IA.ActivityStatus = 'Cancelled' THEN 1 ELSE 0 END IsCancelled
,CASE WHEN S_IA.ActivityContactMethod = 'Face-to-Face' THEN 1 ELSE 0 END IsMethodF2F
,CASE WHEN S_IA.ActivityCompletedDate IS NOT NULL THEN CASE WHEN S_IA.ActivityDidNotAttendReason = 'NA' THEN 1 ELSE 0 END ELSE 0 END TotalDNA
,NULL AS IsMethodF2FAttended
,NULL AS IsAttendedWithCE
,NULL AS IsMethodF2FDidNotAttended
FROM DV.SAT_Activity_Iconi_Core S_IA
LEFT JOIN DV.LINK_Case_Activity L_CA ON S_IA.ActivityHash = L_CA.ActivityHash
LEFT JOIN DV.LINK_Activity_EmploymentSite L_AES ON S_IA.ActivityHash = L_AES.ActivityHash
WHERE
S_IA.IsCurrent = 1
)
SELECT distinct
a.ActivityHash
,a.RecordSource
,fcb.ParticipantHash
,fcb.CaseHash
,fcb.EmployeeHash
,a.ActivityTypeHash
,a.ActivityOwningEmployeeHash
,a.ActivityCreatedByEmployeeHash
,a.ActivityCompletedByEmployeeHash
,a.ActivityStatusHash
,a.EmploymentSiteHash
,fcb.ReferralHash
,fcb.ProgrammeHash
,fcb.DeliverySiteHash
,fcb.CaseStatusHash
,a.RequestorStatusHash
,a.ActivityHoursSpent
,a.ActivityHoursScheduled
,fcb.ReferralDateKey
,fcb.StartDateKey
,fcb.StartVerifiedDateKey AS 'VerifiedDateKey'
,fcb.LeaveDateKey
,fcb.ProjectedLeaveDateKey
,a.ActivityAddedDateKey
,a.ActivityStartDateKey
,a.ActivityStartTimeKey
,a.ActivityDueDateKey
,a.ActivityDueTimeKey
,a.ActivityCompleteDateKey
,a.ActivityCompletedTimeKey
,a.ActivityLastUpdatedDate
,a.IsActivity
,a.IsOpenActivity
,a.IsClosedActivity
,a.BookedDurationMinutes
,a.ActivityIsActionPlanComplete
,a.IsRebooked
,a.ActivityIsMandatory
,a.ActivityIsLTURelated
,a.ActivityIsNEORelated
,a.IsAttended
,a.IsDidNotAttend
,a.IsCancelled
,a.IsMethodF2F
,fcb.StartDateKey AS 'ContractEntryDate'
,a.TotalDNA
,a.IsMethodF2FAttended
,a.IsAttendedWithCE
,a.IsMethodF2FDidNotAttended
FROM DV.Fact_Case_Base fcb
INNER JOIN cte_act a ON a.CaseHash = fcb.CaseHash;
GO
