CREATE TABLE [DV].[SAT_Programme_Adapt_Core] (
    [ProgrammeHash] BINARY (32)    NULL,
    [ProgrammeKey]  NVARCHAR (MAX) NULL,
    [ProgrammeName] NVARCHAR (MAX) NULL,
    [ContentHash]   BINARY (32)    NULL,
    [ValidFrom]     DATETIME2 (0)  NULL,
    [ValidTo]       DATETIME2 (0)  NULL,
    [IsCurrent]     BIT            NULL
)
WITH (HEAP, DISTRIBUTION = HASH([ProgrammeHash]));

