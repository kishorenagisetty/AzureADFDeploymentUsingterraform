CREATE TABLE [DV].[SAT_Vacancy_Adapt_Core]
(
	[VacancyHash] [BINARY](32) NULL,
	[VacancyKey] [NVARCHAR](100) NULL,
	[VacancyReferenceKey] [VARCHAR](18) NOT NULL,
	[VacancyStatus] [DECIMAL](20, 0) NULL,
	[VacancyJobTitle] [NVARCHAR](MAX) NULL,
	[ExpectedStartDate] [DATETIME2](0) NULL,
	[ReasonForVacancy] [DECIMAL](20, 0) NULL,
	[VacancyDetails] [NVARCHAR](MAX) NULL,
	[VacancyDepartment] [NVARCHAR](MAX) NULL,
	[VacancyInvoicePoint] [DECIMAL](16, 0) NULL,
	[VacancyIsExclusive] [NVARCHAR](MAX) NULL,
	[VacancyReportsTo] [DECIMAL](16, 0) NULL,
	[VacancyContractType] [DECIMAL](20, 0) NULL,
	[VacancyAddDate] [DATETIME2](0) NULL,
	[VacancyOpenToDate] [DATETIME2](0) NULL,
	[VacancyCRBCheckRequired] [NVARCHAR](MAX) NULL,
	[VacancyDrivingLicenceRequired] [NVARCHAR](MAX) NULL,
	[VacancyPayFrequency] [DECIMAL](20, 0) NULL,
	[VacancyWeekendWorkRequired] [NVARCHAR](MAX) NULL,
	[VacancyNightWorkRequired] [NVARCHAR](MAX) NULL,
	[VacancyShiftWorkRequired] [NVARCHAR](MAX) NULL,
	[JobOppotunityCategory] [DECIMAL](20, 0) NULL,
	[VacancyContractedWeeklyHours] [DECIMAL](5, 2) NULL,
	[VacancySOCCode] [DECIMAL](20, 0) NULL,
	[VacancyEmployerReference] [DECIMAL](16, 0) NULL,
	[VacancyApplicationMethod] [DECIMAL](20, 0) NULL,
	[VacancySource] [DECIMAL](20, 0) NULL,
	[VacancyPositionsRemaining] [DECIMAL](4, 0) NULL,
	[VacancyWoringkHours] [NVARCHAR](MAX) NULL,
	[VacancyOriginalNumberRequired] [DECIMAL](3, 0) NULL,
	[VacancySalaryCurrency] [INT]  NULL,
	[VacancyAddUser] [NVARCHAR](MAX) NULL,
	[VacancyOwner] [NVARCHAR](MAX) NULL,
	[Town] [NVARCHAR](MAX) NULL,
	[PostCode] [NVARCHAR](MAX) NULL,
	[ContentHash] [BINARY](32) NULL,
	[ValidFrom] [DATETIME2](0) NULL,
	[ValidTo] [DATETIME2](0) NULL,
	[IsCurrent] [BIT] NULL
)
WITH
(
	DISTRIBUTION = HASH ( [VacancyHash] ),
	HEAP
)
GO
