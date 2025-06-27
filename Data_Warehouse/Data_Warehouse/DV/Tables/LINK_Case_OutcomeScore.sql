CREATE TABLE [DV].[LINK_Case_OutcomeScore]
(
	[Case_OutcomeScoreHash] [binary](32) NULL,
	[CaseHash] [binary](32) NULL,
	[OutcomeScoreHash] [binary](32) NULL,
	[RecordSource] [varchar](50) NULL,
	[ValidFrom] [datetime2](0) NULL
)
WITH (HEAP, DISTRIBUTION=HASH([Case_OutcomeScoreHash]) ) 

