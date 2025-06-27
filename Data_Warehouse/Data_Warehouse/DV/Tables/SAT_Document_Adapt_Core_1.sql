CREATE TABLE [DV].[SAT_Document_Adapt_Core]
(
	[DocumentHash] [BINARY](32) NULL,
	[DocumentKey] [NVARCHAR](100) NULL,
	[DocumentReferenceKey] [VARCHAR](18) NOT NULL,
	[DocumentName] [NVARCHAR](MAX) NULL,
	[Document] [NVARCHAR](max) NULL,
	[Receiver] [INT] NULL,
	[ReceivedDate] [DATETIME2](0) NULL,
	[SentDate] [DATETIME2](0) NULL,
	[ResentDate] [DATETIME2](0) NULL,
	[Status] [BIGINT] NULL,
	[CompletedBy] [INT] NULL,
	[CompletedDate] [DATETIME2](0) NULL,
	[QueriedBy] [INT] NULL,
	[QueriedDate] [DATETIME2](0) NULL,
	[Notes] [NVARCHAR](MAX) NULL,
	[Sender] [INT] NULL,
	[Resender] [INT] NULL,
	[ContentHash] [BINARY](32) NULL,
	[ValidFrom] [DATETIME2](0) NULL,
	[ValidTo] [DATETIME2](0) NULL,
	[IsCurrent] [BIT] NULL
)
WITH
(
	DISTRIBUTION = HASH ( [DocumentHash] ),
	HEAP
)
GO
