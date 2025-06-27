CREATE TABLE [DV].[LINK_ForecastsCohort_Programme] (
    [ForecastsCohort_ProgrammeHash] BINARY (32)   NULL,
    [ForecastsCohortHash]           BINARY (32)   NULL,
    [ProgrammeHash]                 BINARY (32)   NULL,
    [RecordSource]                  VARCHAR (50)  NULL,
    [ValidFrom]                     DATETIME2 (0) NULL
)
WITH (HEAP, DISTRIBUTION = HASH([ForecastsCohortHash]));
GO

