CREATE VIEW [DV].[Fact_Correspondence] AS WITH correspondence AS 
(
SELECT
CONVERT(CHAR(66),ISNULL(SCAC.CorrespondenceHash,CAST(0x0 AS BINARY(32))),1) AS CorrespondenceHash
,'ADAPT.PROP_WP_COM' AS RecordSource
,LCC.CaseHash AS CaseHash
,CASE WHEN SCAC.CorrespondenceContactBy IS NULL THEN CONVERT(CHAR(66),ISNULL(NULL,CAST(0x0 AS BINARY(32))),1) ELSE CONVERT(CHAR(66),CAST(HASHBYTES('SHA2_256',CAST(CAST(SCAC.CorrespondenceContactBy AS BIGINT) AS VARCHAR)) AS BINARY(32)),1) END AS CorrespondenceContactBy
,CASE WHEN SCAC.CorrespondenceDate IS NULL THEN -1 ELSE CAST(CONVERT(CHAR(8),SCAC.CorrespondenceDate,112) AS INT) END AS CorrespondenceDateKey
FROM DV.SAT_Correspondence_Adapt_Core SCAC
LEFT JOIN DV.LINK_Case_Correspondence LCC ON LCC.CorrespondenceHash = SCAC.CorrespondenceHash
LEFT JOIN DV.SAT_Entity_SoftDelete_Adapt_Core SESAC ON SESAC.EntityKey = SCAC.CorrespondenceReferenceKey AND SESAC.IsCurrent = 1
WHERE
SCAC.IsCurrent = 1
AND SESAC.EntityKey IS NULL
)
SELECT
c.CorrespondenceHash
,c.RecordSource
,fcb.CaseHash
,fcb.ParticipantHash
,fcb.EmployeeHash
,fcb.DeliverySiteHash
,c.CorrespondenceContactBy
,fcb.ProgrammeHash
,fcb.CaseStatusHash
,fcb.ReferralStatusHash
,fcb.ReferralDateKey
,fcb.StartDateKey
,fcb.StartVerifiedDateKey AS VerifiedDateKey
,fcb.LeaveDateKey
,fcb.ProjectedLeaveDateKey
,c.CorrespondenceDateKey
FROM DV.Fact_Case_Base fcb
INNER JOIN correspondence c ON c.CaseHash = fcb.Fact_Case_Base_CaseHash;
GO