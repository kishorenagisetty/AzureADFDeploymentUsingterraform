CREATE TABLE [DV].[SAT_WorkFlowEventType_Core]
(
	[WorkFlowEventTypeHash] [binary](32) NULL,
	[WorkFlowEventTypeKey] [nvarchar](255) NULL,
	[WorkFlowEventProgramme] [nvarchar](255) NULL,
	[WorkFlowEventStageID] [nvarchar](255) NULL,
	[WorkFlowEventStageCategory] [nvarchar](255) NULL,
	[WorkFlowEventStageName] [nvarchar](255) NULL,
	[WorkFlowEventID] [nvarchar](255) NULL,
	[WorkFlowEventName] [nvarchar](255) NULL,
	[WorkFlowEventType] [nvarchar](255) NULL,
	[CorrospondanceName] [nvarchar](255) NULL,
	[DocumentName] [nvarchar](255) NULL,
	[ActivityName] [nvarchar](255) NULL,
	[DocumentTrackingName] [nvarchar](255) NULL,
	[WorkFlowEventDate] [nvarchar](255) NULL,
	[WorkFlowEventDueDate] [datetime] NULL,
	[WorkFlowEventPreviousEventID] [nvarchar](255) NULL,
	[WorkFlowEventSLAType] [nvarchar](255) NULL,
	[WorkFlowEventSLADurationType] [nvarchar](255) NULL,
	[WorkFlowEventSLAFrom] [nvarchar](255) NULL,
	[WorkFlowEventSLADuration] [nvarchar](255) NULL,
	[WorkFlowEventActionType] [nvarchar](255) NULL,
	[WorkFlowEventCSSRelated] [nvarchar](255) NULL,
	[WorkFlowEventRecurring] [nvarchar](255) NULL,
	[WorkFlowEventTypeCount] [nvarchar](255) NULL,
	[WorkFlowEventTypeExit] [nvarchar](255) NULL,
	[SkippableEventID] [nvarchar](255) NULL,
	[ContentHash] [binary](32) NULL,
	[ValidFrom] [datetime2](0) NULL,
	[ValidTo] [datetime2](0) NULL,
	[IsCurrent] [bit] NULL
)
WITH
(
	DISTRIBUTION = HASH ( [WorkFlowEventTypeHash] ),
	HEAP
)
GO
