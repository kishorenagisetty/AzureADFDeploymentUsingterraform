CREATE VIEW [DV].[Base_DocumentUpload]
AS SELECT * FROM [DV].[Base_DocumentUpload_Default]
UNION ALL
SELECT * FROM [DV].[Base_DocumentUpload_Adapt];
GO