CREATE TABLE [DV].[SAT_HMRC_Adapt_Core] (
    [HMRCHash]          BINARY (32)    NULL,
    [HMRCKey]           NVARCHAR (274) NULL,
    [RecordSource]      VARCHAR (17)   NOT NULL,
    [PONumber]          NVARCHAR (255) NULL,
    [NINO]              NVARCHAR (255) NULL,
    [DateCreated]       NVARCHAR (255) NULL,
    [NotificationType]  NVARCHAR (255) NULL,
    [NotificationDate]  NVARCHAR (255) NULL,
    [SourceSystem]      NVARCHAR (255) NULL,
    [SupplierName]      NVARCHAR (255) NULL,
    [SupplierSiteCode]  NVARCHAR (255) NULL,
    [CPA]               FLOAT (53)     NULL,
    [RecordStatus]      NVARCHAR (255) NULL,
    [ASNCreationStatus] NVARCHAR (255) NULL,
    [ASNNumber]         NVARCHAR (255) NULL,
    [InvoiceNumber]     NVARCHAR (255) NULL,
    [ContentHash]       BINARY (32)    NULL,
    [ValidFrom]         DATETIME2 (0)  NULL,
    [ValidTo]           DATETIME2 (0)  NULL,
    [IsCurrent]         BIT            NULL
)
WITH (HEAP, DISTRIBUTION = HASH([HMRCHash]));
GO