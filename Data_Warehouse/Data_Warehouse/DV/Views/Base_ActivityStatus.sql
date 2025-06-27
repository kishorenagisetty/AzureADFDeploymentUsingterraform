CREATE VIEW [DV].[Base_ActivityStatus]
AS SELECT * FROM [DV].[Base_ActivityStatus_Default]
UNION ALL
SELECT * FROM [DV].[Base_ActivityStatus_Adapt]
UNION ALL
SELECT * FROM [DV].[Base_ActivityStatus_Iconi];
GO