CREATE TABLE [DV].[SAT_DeliverySite_Iconi_Core] (
    [DeliverySiteHash] BINARY (32)    NULL,
    [DeliverySiteKey]  NVARCHAR (100) NULL,
    [DeliverySiteName] NVARCHAR (MAX) NOT NULL,
    [ContentHash]      BINARY (32)    NULL,
    [ValidFrom]        DATETIME2 (0)  NULL,
    [ValidTo]          DATETIME2 (0)  NULL,
    [IsCurrent]        BIT            NULL
)
WITH (HEAP, DISTRIBUTION = HASH([DeliverySiteHash]));


GO

