CREATE TABLE [DV].[LINK_Case_Correspondence]
(
	[Case_CorrespondenceHash] [BINARY](32) NULL,
	[CaseHash] [BINARY](32) NULL,
	[CorrespondenceHash] [BINARY](32) NULL,
	[RecordSource] [VARCHAR](50) NULL,
	[ValidFrom] [DATETIME2](0) NULL
)
WITH (HEAP, DISTRIBUTION=HASH([Case_CorrespondenceHash]) ) 
GO


