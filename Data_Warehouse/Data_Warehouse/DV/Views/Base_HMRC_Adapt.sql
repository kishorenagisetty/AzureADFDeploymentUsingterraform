CREATE VIEW [DV].[Base_HMRC_Adapt] AS (
SELECT
CONVERT(CHAR(66),ISNULL(SHAC.HMRCHash,CAST(0x0 AS BINARY(32))),1) AS HMRCHash
,SHAC.RecordSource
,SHAC.NINO
,SHAC.SourceSystem
,SHAC.SupplierName
,SHAC.SupplierSiteCode
,SHAC.ASNNumber
,SHAC.InvoiceNumber
FROM DV.SAT_HMRC_Adapt_Core SHAC 
WHERE 
SHAC.IsCurrent = '1'
);
GO