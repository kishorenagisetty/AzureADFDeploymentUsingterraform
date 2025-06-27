CREATE TABLE [DV].[F_AssignmentEarnings]
(
	[AssignmentEarningPatternHash] [BINARY](32) NULL,
	[AssignmentHash] [BINARY](32) NULL,
	[CaseHash] [BINARY](32) NULL,
	[ParticipantHash] [BINARY](32) NULL,
	[EmployeeHash] [BINARY](32) NULL,
	[ReferralHash] [BINARY](32) NULL,
	[ProgrammeHash] [BINARY](32) NULL,
	[DeliverySiteHash] [BINARY](32) NULL,
	[AssignmentEarningPatternKey] [NVARCHAR](100) NULL,
	[WorkingDayKey] [INT] NULL,
	[Working_Hours] [DECIMAL](10,5) NULL,
	[Hourly_Rate] [DECIMAL](10,5) NULL,
	[Weekly_Hours] [DECIMAL](10,5) NULL
)
WITH
(
	DISTRIBUTION = HASH ( [AssignmentEarningPatternHash] ),
	HEAP
)
GO
