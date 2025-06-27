CREATE TABLE [DV].[HUB_Entity]
(
	[EntityHash] [BINARY](32) NULL,
	[EntityKey] [NVARCHAR](100) NULL,
	[RecordSource] [VARCHAR](50) NULL,
	[ValidFrom] [DATETIME2](0) NULL
)
WITH
(
	DISTRIBUTION = HASH ( [EntityHash] ),
	HEAP
)
GO
