CREATE TABLE [DV].[SAT_ActivityType_Iconi_Refugee]
(
	[ActivityTypeHash] [BINARY](32) NULL,
	[ActivityTypeKey] [NVARCHAR](MAX) NOT NULL,
	[ActivityType] [NVARCHAR](MAX) NULL,
	[ContentHash] [BINARY](32) NULL,
	[ValidFrom] [DATETIME2](0) NULL,
	[ValidTo] [DATETIME2](0) NULL,
	[IsCurrent] [BIT] NULL
)
WITH
(
	DISTRIBUTION = HASH ( [ActivityTypeHash] ),
	HEAP
)