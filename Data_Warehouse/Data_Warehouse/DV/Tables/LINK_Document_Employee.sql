CREATE TABLE [DV].[LINK_Document_Employee]
(
	[Document_EmployeeHash] [binary](32) NULL,
	[DocumentHash] [binary](32) NULL,
	[EmployeeHash] [binary](32) NULL,
	[RecordSource] [varchar](50) NULL,
	[ValidFrom] [datetime2](0) NULL
)
WITH (HEAP, DISTRIBUTION=HASH([Document_EmployeeHash]) ) 
GO



