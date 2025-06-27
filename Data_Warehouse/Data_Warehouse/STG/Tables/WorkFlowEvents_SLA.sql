CREATE TABLE [STG].[WorkFlowEvents_SLA]
(
	[CaseKey] [nvarchar](100) NULL,
	[WorkFlowEventID] [nvarchar](255) NULL,
	[WorkFlowEventName] [nvarchar](255) NULL,
	[WorkFlowEventDate] [datetime] NULL,
	[EventEndDate] [datetime] NULL,
	[WorkFlowEventOriginalStartDate] [datetime] NULL,
	[EventEstimatedEndDate] [datetime] NULL,
	[WorkFlowEventPreviousEventID] [nvarchar](255) NULL,
	[WorkFlowEventSLAType] [nvarchar](255) NULL,
	[WorkFlowEventSLADurationType] [nvarchar](255) NULL,
	[WorkFlowEventSLADuration] [nvarchar](255) NULL,
	[WorkFlowEventCSSRelated] [nvarchar](255) NULL,
	[WorkFlowEventRecurring] [nvarchar](255) NULL
)
WITH
(
	DISTRIBUTION = HASH ( [CaseKey] ),
	CLUSTERED COLUMNSTORE INDEX
)
GO
