CREATE VIEW [DV].[Base_Document]
AS SELECT * FROM [DV].[Base_Document_Default]
UNION ALL
SELECT * FROM [DV].[Base_Document_Adapt]
GO