CREATE TABLE [DV].[HUB_OutcomeScore]
(
	[OutcomeScoreHash] [binary](32) NULL,
	[OutcomeScoreKey] [nvarchar](100) NULL,
	[RecordSource] [varchar](50) NULL,
	[ValidFrom] [datetime2](0) NULL
)
WITH
(
	DISTRIBUTION = HASH ( [OutcomeScoreHash] ),
	HEAP
)
GO