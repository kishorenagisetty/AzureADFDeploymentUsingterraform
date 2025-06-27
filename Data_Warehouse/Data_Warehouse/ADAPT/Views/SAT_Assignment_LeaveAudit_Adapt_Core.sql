CREATE VIEW [ADAPT].[SAT_Assignment_LeaveAudit_Adapt_Core] AS (
SELECT
CONCAT_WS('|','ADAPT',CAST(Job_ID AS INT))	AS AssignmentKey,
CONCAT_WS('|','ADAPT',CAST(Programme_ID AS INT)) AS CaseKey,
AuditDate,
LeaveDate,
LeaveReason,
ValidFrom,
ValidTo,
IsCurrent
FROM ADAPT.RemployCreated_JobLeaveAudit
)