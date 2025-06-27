CREATE VIEW [DV].[Base_Programme_Iconi]
AS SELECT  
	CONVERT(CHAR(66),P.ProgrammeHash ,1) AS ProgrammeHash, 
	CAST(P.RecordSource AS NVARCHAR(MAX)) AS RecordSource,
	CAST(S_IC.ProgrammeName AS NVARCHAR(MAX)) AS ProgrammeName,
	CAST(NULL AS NVARCHAR(MAX)) AS ProgrammeGroup,
	CAST(NULL AS NVARCHAR(MAX)) AS ProgrammeCategory
FROM DV.HUB_Programme P
	LEFT JOIN DV.SAT_Programme_Iconi_Core S_IC ON S_IC.ProgrammeHash = P.ProgrammeHash
	WHERE P.RecordSource = 'ICONI.Programme_Static'
	AND S_IC.IsCurrent = 1;
GO

