CREATE TABLE [DV].[SAT_Forecasts_Meta_Core] (
    [ForecastsHash] BINARY (32)     NULL,
    [ForecastsKey]  NVARCHAR (100)  NULL,
    [ForecastValue] DECIMAL (18, 3) NULL,
    [ContentHash]   BINARY (32)     NULL,
    [ValidFrom]     DATETIME2 (0)   NULL,
    [ValidTo]       DATETIME2 (0)   NULL,
    [IsCurrent]     BIT             NULL
)
WITH (HEAP, DISTRIBUTION = HASH([ForecastsHash]));
GO

