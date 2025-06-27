CREATE TABLE [DV].[SAT_JournalEntries_Adapt_Core]
(
	[JournalEntriesHash] [binary](32) NULL,
	[JournalEntriesKey] [nvarchar](100) NULL,
	[JournalEntriesEntityIDKey] [varchar](30) NOT NULL,
	[AddDate] [datetime2](0) NULL,
	[Addedby] [nvarchar](max) NULL,
	[BusinessObject] [nvarchar](max) NULL,
	[JournalNotes] [nvarchar](max) NULL,
	[NotesEditDate] [datetime2](0) NULL,
	[ContentHash] [binary](32) NULL,
	[ValidFrom] [datetime2](0) NULL,
	[ValidTo] [datetime2](0) NULL,
	[IsCurrent] [bit] NULL
)
WITH
(
	DISTRIBUTION = HASH ( [JournalEntriesHash] ),
	HEAP
)
GO


