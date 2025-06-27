CREATE VIEW [DV].[Fact_DocumentUpload]
AS SELECT
CONVERT(CHAR(66),ISNULL(D.DocumentUploadHash,CAST(0x0 AS BINARY(32))),1) AS DocumentUploadHash,
D.RecordSource,
CONVERT(CHAR(66),ISNULL(CDU.CaseHash,CAST(0x0 AS BINARY(32))),1) AS CaseHash,
CONVERT(CHAR(66),ISNULL(P.ParticipantHash, CAST(0x0 AS BINARY(32))) ,1) AS ParticipantHash,
CONVERT(CHAR(66),ISNULL(DS.DeliverySiteHash, CAST(0x0 AS BINARY(32))),1) AS DeliverySiteHash,
CONVERT(CHAR(66),ISNULL(PR.ProgrammeHash, CAST(0x0 AS BINARY(32))),1) AS ProgrammeHash,
CASE WHEN S_C.CaseStatus IS NULL THEN CONVERT(CHAR(66),CAST(0x0 AS BINARY(32)),1) ELSE CONVERT(CHAR(66),CAST(HASHBYTES('SHA2_256',CAST(CAST(S_C.CaseStatus AS INT) AS VARCHAR)) AS BINARY(32)),1) END AS CaseStatusHash,
CASE WHEN R_AC.ReferralDate IS NULL THEN -1 ELSE CAST(CONVERT(CHAR(8),R_AC.ReferralDate,112) AS INT) END AS ReferralDateKey,
CASE WHEN S_AD.StartDate IS NULL THEN -1 ELSE CAST(CONVERT(CHAR(8),S_AD.StartDate,112) AS INT) END AS StartDateKey,
CASE WHEN S_AD.StartVerifiedDate IS NULL THEN -1 ELSE CAST(CONVERT(CHAR(8),S_AD.StartVerifiedDate,112) AS INT) END AS  StartVerifiedDateKey,
CASE WHEN S_AD.LeaveDate IS NULL THEN -1 ELSE CAST(CONVERT(CHAR(8),S_AD.LeaveDate,112) AS INT) END AS  LeaveDateKey,
CASE WHEN S_AD.ProjectedLeaveDate IS NULL THEN -1 ELSE CAST(CONVERT(CHAR(8),S_AD.ProjectedLeaveDate,112) AS INT) END AS ProjectedLeaveDateKey,
S_DUC.DocumentCategory,
S_DUC.CreatedDate,
S_DUC.UploadedDate,
S_DUC.ModifiedDate
FROM DV.HUB_DocumentUpload D
	LEFT JOIN DV.LINK_Case_DocumentUpload CDU ON D.DocumentUploadHash = CDU.DocumentUploadHash
	LEFT JOIN DV.LINK_Case_Participant P ON CDU.CaseHash = P.CaseHash
	LEFT JOIN DV.LINK_Case_DeliverySite DS ON DS.CaseHash = CDU.CaseHash
	LEFT JOIN DV.LINK_Case_Referral R ON R.CaseHash = CDU.CaseHash
	LEFT JOIN DV.LINK_Referral_Programme PR ON PR.ReferralHash = R.ReferralHash
	LEFT JOIN DV.SAT_Referral_Adapt_Core R_AC ON R_AC.ReferralHash = R.ReferralHash AND R_AC.IsCurrent = 1
	LEFT JOIN DV.SAT_Case_Adapt_Core S_C ON S_C.CaseHash = CDU.CaseHash AND S_C.IsCurrent = 1
	LEFT JOIN DV.SAT_Case_Adapt_Dates S_AD ON S_AD.CaseHash = CDU.CaseHash AND S_AD.IsCurrent = 1
	LEFT JOIN DV.SAT_DocumentUpload_Adapt_Core S_DUC ON S_DUC.DocumentUploadHash = CDU.DocumentUploadHash AND S_DUC.IsCurrent = 1
	WHERE D.RecordSource = 'ADAPT.DOCUMENTS';
GO
