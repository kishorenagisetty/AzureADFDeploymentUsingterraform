/****** Object:  Table [DV].[SAT_AssignmentEarningPattern_ICONI_Core]    Script Date: 27/01/2022 15:58:17 ******/


CREATE TABLE [DV].[SAT_AssignmentEarningPattern_Iconi_Core]
(
	[AssignmentEarningPatternHash] [binary](32) NULL,
	[AssignmentEarningPatternKey] [nvarchar](100) NULL,
	[EarningPatternEffectiveTo] [date] NULL,
	[EarningPatternWeeklyHours] [decimal](19, 2) NULL,
	[EarningPatternEffectiveFrom] [date] NULL,
	[EarningPatternDaysPerWeek] [nvarchar](max) NULL,
	[EarningPatternDateChanged] [datetime2](0) NULL,
	[OutcomeEntityID] [int] NULL,
	[EarningPatternPaymentAmount] [decimal](19, 4) NULL,
	[EarningPatternPaymentFrequency] [nvarchar](max) NULL,
	[ContentHash] [binary](32) NULL,
	[ValidFrom] [datetime2](0) NULL,
	[ValidTo] [datetime2](0) NULL,
	[IsCurrent] [bit] NULL
)
WITH
(
	DISTRIBUTION = HASH ( [AssignmentEarningPatternHash] ),
	HEAP
)
GO


