CREATE VIEW [DV].[Base_Document_Default]
AS SELECT
CONVERT(CHAR(66),CAST(0x0 AS BINARY(32)),1) AS DocumentHash,
CAST('0' AS NVARCHAR) AS DocumentID,
CAST('Unknown' AS NVARCHAR(MAX)) AS DocumentName,
CAST('Unknown' AS NVARCHAR(MAX)) AS DocumentStatus,
CAST('Unknown' AS NVARCHAR(MAX)) AS DocumentNotes
GO