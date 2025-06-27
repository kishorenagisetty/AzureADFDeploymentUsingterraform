CREATE TABLE [DV].[LINK_Vacancy_Assignment] (
    [Vacancy_AssignmentHash] BINARY (32)   NULL,
    [VacancyHash]            BINARY (32)   NULL,
    [AssignmentHash]         BINARY (32)   NULL,
    [RecordSource]           VARCHAR (50)  NULL,
    [ValidFrom]              DATETIME2 (0) NULL
)
WITH (HEAP, DISTRIBUTION=HASH([Vacancy_AssignmentHash]) ) ;



