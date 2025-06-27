CREATE VIEW [DV].[Base_Activity_Iconi] AS SELECT 
CONVERT(CHAR(66),A.ActivityHash,1) AS ActivityHash,
CAST(A.RecordSource AS NVARCHAR(MAX)) AS RecordSource,
CAST(AC.ActivityID AS NVARCHAR(MAX)) AS ActivityID,
AC.ActivityContactMethod,
CAST('Unknown' AS NVARCHAR(MAX)) AS ActivityName,
AC.ActivityOtherEmployee,
AC.ActivityLocation,
AC.ActivityLevel,
AC.AttendanceReasonOther,
CAST('Unknown' AS NVARCHAR(MAX)) AS ActivityRelatedSupportNeed,
CAST('Unknown' AS NVARCHAR(MAX)) AS ActivityRelatedAssignment,
CAST('Unknown' AS NVARCHAR(MAX)) AS ActivityDescription,
CAST('Unknown' AS NVARCHAR(MAX)) AS ActivityOutcome,
CAST('Unknown' AS NVARCHAR(MAX)) AS ActivityVenue
FROM DV.HUB_Activity A
LEFT JOIN DV.SAT_Activity_Iconi_Core AC ON A.ActivityKey = AC.ActivityKey
WHERE A.RecordSource = 'ICONI.Meeting';
GO


