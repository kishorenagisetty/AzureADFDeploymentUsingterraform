CREATE VIEW [DV].[Fact_Document] AS WITH cte_Documents AS (
SELECT
	CD.CaseHash,
	CONVERT(CHAR(66),ISNULL(S_DC.DocumentHash,CAST(0x0 AS BINARY(32))),1) AS DocumentHash,
	'ADAPT.PROP_DOCTRACK_GEN' AS RecordSource,
	CONVERT(CHAR(66),ISNULL(DE.EmployeeHash,CAST(0x0 AS BINARY(32))),1) AS DocumentSenderHash,
	S_DC.ReceivedDate AS DocumentReceivedDateKey,
	S_DC.SentDate AS DocumentSentDateKey,
	S_DC.Sender,
	S_DC.ResentDate AS DocumentResentDateKey,
	S_DC.Resender,
	S_DC.CompletedDate AS DocumentCompletedDateKey,
	S_DC.CompletedBy,
	S_DC.QueriedDate AS DocumentQueriedDateKey,
	S_DC.QueriedBy,
	S_DC.DocumentReferenceKey
FROM DV.SAT_Document_Adapt_Core S_DC
LEFT JOIN DV.LINK_Case_Document CD ON S_DC.DocumentHash = CD.DocumentHash
LEFT JOIN DV.LINK_Document_Employee DE ON S_DC.DocumentHash = DE.DocumentHash
LEFT JOIN DV.SAT_Entity_SoftDelete_Adapt_Core SESAC ON SESAC.EntityKey = S_DC.DocumentReferenceKey AND SESAC.IsCurrent = 1
WHERE
S_DC.IsCurrent = 1
AND SESAC.EntityKey IS NULL
)
SELECT
	D.DocumentHash,
	D.RecordSource,
	fcb.CaseHash,	
	fcb.ParticipantHash,
	fcb.DeliverySiteHash,
	fcb.ProgrammeHash,
	fcb.CaseStatusHash,
	fcb.ReferralDateKey,
	fcb.StartDateKey,
	fcb.StartVerifiedDateKey,
	fcb.LeaveDateKey,
	fcb.ProjectedLeaveDateKey,
	D.DocumentSenderHash,
	D.DocumentReceivedDateKey,
	D.DocumentSentDateKey,
	D.DocumentResentDateKey,
	D.DocumentCompletedDateKey,
	D.DocumentQueriedDateKey
FROM DV.Fact_Case_Base fcb
INNER JOIN cte_Documents D ON D.CaseHash = fcb.Fact_Case_Base_CaseHash;
GO
