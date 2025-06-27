CREATE VIEW [DV].[Base_Assignment] AS SELECT * FROM [DV].[Base_Assignment_Default]
UNION ALL 
SELECT * FROM [DV].[Base_Assignment_Adapt]
UNION ALL 
SELECT * FROM [DV].[Base_Assignment_Iconi];
GO