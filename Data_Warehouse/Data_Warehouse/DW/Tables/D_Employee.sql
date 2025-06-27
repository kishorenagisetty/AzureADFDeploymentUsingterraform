CREATE TABLE [DW].[D_Employee] (
    [Employee_Skey]     INT           NOT NULL,
    [EmployeeBusKey]    INT           NOT NULL,
    [CascadeEmployeeID] VARCHAR (255) NULL,
    [FirstName]         VARCHAR (255) NULL,
    [FullName]          VARCHAR (255) NULL,
    [LastName]          VARCHAR (255) NULL,
    [LegalEntity]       VARCHAR (13)  NULL,
    [EmployeeType]      VARCHAR (255) NULL,
    [WorkEmail]         VARCHAR (255) NULL,
    [PskUserID]         VARCHAR (255) NULL,
    [Leaver]            INT           NULL,
    [Sys_LoadDate]      DATETIME      NULL,
    [Sys_ModifiedDate]  DATETIME      NULL,
    [Sys_RunID]         INT           NULL
)
WITH (CLUSTERED COLUMNSTORE INDEX, DISTRIBUTION = REPLICATE);

