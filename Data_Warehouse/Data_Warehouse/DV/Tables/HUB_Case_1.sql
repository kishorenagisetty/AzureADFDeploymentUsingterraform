CREATE TABLE [DV].[HUB_Case] (
    [CaseHash]     BINARY (32)    NULL,
    [CaseKey]      NVARCHAR (100) NULL,
    [RecordSource] VARCHAR (50)   NULL,
    [ValidFrom]    DATETIME2 (0)  NULL
)
WITH (HEAP, DISTRIBUTION = HASH([CaseHash]));

