CREATE TABLE [DV].[HUB_ActivityType]
(
	[ActivityTypeHash] [binary](32) NULL,
	[ActivityTypeKey] [nvarchar](100) NULL,
	[RecordSource] [varchar](50) NULL,
	[ValidFrom] [datetime2](0) NULL
)
WITH
(
	DISTRIBUTION = HASH ( [ActivityTypeHash] ),
	HEAP
)
GO