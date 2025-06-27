CREATE TABLE [DV].[HUB_Activity]
(
	[ActivityHash] [binary](32) NULL,
	[ActivityKey] [nvarchar](100) NULL,
	[RecordSource] [varchar](50) NULL,
	[ValidFrom] [datetime2](0) NULL
)
WITH
(
	DISTRIBUTION = HASH ( [ActivityHash] ),
	HEAP
)
GO


