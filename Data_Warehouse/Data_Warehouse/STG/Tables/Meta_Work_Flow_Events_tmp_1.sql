CREATE TABLE [STG].[Meta_Work_Flow_Events_tmp]
(
	[CaseKey] [nvarchar](100) NULL,
	[CaseHash] [char](66) NULL,
	[ReferralHash] [char](66) NULL,
	[ProgrammeKey] [nvarchar](100) NULL,
	[ProgrammeHash] [char](66) NULL,
	[WorkFlowEventTypeKey] [int] NULL,
	[WorkFlowEventID] [nvarchar](255) NULL,
	[WorkFlowEventPreviousEventID] [nvarchar](255) NULL,
	[WorkFlowEventName] [nvarchar](255) NULL,
	[WorkFlowEventDate] [datetime] NULL,
	[EventEndDate] [datetime] NULL,
	[WorkFlowEventUser] [int] NULL,
	[StartDate] [int] NULL,
	[LeaveDate] [int] NULL,
	[LeaveReason] [nvarchar](100) NULL,
	[ReferralDateKey] [int] NULL
)
WITH
(
	DISTRIBUTION = ROUND_ROBIN,
	CLUSTERED COLUMNSTORE INDEX
)
GO