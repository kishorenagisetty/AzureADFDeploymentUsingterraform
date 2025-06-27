CREATE VIEW [DV].[Base_DocumentUpload_Default]
AS SELECT
CONVERT(CHAR(66),CAST(0x0 AS BINARY(32)),1) AS DocumentUploadHash,
CAST('0' AS NVARCHAR) AS DocumentUploadID,
CAST('Unknown' AS NVARCHAR(MAX)) AS DocumentName,
CAST('Unknown' AS NVARCHAR(MAX)) AS DocumentDescription,
CAST('Unknown' AS NVARCHAR(MAX)) AS DocumentCategory;
GO