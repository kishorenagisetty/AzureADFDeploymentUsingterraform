CREATE EXTERNAL TABLE [ELT].[WorkFlowEventType]
(
	[WorkFlowEventTypeID] [nvarchar](255) NULL,
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
	[BarrierName] [nvarchar](255) NULL,
	[DocumentTrackingName] [nvarchar](255) NULL,
	[WorkFlowEventDate] [nvarchar](255) NULL,
	[WorkFlowEventDueDate] [datetime] NULL,
	[WorkFlowPreviousEventID] [nvarchar](255) NULL,
	[WorkFlowEventSLAType] [nvarchar](255) NULL,
	[WorkFlowEventSLADurationType] [nvarchar](255) NULL,
	[WorkFlowEventSLAFrom] [nvarchar](255) NULL,
	[WorkFlowEventSLADuration] [nvarchar](255) NULL,
	[WorkFlowEventActionType] [nvarchar](255) NULL,
	[WorkFlowEventCSSRelated] [nvarchar](255) NULL,
	[WorkFlowEventRecurring] [nvarchar](255) NULL,
	[WorkFlowEventTypeCount] [nvarchar](255) NULL,
	[WorkFlowEventTypeExit] [nvarchar](255) NULL,
	[SkippableEventID] [nvarchar](255) NULL
)
WITH (DATA_SOURCE = [ADLG2_PSA],LOCATION = N'WorkflowEvents/WorkFlowEventType.csv',FILE_FORMAT = [CSVFormatStringDelimited],REJECT_TYPE = VALUE,REJECT_VALUE = 0)
GO


