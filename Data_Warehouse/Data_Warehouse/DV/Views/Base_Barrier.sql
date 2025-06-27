CREATE VIEW [DV].[Base_Barrier]
AS SELECT * FROM [DV].[Base_Barrier_Default]
UNION ALL
SELECT * FROM [DV].[Base_Barrier_Adapt]
UNION ALL
SELECT * FROM [DV].[Base_Barrier_Iconi];
GO

