CREATE TABLE [DV].[SAT_SourceType_Meta_Core] (
    [SourceTypeHash] BINARY (32)    NULL,
    [SourceTypeKey]  NVARCHAR (100) NULL,
    [SourceTypeName] VARCHAR (50)   NULL,
    [ContentHash]    BINARY (32)    NULL,
    [ValidFrom]      DATETIME2 (3)  NULL,
    [ValidTo]        DATETIME2 (3)  NULL,
    [IsCurrent]      BIT            NULL
)
WITH (HEAP, DISTRIBUTION = HASH([SourceTypeHash]));
GO

