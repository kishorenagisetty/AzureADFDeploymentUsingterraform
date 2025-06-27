CREATE VIEW [DV].[Base_Case] AS SELECT * FROM [DV].[Base_Case_Default]
UNION ALL
SELECT * FROM [DV].[Base_Case_Adapt]
UNION ALL
SELECT * FROM [DV].[Base_Case_Iconi];
GO

