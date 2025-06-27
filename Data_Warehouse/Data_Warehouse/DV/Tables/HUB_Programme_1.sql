CREATE TABLE [DV].[HUB_Programme] (
    [ProgrammeHash] BINARY (32)    NULL,
    [ProgrammeKey]  NVARCHAR (100) NULL,
    [RecordSource]  VARCHAR (50)   NULL,
    [ValidFrom]     DATETIME2 (0)  NULL
)
WITH (HEAP, DISTRIBUTION = HASH([ProgrammeHash]));

