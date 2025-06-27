CREATE TABLE [DV].[SAT_ActivityType_Iconi_Core]
(
	[ActivityTypeHash] [binary](32) NULL,
	[ActivityTypeKey] [nvarchar](max) NULL,
	[ActivityType] [nvarchar](max) NULL,
	[ContentHash] [binary](32) NULL,
	[ValidFrom] [datetime2](0) NULL,
	[ValidTo] [datetime2](0) NULL,
	[IsCurrent] [bit] NULL
)
WITH
(
	DISTRIBUTION = HASH ( [ActivityTypeHash] ),
	HEAP
)
GO