CREATE VIEW [DV].[Base_Requestor]
AS SELECT * FROM [DV].[Base_Requestor_Default]
UNION ALL
SELECT * FROM [DV].[Base_Requestor_Adapt]
UNION ALL
SELECT * FROM [DV].[Base_Requestor_Iconi];
GO

