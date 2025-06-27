CREATE TABLE [DW].[D_Employee_History] (
    [EmployeeHistory_Skey]  INT           NOT NULL,
    [EmployeeHistoryBusKey] INT           NOT NULL,
    [Employee_Skey]         INT           NULL,
    [SCD_Start]             DATETIME      NULL,
    [SCD_End]               DATETIME      NULL,
    [ReportsTo]             VARCHAR (255) NULL,
    [WorksFor]              VARCHAR (513) NULL,
    [JobTitle]              VARCHAR (255) NULL,
    [WorksForWorkEmail]     VARCHAR (255) NULL,
    [Team]                  VARCHAR (255) NULL,
    [Sys_LoadDate]          DATETIME      NOT NULL,
    [Sys_ModifiedDate]      DATETIME      NOT NULL,
    [Sys_RunID]             INT           NOT NULL
)
WITH (CLUSTERED COLUMNSTORE INDEX, DISTRIBUTION = REPLICATE);



