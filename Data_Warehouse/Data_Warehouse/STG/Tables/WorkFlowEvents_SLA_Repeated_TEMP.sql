CREATE TABLE [STG].[WorkFlowEvents_SLA_Repeated_TEMP]
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
	[WorkFlowEventDate] [datetime2](3) NULL,
	[EventEndDate] [datetime] NULL,
	[WorkFlowEventUser] [int] NULL,
	[WorkFlowEventEstimatedStartDate] [datetime] NULL,
	[WorkFlowEventEstimatedEndDate] [datetime] NULL,
	[AssignmentStartDate] [datetime2](0) NULL,
	[AssignmentLeaveDate] [datetime2](0) NULL,
	[InOutWork] [varchar](10) NULL
)
WITH
(
	DISTRIBUTION = HASH ( [CaseKey] ),
	CLUSTERED COLUMNSTORE INDEX
)
GO



