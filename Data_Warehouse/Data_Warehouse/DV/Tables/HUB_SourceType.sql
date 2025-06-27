CREATE TABLE [DV].[HUB_SourceType] (
    [SourceTypeHash] BINARY (32)    NULL,
    [SourceTypeKey]  NVARCHAR (100) NULL,
    [RecordSource]   VARCHAR (50)   NULL,
    [ValidFrom]      DATETIME2 (0)  NULL
)
WITH (HEAP, DISTRIBUTION = HASH([SourceTypeHash]));
GO