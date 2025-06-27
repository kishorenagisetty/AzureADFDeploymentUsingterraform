CREATE TABLE [DV].[SAT_Vacancy_Adapt_Job] (
    [VacancyHash]                   BINARY (32)     NULL,
    [VacancyKey]                    NVARCHAR (100)  NULL,
    [VacancyReference]              DECIMAL (16)    NULL,
    [VacancyWorkingHours]           DECIMAL (20)    NULL,
    [VacancyNumberRequired]         DECIMAL (3)     NULL,
    [VacancyNumberRemaining]        DECIMAL (3)     NULL,
	[HourlyRate]                    DECIMAL (10, 2) NULL,
    [VacancySalaryFrom]             DECIMAL (10, 2) NULL,
    [VacancySalaryTo]               DECIMAL (10, 2) NULL,
    [VacancyOnTargetEarnings]       DECIMAL (10, 2) NULL,
    [VacancyOpenFromDate]           DATETIME2 (0)   NULL,
    [VacancyMinimumEducationLevel]  DECIMAL (20)    NULL,
    [VacancyPaymentInterval]        NVARCHAR (MAX)  NULL,
    [VacancyNumberExternallyFilled] DECIMAL (3)     NULL,
    [VacancyNumberInternallyFilled] DECIMAL (3)     NULL,
    [VacancyPermanence]             DECIMAL (20)    NULL,
    [VacancyWageCategory]           DECIMAL (20)    NULL,
    [ContentHash]                   BINARY (32)     NULL,
    [ValidFrom]                     DATETIME2 (0)   NULL,
    [ValidTo]                       DATETIME2 (0)   NULL,
    [IsCurrent]                     BIT             NULL
)
WITH (HEAP, DISTRIBUTION = HASH([VacancyHash]));

