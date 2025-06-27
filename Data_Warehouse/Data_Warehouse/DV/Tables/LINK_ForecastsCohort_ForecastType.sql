CREATE TABLE [DV].[LINK_ForecastsCohort_ForecastType] (
    [ForecastsCohort_ForecastTypeHash] BINARY (32)   NULL,
    [ForecastsCohortHash]              BINARY (32)   NULL,
    [ForecastTypeHash]                 BINARY (32)   NULL,
    [RecordSource]                     VARCHAR (50)  NULL,
    [ValidFrom]                        DATETIME2 (0) NULL
)
WITH (HEAP, DISTRIBUTION = REPLICATE);


GO

