CREATE TABLE [DV].[HUB_DeliverySite] (
    [DeliverySiteHash] BINARY (32)    NULL,
    [DeliverySiteKey]  NVARCHAR (100) NULL,
    [RecordSource]     VARCHAR (50)   NULL,
    [ValidFrom]        DATETIME2 (0)  NULL
)
WITH (HEAP, DISTRIBUTION = HASH([DeliverySiteHash]));

