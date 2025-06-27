CREATE TABLE [DV].[LINK_Case_Employee] (
    [Case_EmployeeHash] BINARY (32)   NULL,
    [CaseHash]          BINARY (32)   NULL,
    [EmployeeHash]      BINARY (32)   NULL,
    [RecordSource]      VARCHAR (50)  NULL,
    [ValidFrom]         DATETIME2 (0) NULL
)
WITH (HEAP, DISTRIBUTION=HASH([Case_EmployeeHash]) ) 
GO


