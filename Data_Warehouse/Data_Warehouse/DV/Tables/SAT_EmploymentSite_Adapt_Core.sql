CREATE TABLE [DV].[SAT_EmploymentSite_Adapt_Core]
(
	[EmploymentSiteHash] [binary](32) NULL,
	[EmploymentSiteKey] [nvarchar](100) NULL,
	[EmploymentSiteName] [nvarchar](max) NULL,
	[EmploymentSiteStatus] [decimal](20, 0) NULL,
	[EmploymentSiteWebsiteAddress] [nvarchar](max) NULL,
	[EmploymentSiteSource] [varchar](max) NULL,
	[EmploymentSiteNumberOfEmployees] [varchar](max) NULL,
	[EmploymentSiteLocation] [decimal](20, 0) NULL,
	[EmploymentSiteBlacklisted] [nvarchar](max) NULL,
	[EmploymentSiteTradingName] [nvarchar](max) NULL,
	[EmploymentSiteRegion] [decimal](16, 0) NULL,
	[EmploymentSiteSIC] [decimal](20, 0) NULL,
	[EmploymentSiteIncorporationType] [decimal](20, 0) NULL,
	[EmploymentSiteCreditStatus] [decimal](20, 0) NULL,
	[EmploymentSiteManagedType] [decimal](20, 0) NULL,
	[EmploymentOrgName] [nvarchar](max) NULL,
	[EmploymentJobSector] [nvarchar](max) NULL,
	[IconiReference] [nvarchar](max) NULL,
	[ContentHash] [binary](32) NULL,
	[ValidFrom] [datetime2](0) NULL,
	[ValidTo] [datetime2](0) NULL,
	[IsCurrent] [bit] NULL
)
WITH
(
	DISTRIBUTION = HASH ( [EmploymentSiteHash] ),
	HEAP
)
GO
