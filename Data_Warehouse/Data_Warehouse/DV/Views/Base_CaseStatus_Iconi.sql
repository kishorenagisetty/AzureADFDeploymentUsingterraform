CREATE VIEW [DV].[Base_CaseStatus_Iconi]
AS SELECT DISTINCT
	CONVERT(CHAR(66), CAST(HASHBYTES('SHA2_256',CAST(S_C.CaseStatus AS VARCHAR)) AS BINARY(32)),1) AS CaseStatusHash,
	S_C.CaseStatus,
	'ICONI' AS RecordSource
	FROM DV.HUB_Case H_C
	INNER JOIN DV.SAT_Case_Iconi_Core S_C 
	ON H_C.CaseHash = S_C.CaseHash
	WHERE H_C.RecordSource = 'ICONI.Engagement'
	AND S_C.CaseStatus IS NOT NULL;
GO

