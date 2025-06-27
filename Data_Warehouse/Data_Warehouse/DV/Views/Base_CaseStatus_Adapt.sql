CREATE VIEW [DV].[Base_CaseStatus_Adapt]
AS SELECT CONVERT(CHAR(66),CAST(0x0 AS BINARY(32)),1) AS CaseStatusHash,
'Unknown' AS CaseStatus,
'Unknown' AS RecordSource
UNION ALL
SELECT CONVERT(CHAR(66), CAST(HASHBYTES('SHA2_256',CAST(CAST(R.Code AS bigint) AS VARCHAR)) AS BINARY(32)),1) AS CaseStatusHash,
	R.Description AS CaseStatus,
	'ADAPT' AS RecordSource
	FROM DV.Dimension_References R  WHERE Code IN (
		SELECT DISTINCT CaseStatus FROM DV.SAT_Case_Adapt_Core C 
		WHERE CaseStatus IS NOT NULL AND Category = 'CODE' AND ReferenceSource = 'ADAPT.MD_MULTI_NAMES'
	);
GO

