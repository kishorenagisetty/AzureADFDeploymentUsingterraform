CREATE VIEW [DV].[Base_CaseStatus]
AS SELECT * FROM [DV].[Base_CaseStatus_Adapt]
UNION ALL
SELECT * FROM [DV].[Base_CaseStatus_Iconi];
GO

