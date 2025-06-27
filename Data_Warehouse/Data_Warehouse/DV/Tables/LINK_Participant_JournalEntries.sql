CREATE TABLE [DV].[LINK_Participant_JournalEntries]
(
	[Participant_JournalEntriesHash] [BINARY](32) NULL,
	[ParticipantHash] [BINARY](32) NULL,
	[JournalEntriesHash] [BINARY](32) NULL,
	[RecordSource] [VARCHAR](50) NULL,
	[ValidFrom] [DATETIME2](7) NULL
)
WITH
(
	DISTRIBUTION = HASH ( [Participant_JournalEntriesHash] ),
	HEAP
)
GO