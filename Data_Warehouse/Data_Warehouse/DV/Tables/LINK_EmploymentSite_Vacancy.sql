CREATE TABLE [DV].[LINK_EmploymentSite_Vacancy] (
    [EmploymentSite_VacancyHash] BINARY (32)   NULL,
    [EmploymentSiteHash]         BINARY (32)   NULL,
    [VacancyHash]                BINARY (32)   NULL,
    [RecordSource]               VARCHAR (50)  NULL,
    [ValidFrom]                  DATETIME2 (0) NULL
)
WITH (HEAP, DISTRIBUTION=HASH([EmploymentSite_VacancyHash]) ) 
GO


