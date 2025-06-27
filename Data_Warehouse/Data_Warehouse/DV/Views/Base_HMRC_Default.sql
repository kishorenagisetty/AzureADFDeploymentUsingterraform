CREATE VIEW [DV].[Base_HMRC_Default] AS SELECT
CONVERT(CHAR(66),CAST(0x0 AS BINARY(32)),1) AS HMRCHash,
CAST('Unknown' AS NVARCHAR(MAX)) AS RecordSource,
CAST('Unknown' AS NVARCHAR(MAX)) AS NINO,
CAST('Unknown' AS NVARCHAR(MAX)) AS SourceSystem,
CAST('Unknown' AS NVARCHAR(MAX)) AS SupplierName,
CAST('Unknown' AS NVARCHAR(MAX)) AS SupplierSiteCode,
CAST('Unknown' AS NVARCHAR(MAX)) AS ASNNumber,
CAST('Unknown' AS NVARCHAR(MAX)) AS InvoiceNumber;
GO