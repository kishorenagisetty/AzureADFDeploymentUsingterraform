CREATE TABLE [DV].[SAT_Correspondence_Adapt_Core]
(
	[CorrespondenceHash] [BINARY](32) NULL,
	[CorrespondenceKey] [NVARCHAR](100) NULL,
	[CorrespondenceReferenceKey] [VARCHAR](30) NOT NULL,
	[RecordSource] [VARCHAR](17) NOT NULL,
	[CorrespondenceOutcome] [DECIMAL](20, 0) NULL,
	[CorrespondenceMethod] [DECIMAL](20, 0) NULL,
	[CorrespondenceType] [DECIMAL](20, 0) NULL,
	[CorrespondenceDate] [DATETIME2](0) NULL,
	[CorrespondenceContactBy] [DECIMAL](16, 0) NULL,
	[CorrespondenceNotes] [NVARCHAR](MAX) NULL,
	[ContentHash] [BINARY](32) NULL,
	[ValidFrom] [DATETIME2](0) NULL,
	[ValidTo] [DATETIME2](0) NULL,
	[IsCurrent] [BIT] NULL
)
WITH
(
	DISTRIBUTION = HASH ( [CorrespondenceHash] ),
	HEAP
)
GO