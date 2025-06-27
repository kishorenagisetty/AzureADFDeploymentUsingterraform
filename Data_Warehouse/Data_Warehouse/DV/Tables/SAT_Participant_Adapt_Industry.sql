CREATE TABLE [DV].[SAT_Participant_Adapt_Industry]
(
	[ParticipantHash] [binary](32) NULL,
	[ParticipantKey] [nvarchar](100) NULL,
	[Industry] [decimal](20, 0) NULL,
	[ContentHash] [binary](32) NULL,
	[ValidFrom] [datetime2](0) NULL,
	[ValidTo] [datetime2](0) NULL,
	[IsCurrent] [bit] NULL
)
WITH
(
	DISTRIBUTION = HASH ( [ParticipantHash] ),
	HEAP
)
GO