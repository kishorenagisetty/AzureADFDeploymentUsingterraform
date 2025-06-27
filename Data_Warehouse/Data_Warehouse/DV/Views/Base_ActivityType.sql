CREATE VIEW [DV].[Base_ActivityType]
AS SELECT * FROM [DV].[Base_ActivityType_Default]
UNION ALL
SELECT * FROM [DV].[Base_ActivityType_Adapt]
UNION ALL
SELECT * FROM [DV].[Base_ActivityType_Iconi];
GO