CREATE TABLE [DV].[LINK_Activity_Employee]
(
	[Activity_EmployeeHash] [binary](32) NULL,
	[ActivityHash] [binary](32) NULL,
	[EmployeeHash] [binary](32) NULL,
	[RecordSource] [varchar](50) NULL,
	[ValidFrom] [datetime2](0) NULL
)
WITH
(
	DISTRIBUTION = HASH ( [ActivityHash] ),
	HEAP
)
GO
