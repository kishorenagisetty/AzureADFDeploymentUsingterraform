CREATE TABLE [DV].[HUB_Forecasts] (
    [ForecastsHash] BINARY (32)    NULL,
    [ForecastsKey]  NVARCHAR (100) NULL,
    [RecordSource]  VARCHAR (50)   NULL,
    [ValidFrom]     DATETIME2 (0)  NULL
)
WITH (HEAP, DISTRIBUTION = HASH([ForecastsHash]));
GO

