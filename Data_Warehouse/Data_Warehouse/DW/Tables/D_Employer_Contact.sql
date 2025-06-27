CREATE TABLE [DW].[D_Employer_Contact] (
    [Employer_Contact_Skey] INT           NOT NULL,
    [EmployerContactBusKey] INT           NOT NULL,
    [ContactName]           VARCHAR (255) NULL,
    [ContactRole]           VARCHAR (21)  NOT NULL,
    [PhoneNumber]           VARCHAR (50)  NULL,
    [Email]                 VARCHAR (255) NULL,
    [ContactMethod]         VARCHAR (255) NULL,
    [Sys_LoadDate]          DATETIME      NULL,
    [Sys_ModifiedDate]      DATETIME      NULL,
    [Sys_RunID]             INT           NULL
)
WITH (CLUSTERED COLUMNSTORE INDEX, DISTRIBUTION = REPLICATE);

