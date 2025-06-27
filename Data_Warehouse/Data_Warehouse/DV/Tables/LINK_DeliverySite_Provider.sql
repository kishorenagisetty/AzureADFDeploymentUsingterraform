CREATE TABLE [DV].[LINK_DeliverySite_Provider] (
    [DeliverySite_ProviderHash] BINARY (32)   NULL,
    [DeliverySiteHash]          BINARY (32)   NULL,
    [ProviderHash]              BINARY (32)   NULL,
    [RecordSource]              VARCHAR (50)  NULL,
    [ValidFrom]                 DATETIME2 (0) NULL
)
WITH (HEAP, DISTRIBUTION = HASH([DeliverySiteHash]));
GO

