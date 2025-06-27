
CREATE TABLE [DV].[LINK_Assignment_AssignmentEarningPattern]
(
	[Assignment_AssignmentEarningPatternHash] [BINARY](32) NULL,
	[AssignmentHash] [BINARY](32) NULL,
	[AssignmentEarningPatternHash] [BINARY](32) NULL,
	[RecordSource] [VARCHAR](50) NULL,
	[ValidFrom] [DATETIME2](7) NULL
)
WITH
(
	DISTRIBUTION = HASH ( [Assignment_AssignmentEarningPatternHash] ),
	HEAP
)
GO