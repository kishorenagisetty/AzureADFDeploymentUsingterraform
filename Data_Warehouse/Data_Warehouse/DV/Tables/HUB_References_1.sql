CREATE TABLE [DV].[HUB_References] (
    [ReferencesHash] BINARY (32)    NULL,
    [ReferencesKey]  NVARCHAR (100) NULL,
    [RecordSource]   VARCHAR (50)   NULL,
    [ValidFrom]      DATETIME2 (0)  NULL
)
WITH (HEAP, DISTRIBUTION = HASH([ReferencesHash]));

