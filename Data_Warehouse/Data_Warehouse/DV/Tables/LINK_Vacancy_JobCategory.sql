CREATE TABLE [DV].[LINK_Vacancy_JobCategory] (
    [Vacancy_JobCategoryHash] BINARY (32)   NULL,
    [VacancyHash]             BINARY (32)   NULL,
    [JobCategoryHash]         BINARY (32)   NULL,
    [RecordSource]            VARCHAR (50)  NULL,
    [ValidFrom]               DATETIME2 (0) NULL
)
WITH (HEAP, DISTRIBUTION=HASH([Vacancy_JobCategoryHash]) ) 
GO

