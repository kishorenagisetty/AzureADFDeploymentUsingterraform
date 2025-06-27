CREATE TABLE [DV].[LINK_ForecastsCohort_SourceType] (
    [ForecastsCohort_SourceTypeHash] BINARY (32)   NULL,
    [ForecastsCohortHash]            BINARY (32)   NULL,
    [SourceTypeHash]                 BINARY (32)   NULL,
    [RecordSource]                   VARCHAR (50)  NULL,
    [ValidFrom]                      DATETIME2 (0) NULL
)
WITH (HEAP, DISTRIBUTION = REPLICATE);


GO

