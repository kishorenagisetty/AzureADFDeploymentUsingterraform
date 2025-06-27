CREATE TABLE [DV].[LINK_Forecasts_ForecastType] (
    [Forecasts_ForecastTypeHash] BINARY (32)   NULL,
    [ForecastsHash]              BINARY (32)   NULL,
    [ForecastTypeHash]           BINARY (32)   NULL,
    [RecordSource]               VARCHAR (50)  NULL,
    [ValidFrom]                  DATETIME2 (0) NULL
)
WITH (HEAP, DISTRIBUTION = HASH([ForecastsHash]));
GO

