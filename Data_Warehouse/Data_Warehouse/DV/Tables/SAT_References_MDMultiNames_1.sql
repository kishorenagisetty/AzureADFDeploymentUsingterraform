CREATE TABLE [DV].[SAT_References_MDMultiNames] (
    [ReferencesHash] BINARY (32)    NULL,
    [ReferencesKey]  NVARCHAR (MAX) NULL,
    [ID]             BIGINT         NULL,
    [Type]           NVARCHAR (MAX) NULL,
    [Language]       INT            NULL,
    [Name]           NVARCHAR (MAX) NULL,
    [Description]    NVARCHAR (MAX) NULL,
    [ContentHash]    BINARY (32)    NULL,
    [ValidFrom]      DATETIME2 (0)  NULL,
    [ValidTo]        DATETIME2 (0)  NULL,
    [IsCurrent]      BIT            NULL
)
WITH (HEAP, DISTRIBUTION = HASH([ReferencesHash]));

