CREATE TABLE [DV].[HUB_Barriers] (
    [BarriersHash] BINARY (32)    NULL,
    [BarriersKey]  NVARCHAR (100) NULL,
    [RecordSource] VARCHAR (50)   NULL,
    [ValidFrom]    DATETIME2 (0)  NULL
)
WITH (HEAP, DISTRIBUTION = HASH([BarriersHash]));
GO

