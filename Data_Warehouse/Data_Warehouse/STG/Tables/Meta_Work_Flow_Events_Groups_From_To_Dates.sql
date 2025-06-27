CREATE TABLE [STG].[Meta_Work_Flow_Events_Groups_From_To_Dates]
(
	[CaseKey] [nvarchar](100) NULL,
	[CaseHash] [char](66) NULL,
	[ReferralHash] [char](66) NULL,
	[ProgrammeKey] [nvarchar](100) NULL,
	[Programmehash] [char](66) NULL,
	[WorkFlowEventTypeKey] [int] NULL,
	[WorkFlowEventID] [nvarchar](255) NULL,
	[WorkFlowEventPreviousEventID] [nvarchar](255) NULL,
	[WorkFlowEventName] [nvarchar](255) NULL,
	[WorkFlowEventDate] [datetime] NULL,
	[EventEndDate] [datetime] NULL,
	[WorkFlowEventUser] [int] NULL,
	[WorkFlowEventEstimatedStartDate] [datetime] NULL,
	[WorkFlowEventEstimatedEndDate] [datetime] NULL,
	[WorkFlowEventRecurring] [nvarchar](255) NULL,
	[PreviousWorkFlowEventRecurring] [nvarchar](255) NULL
)
WITH
(
	DISTRIBUTION = ROUND_ROBIN,
	CLUSTERED COLUMNSTORE INDEX
)
GO