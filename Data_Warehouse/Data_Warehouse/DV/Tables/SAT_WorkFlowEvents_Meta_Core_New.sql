CREATE TABLE [DV].[SAT_WorkFlowEvents_Meta_Core_New]
(
	[CaseHashBin] [binary](32) NOT NULL,
	[CaseHash] [char](66) NOT NULL,
	[EmployeeHashBin] [binary](32) NULL,
	[EmployeeHash] [char](66) NULL,
	[AssignmentHashIfNeeded] [char](66) NULL,
	[WorkFlowEventDate] [date] NULL,
	[WorkFlowEventEstimatedStartDate] [date] NULL,
	[WorkFlowEventEstimatedEndDate] [date] NULL,
	[InOutWork] [varchar](10) NULL,
	[CSSName] [varchar](24) NOT NULL,
	[RecordSource] [varchar](24) NOT NULL
)
WITH
(
	DISTRIBUTION = HASH ( [CaseHashBin] ),
	HEAP
)