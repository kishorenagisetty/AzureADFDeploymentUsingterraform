CREATE TABLE [DV].[SAT_Employee_Adapt_Core] (
    [EmployeeHash]      BINARY (32)    NULL,
    [EmployeeKey]       NVARCHAR (100) NULL,
    [EmployeeName]      NVARCHAR (MAX) NULL,
    [EmployeeFirstName] NVARCHAR (MAX) NULL,
    [EmployeeLastName]  NVARCHAR (MAX) NULL,
    [EmployeeEmail]     NVARCHAR (MAX) NULL,
    [JobTitle]          NVARCHAR (MAX) NULL,
    [UserRefKey]        NVARCHAR (100) NULL,
    [ContentHash]       BINARY (32)    NULL,
    [ValidFrom]         DATETIME2 (0)  NULL,
    [ValidTo]           DATETIME2 (0)  NULL,
    [IsCurrent]         BIT            NULL
)
WITH (HEAP, DISTRIBUTION = HASH([EmployeeHash]));



