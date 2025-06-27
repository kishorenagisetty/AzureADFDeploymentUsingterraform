CREATE TABLE [DV].[SAT_Provider_Adapt_Core]
(
	[ProviderHash] [binary](32) NULL,
	[ProviderKey] [nvarchar](4000) NULL,
	[Zone] [nvarchar](255) NULL,
	[Reporting_Region] [nvarchar](255) NULL,
	[Reporting_Area_Branch] [nvarchar](255) NULL,
	[Reporting_Zone] [nvarchar](255) NULL,
	[Baan_Region] [varchar](10) NULL,
	[Baan_Area_Branch] [nvarchar](4000) NULL,
	[Baan_Zone] [varchar](10) NULL,
	[DS_Region] [nvarchar](4000) NULL,
	[TempID] [nvarchar](4000) NULL,
	[Ofsted] [varchar](50) NULL,
	[ROM] [nvarchar](4000) NULL,
	[Delivery] [nvarchar](4000) NULL,
	[CoreProvider] [nvarchar](4000) NULL,
	[ID] [nvarchar](4000) NULL,
	[BranchManager] [nvarchar](4000) NULL,
	[BranchManagerEmail] [nvarchar](4000) NULL,
	[ROM_Email] [nvarchar](4000) NULL,
	[WPSite] [nvarchar](4000) NULL,
	[Email_CC] [nvarchar](4000) NULL,
	[CPA] [nvarchar](4000) NULL,
	[NorthSouth] [nvarchar](4000) NULL,
	[QualityManager] [nvarchar](4000) NULL,
	[IsActive] [nvarchar](4000) NULL,
	[Reporting_Hierarchy] [nvarchar](4000) NULL,
	[Region_SES] [nvarchar](4000) NULL,
	[BranchOwner] [nvarchar](4000) NULL,
	[FinanceName] [nvarchar](4000) NULL,
	[BranchManagerEmpNo] [nvarchar](4000) NULL,
	[WHPLot] [nvarchar](4000) NULL,
	[DataOwner] [nvarchar](4000) NULL,
	[ContentHash] [binary](32) NULL,
	[ValidFrom] [datetime2](0) NULL,
	[ValidTo] [datetime2](0) NULL,
	[IsCurrent] [bit] NULL
)
WITH
(
	DISTRIBUTION = HASH ( [ProviderHash] ),
	HEAP
)
GO
