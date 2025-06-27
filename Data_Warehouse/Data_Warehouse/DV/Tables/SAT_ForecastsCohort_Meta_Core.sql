CREATE TABLE [DV].[SAT_ForecastsCohort_Meta_Core] (
    [ForecastsCohortHash] BINARY (32)     NULL,
    [ForecastsCohortKey]  NVARCHAR (100)  NULL,
    [RecordSource]        VARCHAR (19)    NOT NULL,
    [CohortMonthNumber]   INT             NOT NULL,
    [ContractType]        VARCHAR (50)    NULL,
    [Initial]             VARCHAR (10)    NULL,
    [DDA]                 VARCHAR (10)    NULL,
    [Conv]                DECIMAL (18, 3) NULL,
    [CumulConv]           DECIMAL (18, 3) NULL,
    [ContentHash]         BINARY (32)     NULL,
    [ValidFrom]           DATETIME2 (0)   NULL,
    [ValidTo]             DATETIME2 (0)   NULL,
    [IsCurrent]           BIT             NULL
)
WITH (HEAP, DISTRIBUTION = HASH([ForecastsCohortHash]));
GO

