CREATE TABLE [DV].[LINKSAT_Case_Assignment_Adapt_Core]
(
	[Case_AssignmentHash] [binary](32) NULL,
	[Case_AssignmentKey] [nvarchar](100) NULL,
	[CaseKey] [varchar](18) NOT NULL,
	[AssignmentKey] [varchar](18) NOT NULL,
	[RecordSource] [varchar](20) NOT NULL,
	[ContentHash] [binary](32) NULL,
	[ValidFrom] [datetime2](0) NULL,
	[ValidTo] [datetime2](0) NULL,
	[IsCurrent] [bit] NULL
)
WITH
(
	DISTRIBUTION = HASH ( [Case_AssignmentHash] ),
	HEAP
)
GO