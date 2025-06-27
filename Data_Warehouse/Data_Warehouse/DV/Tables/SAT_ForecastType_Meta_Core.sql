CREATE TABLE [DV].[SAT_ForecastType_Meta_Core] (
    [ForecastTypeHash] BINARY (32)    NULL,
    [ForecastTypeKey]  NVARCHAR (100) NULL,
    [Type]             VARCHAR (50)   NULL,
    [Longname]         VARCHAR (50)   NULL,
    [ContentHash]      BINARY (32)    NULL,
    [ValidFrom]        DATETIME2 (0)  NULL,
    [ValidTo]          DATETIME2 (0)  NULL,
    [IsCurrent]        BIT            NULL
)
WITH (HEAP, DISTRIBUTION = HASH([ForecastTypeHash]));
GO

