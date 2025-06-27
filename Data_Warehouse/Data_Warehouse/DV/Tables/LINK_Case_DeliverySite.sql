CREATE TABLE [DV].[LINK_Case_DeliverySite] (
    [Case_DeliverySiteHash] BINARY (32)   NULL,
    [CaseHash]              BINARY (32)   NULL,
    [DeliverySiteHash]      BINARY (32)   NULL,
    [RecordSource]          VARCHAR (50)  NULL,
    [ValidFrom]             DATETIME2 (0) NULL
)
WITH (HEAP, DISTRIBUTION=HASH([Case_DeliverySiteHash]) ) 
GO




