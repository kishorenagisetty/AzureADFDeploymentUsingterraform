CREATE TABLE [DV].[SAT_Assignment_LeaveAudit_Adapt_Core]
(
	[AssignmentHash] [BINARY](32) NULL,
	[AssignmentKey] [NVARCHAR](100) NULL,
	[CaseKey] [VARCHAR](18) NOT NULL,
	[AuditDate] [DATETIME2](0) NULL,
	[LeaveDate] [DATE] NULL,
	[LeaveReason] [NVARCHAR](MAX) NULL,
	[ContentHash] [BINARY](32) NULL,
	[ValidFrom] [DATETIME2](0) NULL,
	[ValidTo] [DATETIME2](0) NULL,
	[IsCurrent] [BIT] NULL
)
WITH
(
	DISTRIBUTION = HASH ( [AssignmentHash] ),
	HEAP
)
GO