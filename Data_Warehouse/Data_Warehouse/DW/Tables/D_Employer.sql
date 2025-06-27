CREATE TABLE [DW].[D_Employer] (
    [Employer_Skey]    INT           NOT NULL,
    [EmployerBusKey]   INT           NOT NULL,
    [EmployerName]     VARCHAR (255) NULL,
    [EmployerSize]     VARCHAR (255) NULL,
    [EmployerType]     VARCHAR (255) NULL,
    [EmployerSector]   VARCHAR (255) NULL,
    [EmployerRole]     VARCHAR (8)   NOT NULL,
    [Sys_LoadDate]     DATETIME      NULL,
    [Sys_ModifiedDate] DATETIME      NULL,
    [Sys_RunID]        INT           NULL
)
WITH (CLUSTERED COLUMNSTORE INDEX, DISTRIBUTION = REPLICATE);

