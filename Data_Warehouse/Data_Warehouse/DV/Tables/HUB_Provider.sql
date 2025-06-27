CREATE TABLE [DV].[HUB_Provider] (
    [ProviderHash] BINARY (32)    NULL,
    [ProviderKey]  NVARCHAR (100) NULL,
    [RecordSource] VARCHAR (50)   NULL,
    [ValidFrom]    DATETIME2 (0)  NULL
)
WITH (HEAP, DISTRIBUTION = HASH([ProviderHash]));
GO

