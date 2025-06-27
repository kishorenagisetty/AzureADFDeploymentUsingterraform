CREATE TABLE [DV].[LINK_ForecastsCohort_Metric] (
    [ForecastsCohort_MetricHash] BINARY (32)   NULL,
    [ForecastsCohortHash]        BINARY (32)   NULL,
    [MetricHash]                 BINARY (32)   NULL,
    [RecordSource]               VARCHAR (50)  NULL,
    [ValidFrom]                  DATETIME2 (0) NULL
)
WITH (HEAP, DISTRIBUTION = REPLICATE);


GO

