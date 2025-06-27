CREATE TABLE [DV].[LINK_Activity_ActivityType]
(
	[Activity_ActivityTypeHash] [binary](32) NULL,
	[ActivityHash] [binary](32) NULL,
	[ActivityTypeHash] [binary](32) NULL,
	[RecordSource] [varchar](50) NULL,
	[ValidFrom] [datetime2](0) NULL
)
WITH
(
	DISTRIBUTION = HASH ( [ActivityHash] ),
	HEAP
)
GO