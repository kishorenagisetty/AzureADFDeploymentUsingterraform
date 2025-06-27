CREATE TABLE [DV].[SAT_Employee_Iconi_Core] (
    [EmployeeHash]            BINARY (32)    NULL,
    [EmployeeKey]             NVARCHAR (100) NULL,
    [EmployeeFullName]        NVARCHAR (MAX) NULL,
    [EmployeeFirstName]       NVARCHAR (MAX) NULL,
    [EmployeeLastName]        NVARCHAR (MAX) NULL,
    [EmployeeAgency]          INT            NULL,
    [EmployeeEmail]           NVARCHAR (MAX) NULL,
    [EmployeeSuspendedDate]   DATETIME2 (0)  NULL,
    [EmployeeType]            NVARCHAR (MAX) NULL,
    [EmployeeOrganisation]    INT            NULL,
    [EmployeeAddedDate]       DATETIME2 (0)  NULL,
    [EmployeeUsername]        NVARCHAR (MAX) NULL,
    [EmployeeSupportsOver50]  NVARCHAR (MAX) NULL,
    [EmployeeLocked]          BIT            NULL,
    [EmployeeSsoIdentifier]   NVARCHAR (MAX) NULL,
    [EmployeeSsoEnabled]      BIT            NULL,
    [EmployeeJobTitle]        NVARCHAR (MAX) NULL,
    [EmployeeNotes]           NVARCHAR (MAX) NULL,
    [EmployeeLastLogin]       DATETIME2 (0)  NULL,
    [EmployeeArchive]         BIT            NULL,
    [EmployeeTimeoutTimer]    INT            NULL,
    [EmployeeLicencingProg]   INT            NULL,
    [EmployeeLastUpdatedDate] DATETIME2 (0)  NULL,
    [ContentHash]             BINARY (32)    NULL,
    [ValidFrom]               DATETIME2 (0)  NULL,
    [ValidTo]                 DATETIME2 (0)  NULL,
    [IsCurrent]               BIT            NULL
)
WITH (HEAP, DISTRIBUTION = HASH([EmployeeHash]));
GO

