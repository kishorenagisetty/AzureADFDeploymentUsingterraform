CREATE TABLE [DV].[SAT_Participant_Adapt_Core_PersonGen]
(
	[ParticipantHash] [BINARY](32) NULL,
	[ParticipantKey] [NVARCHAR](100) NULL,
	[ParticipantEntityKey] [VARCHAR](18) NOT NULL,
	[FullName] [NVARCHAR](MAX) NULL,
	[Title] [INT] NULL,
	[FirstName] [VARCHAR](8000) NULL,
	[MiddleName] [VARCHAR](8000) NULL,
	[LastName] [VARCHAR](8000) NULL,
	[DateOfBirth] [DATETIME2](0) NULL,
	[DisabilityNotes] [NVARCHAR](MAX) NULL,
	[VacancyGoal1] [NVARCHAR](MAX) NULL,
	[VacancyGoal2] [NVARCHAR](MAX) NULL,
	[VacancyGoal3] [NVARCHAR](MAX) NULL,
	[ContentHash] [BINARY](32) NULL,
	[ValidFrom] [DATETIME2](0) NULL,
	[ValidTo] [DATETIME2](0) NULL,
	[IsCurrent] [BIT] NULL
)
WITH
(
	DISTRIBUTION = HASH ( [ParticipantHash] ),
	HEAP
)
GO
