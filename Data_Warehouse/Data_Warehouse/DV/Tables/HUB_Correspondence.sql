CREATE TABLE [DV].[HUB_Correspondence]
(
	[CorrespondenceHash] [BINARY](32) NULL,
	[CorrespondenceKey] [NVARCHAR](100) NULL,
	[RecordSource] [VARCHAR](50) NULL,
	[ValidFrom] [DATETIME2](0) NULL
)
WITH
(
	DISTRIBUTION = HASH ( [CorrespondenceHash] ),
	HEAP
)
GO

