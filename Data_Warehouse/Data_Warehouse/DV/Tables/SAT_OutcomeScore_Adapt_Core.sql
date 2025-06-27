CREATE TABLE [DV].[SAT_OutcomeScore_Adapt_Core]
(
	[OutcomeScoreHash] [binary](32) NULL,
	[OutcomeScoreKey] [nvarchar](100) NULL,
	[Q1Answer] [decimal](20, 0) NULL,
	[Q2Answer] [decimal](20, 0) NULL,
	[Q3Answer] [decimal](20, 0) NULL,
	[Q4Answer] [decimal](20, 0) NULL,
	[Q5Answer] [decimal](20, 0) NULL,
	[Q6Answer] [decimal](20, 0) NULL,
	[Q7Answer] [decimal](20, 0) NULL,
	[Q8Answer] [nvarchar](max) NULL,
	[Total] [decimal](2, 0) NULL,
	[Colour] [nvarchar](max) NULL,
	[AnswerDate] [datetime2](0) NULL,
	[ContentHash] [binary](32) NULL,
	[ValidFrom] [datetime2](0) NULL,
	[ValidTo] [datetime2](0) NULL,
	[IsCurrent] [bit] NULL
)
WITH
(
	DISTRIBUTION = HASH ( [OutcomeScoreHash] ),
	HEAP
)
GO