CREATE TABLE [DV].[SAT_WorkFlowEvents_Meta_Core]
(
	[WorkFlowEventsHash] [binary](32) NULL,
	[WorkFlowEventsKey] [nvarchar](118) NULL,
	[EventDate] [date] NULL,
	[EventEstimatedStartDate] [date] NULL,
	[EventEstimatedEndDate] [date] NULL,
	[EventEndDate] [date] NULL,
	[InOutWork] [varchar](10) NULL,
	[EventSkippedCount] [int] NULL,
	[RecordSource] [varchar](24) NOT NULL,
	[ContentHash] [binary](32) NULL,
	[ValidFrom] [datetime2](0) NULL,
	[ValidTo] [datetime2](0) NULL,
	[IsCurrent] [bit] NULL
)
WITH
(
	DISTRIBUTION = HASH ( [WorkFlowEventsHash] ),
	HEAP
)
GO

