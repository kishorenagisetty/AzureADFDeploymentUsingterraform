CREATE TABLE [DV].[LINK_Vacancy_Submission] (
    [Vacancy_SubmissionHash] BINARY (32)   NULL,
    [VacancyHash]            BINARY (32)   NULL,
    [SubmissionHash]         BINARY (32)   NULL,
    [RecordSource]           VARCHAR (50)  NULL,
    [ValidFrom]              DATETIME2 (0) NULL
)
WITH (HEAP, DISTRIBUTION=HASH([Vacancy_SubmissionHash]) ) ;


