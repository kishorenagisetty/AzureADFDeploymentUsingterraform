CREATE VIEW [DV].[Base_Activity_Adapt] AS SELECT
CONVERT(CHAR(66),ISNULL(A.ActivityHash,CAST(0x0 AS BINARY(32))),1) AS ActivityHash
,'ADAPT.PROP_ACTIVITY_GEN' AS RecordSource
,CAST(A_AC.ActivityKey AS NVARCHAR(MAX)) AS ActivityID
,R_BN3.[Description] AS ActivityContactMethod
,A_AC.ActivityName 
,CAST('Unknown' AS NVARCHAR(MAX)) AS ActivityOtherEmployee
,CAST('Unknown' AS NVARCHAR(MAX)) AS ActivityLocation
,CAST('Unknown' AS NVARCHAR(MAX)) AS ActivityLevel
,CAST('Unknown' AS NVARCHAR(MAX)) AS AttendanceReasonOther
,A_AC.ActivityRelatedSupportNeed
,R_BN1.[Description] AS ActivityRelatedAssignment
,A_AC.ActivityDescription
,R_BN2.[Description] AS ActivityOutcome
,A_AC.ActivityVenue
FROM DV.HUB_Activity A
INNER JOIN DV.SAT_Activity_Adapt_Core A_AC ON A_AC.ActivityHash = A.ActivityHash AND A_AC.IsCurrent = '1'
LEFT JOIN DV.Dimension_References R_BN1 ON R_BN1.Code = A_AC.ActivityRelatedAssignment AND R_BN1.ReferenceSource = 'ADAPT.MD_MULTI_NAMES' AND R_BN1.Category = 'Code'
LEFT JOIN DV.Dimension_References R_BN2 ON R_BN2.Code = A_AC.ActivityOutcome AND R_BN2.ReferenceSource = 'ADAPT.MD_MULTI_NAMES' AND R_BN2.Category = 'Code'
LEFT JOIN DV.Dimension_References R_BN3 ON R_BN3.Code = A_AC.ActivityContactMethod AND R_BN3.ReferenceSource = 'ADAPT.MD_MULTI_NAMES' AND R_BN3.Category = 'Code'
WHERE 
A.RecordSource = 'ADAPT.PROP_ACTIVITY_GEN';
GO