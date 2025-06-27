CREATE TABLE [DV].[LINKSAT_Case_Employee_Adapt_Core]
(
[Case_EmployeeHash] [BINARY](32) NULL,
[Case_EmployeeKey] [NVARCHAR](100) NULL,
[CaseKey] [VARCHAR](18) NOT NULL,
[EmployeeKey] [VARCHAR](18) NOT NULL,
[RecordSource] [VARCHAR](20) NOT NULL,
[ContentHash] [BINARY](32) NULL,
[ValidFrom] [DATETIME2](0) NULL,
[ValidTo] [DATETIME2](0) NULL,
[IsCurrent] [BIT] NULL
)
WITH
(
DISTRIBUTION = HASH ( [Case_EmployeeHash] ),
HEAP
)
GO
