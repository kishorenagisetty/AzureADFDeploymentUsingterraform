CREATE TABLE [DV].[HUB_ForecastName] (
    [ForecastNameHash] BINARY (32)    NULL,
    [ForecastNameKey]  NVARCHAR (100) NULL,
    [RecordSource]     VARCHAR (50)   NULL,
    [ValidFrom]        DATETIME2 (0)  NULL
)
WITH (HEAP, DISTRIBUTION = HASH([ForecastNameHash]));
GO