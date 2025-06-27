CREATE TABLE [DV].[LINK_Forecasts_ForecastName] (
    [Forecasts_ForecastNameHash] BINARY (32)   NULL,
    [ForecastsHash]              BINARY (32)   NULL,
    [ForecastNameHash]           BINARY (32)   NULL,
    [RecordSource]               VARCHAR (50)  NULL,
    [ValidFrom]                  DATETIME2 (0) NULL
)
WITH (HEAP, DISTRIBUTION = HASH([ForecastsHash]));
GO

