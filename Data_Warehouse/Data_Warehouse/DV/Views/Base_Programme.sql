CREATE VIEW [DV].[Base_Programme]
AS SELECT * FROM [DV].[Base_Programme_Default]
UNION ALL
SELECT * FROM [DV].[Base_Programme_Adapt]
UNION ALL
SELECT * FROM [DV].[Base_Programme_Iconi];
GO

