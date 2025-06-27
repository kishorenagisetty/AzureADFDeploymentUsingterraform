CREATE TABLE [DV].[HUB_Document] (
    [DocumentHash] BINARY (32)    NULL,
    [DocumentKey]  NVARCHAR (100) NULL,
    [RecordSource] VARCHAR (50)   NULL,
    [ValidFrom]    DATETIME2 (0)  NULL
)
WITH (HEAP, DISTRIBUTION = HASH([DocumentHash]));

