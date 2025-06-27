CREATE TABLE [DV].[HUB_JournalEntries]
(
	[JournalEntriesHash] [binary](32) NULL,
	[JournalEntriesKey] [nvarchar](100) NULL,
	[RecordSource] [varchar](50) NULL,
	[ValidFrom] [datetime2](0) NULL
)
WITH
(
	DISTRIBUTION = HASH ( [JournalEntriesHash] ),
	HEAP
)
GO