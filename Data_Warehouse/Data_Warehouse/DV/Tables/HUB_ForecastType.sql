CREATE TABLE [DV].[HUB_ForecastType] (
    [ForecastTypeHash] BINARY (32)    NULL,
    [ForecastTypeKey]  NVARCHAR (100) NULL,
    [RecordSource]     VARCHAR (50)   NULL,
    [ValidFrom]        DATETIME2 (0)  NULL
)
WITH (HEAP, DISTRIBUTION = HASH([ForecastTypeHash]));
GO

