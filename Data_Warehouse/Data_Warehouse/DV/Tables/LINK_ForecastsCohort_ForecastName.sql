CREATE TABLE [DV].[LINK_ForecastsCohort_ForecastName] (
    [ForecastsCohort_ForecastNameHash] BINARY (32)   NULL,
    [ForecastsCohortHash]              BINARY (32)   NULL,
    [ForecastNameHash]                 BINARY (32)   NULL,
    [RecordSource]                     VARCHAR (50)  NULL,
    [ValidFrom]                        DATETIME2 (0) NULL
)
WITH (HEAP, DISTRIBUTION = REPLICATE);


GO

