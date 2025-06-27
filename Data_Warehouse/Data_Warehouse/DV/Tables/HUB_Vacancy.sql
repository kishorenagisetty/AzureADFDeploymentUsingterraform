CREATE TABLE [DV].[HUB_Vacancy] (
    [VacancyHash]  BINARY (32)    NULL,
    [VacancyKey]   NVARCHAR (100) NULL,
    [RecordSource] VARCHAR (50)   NULL,
    [ValidFrom]    DATETIME2 (0)  NULL
)
WITH (HEAP, DISTRIBUTION = HASH([VacancyHash]));

