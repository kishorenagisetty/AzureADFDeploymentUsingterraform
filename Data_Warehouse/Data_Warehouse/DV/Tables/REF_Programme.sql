CREATE TABLE [DV].[REF_Programme]
(
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[ProgrammeKey] [varchar](20) NULL,
	[RecordSource] [varchar](50) NULL,
	[ProgrammeName] [varchar](250) NULL,
	[ProgrammeSupportLength] [int] NULL,
	[ProgrammeSupportExtensionLength] [int] NULL,
	[ProgrammeOutcomeTrackingLength] [int] NULL,
	[ProgrammeOutcomeOneThresholdEarnings] [numeric](18, 2) NULL,
	[ProgrammeOutcomeOneThresholdDays] [int] NULL,
	[ProgrammeSelfEmployedOutcomeOneThreshold] [int] NULL,
	[ProgrammeOutcomeModel] [varchar](50) NULL,
	[ProgrammeOutcomeTwoThresholdEarnings] [numeric](18, 2) NULL,
	[ProgrammeOutcomeTwoThresholdDays] [int] NULL,
	[ProgrammeSelfEmployedOutcomeTwoThreshold] [int] NULL,
	[ProgrammeOutcomeThreeThresholdEarnings] [numeric](18, 2) NULL,
	[ProgrammeOutcomeThreeThresholdDays] [int] NULL,
	[ProgrammeOutcomeOneClaimPeriod] [int] NULL,
	[ProgrammeOutcomeTwoClaimPeriod] [int] NULL,
	[ProgrammeOutcomeThreeClaimPeriod] [int] NULL
)
WITH
(
	DISTRIBUTION = ROUND_ROBIN,
	CLUSTERED COLUMNSTORE INDEX
)
GO