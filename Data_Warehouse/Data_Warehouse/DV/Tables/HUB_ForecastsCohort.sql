CREATE TABLE [DV].[HUB_ForecastsCohort] (
    [ForecastsCohortHash] BINARY (32)    NULL,
    [ForecastsCohortKey]  NVARCHAR (100) NULL,
    [RecordSource]        VARCHAR (50)   NULL,
    [ValidFrom]           DATETIME2 (0)  NULL
)
WITH (HEAP, DISTRIBUTION = HASH([ForecastsCohortHash]));
GO

