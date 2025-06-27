CREATE VIEW [DV].[Base_Programme_Adapt]
AS SELECT 
	CONVERT(CHAR(66),P.ProgrammeHash ,1) AS ProgrammeHash, 
	CAST(P.RecordSource AS NVARCHAR(MAX)) AS RecordSource,
	S_AC.ProgrammeName,
	CAST(NULL AS NVARCHAR(MAX)) AS ProgrammeGroup,
	CAST(NULL AS NVARCHAR(MAX)) AS ProgrammeCategory
FROM DV.HUB_Programme P
	LEFT JOIN DV.SAT_Programme_Adapt_Core S_AC ON S_AC.ProgrammeHash = P.ProgrammeHash
	WHERE P.RecordSource = 'ADAPT.PROP_WP_GEN'
	AND S_AC.IsCurrent = 1;
GO

