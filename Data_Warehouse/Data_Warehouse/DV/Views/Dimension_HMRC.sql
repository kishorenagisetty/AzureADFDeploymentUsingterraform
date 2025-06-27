CREATE VIEW [DV].[Dimension_HMRC]
AS SELECT
[HMRCHash],
[RecordSource],
[NINO],
[SourceSystem],
[SupplierName],
[SupplierSiteCode],
[ASNNumber],
[InvoiceNumber]
FROM [DV].[Base_HMRC];
GO