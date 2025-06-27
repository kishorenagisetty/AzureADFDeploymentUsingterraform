CREATE TABLE [DV].[SAT_ForecastName_Meta_Core] (
    [ForecastNameHash] BINARY (32)    NULL,
    [ForecastNameKey]  NVARCHAR (100) NULL,
    [Filename]         VARCHAR (50)   NULL,
    [DateProvided]     VARCHAR (10)   NOT NULL,
    [Dateuploaded]     VARCHAR (10)   NOT NULL,
    [ContentHash]      BINARY (32)    NULL,
    [ValidFrom]        DATETIME2 (0)  NULL,
    [ValidTo]          DATETIME2 (0)  NULL,
    [IsCurrent]        BIT            NULL
)
WITH (HEAP, DISTRIBUTION = HASH([ForecastNameHash]));
GO

