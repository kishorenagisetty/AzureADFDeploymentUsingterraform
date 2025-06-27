
CREATE TABLE [LZ].[LZ_CSSAnalysis4567]
(
	[Period_Start] [date] NULL,
	[Period_End] [date] NULL,
	[QualifyingMeeting] [date] NULL,
	[Engagement_id] [bigint] NULL,
	[CSSType] [varchar](4) NULL
)
WITH
(
	DISTRIBUTION = ROUND_ROBIN,
	CLUSTERED COLUMNSTORE INDEX
)
GO

