CREATE TABLE [DV].[LINK_Case_JournalEntries]
(
	[Case_JournalEntriesHash] [binary](32) NULL,
	[CaseHash] [binary](32) NULL,
	[JournalEntriesHash] [binary](32) NULL,
	[RecordSource] [varchar](50) NULL,
	[ValidFrom] [datetime2](0) NULL
)
WITH (HEAP, DISTRIBUTION=HASH([Case_JournalEntriesHash]) ) 
GO


