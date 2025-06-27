CREATE VIEW [DV].[Base_Employee]
AS SELECT * FROM [DV].[Base_Employee_Default]
UNION ALL
SELECT * FROM [DV].[Base_Employee_Adapt]
UNION ALL
SELECT * FROM [DV].[Base_Employee_Iconi];
GO

