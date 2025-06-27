CREATE VIEW [ADAPT].[SAT_HMRC_Adapt_Core] AS (
SELECT [HMRCKey], [RecordSource],[PONumber], [NINO], [DateCreated], [NotificationType], 
		[NotificationDate], [SourceSystem], [SupplierName], [SupplierSiteCode],
		[CPA], [RecordStatus], [ASNCreationStatus], 
		[ASNNumber], [InvoiceNumber], [ValidFrom], [ValidTo], [IsCurrent] 
FROM  (
	SELECT  --Dups in source
	ROW_NUMBER() OVER(
				   PARTITION BY CONCAT_WS('|','ADAPT',CAST([REFERRAL NUMBER] AS INT),[NOTIFICATION TYPE]) 
				   ORDER BY [NOTIFICATION DATE] DESC)
				   AS RowNum,
	CONCAT_WS('|','ADAPT',CAST([REFERRAL NUMBER] AS INT),[NOTIFICATION TYPE]) AS HMRCKey, 
	'ADAPT.EXTERNAL.XL'						AS RecordSource,
	[REFERRAL NUMBER] AS  PONumber,
	[NINO], 
	CAST([DATE CREATED] AS DATE) AS 'DateCreated',
	[NOTIFICATION TYPE] AS 'NotificationType',
	CAST([NOTIFICATION DATE] AS DATE)  AS 'NotificationDate',
	[SOURCE SYSTEM] AS 'SourceSystem',
	[SUPPLIER NAME] AS 'SupplierName',
	[SUPPLIER SITE CODE] AS 'SupplierSiteCode',
	[CPA],
	[RECORD STATUS] AS 'RecordStatus',
	[ASN CREATION STATUS] AS 'ASNCreationStatus',
	[ASN NUMBER] AS 'ASNNumber',
	[INVOICE NUMBER] AS 'InvoiceNumber',
	[ValidFrom] AS [ValidFrom], 
	'9999-12-31 23:59:59' AS [ValidTo], 
	1 AS IsCurrent 
	FROM 
	[LZ].[hmrc_Files]
	WHERE
	[DATE CREATED] <> 'DATE CREATED') sub
	WHERE rownum = 1
);
GO
