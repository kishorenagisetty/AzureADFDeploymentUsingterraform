CREATE TABLE [PSA].[Restart_vBICommon_Organisation_Employer_Info] (
    [org_emp_info_key]              INT            NOT NULL,
    [organisation_employer_info_id] INT            NULL,
    [org_emp_info_organisation_id]  INT            NULL,
    [org_emp_info_contact]          VARCHAR (501)  NULL,
    [org_emp_info_managing_erm]     VARCHAR (101)  NULL,
    [org_emp_info_locations]        VARCHAR (500)  NULL,
    [org_emp_info_relationships]    VARCHAR (1000) NULL,
    [org_emp_info_notes]            VARCHAR (4000) NULL,
    [org_emp_info_added_by_user_id] INT            NULL,
    [org_emp_info_added_by_display] VARCHAR (101)  NULL,
    [org_emp_info_added_date]       NVARCHAR (12)  NULL,
    [Sys_RunID]                     INT            NULL,
    [Sys_LoadDate]                  DATETIME       NULL,
    [Sys_LoadExpiryDate]            DATETIME       NULL,
    [Sys_IsCurrent]                 BIT            NULL,
    [Sys_BusKey]                    INT            NULL,
    [Sys_HashKey]                   BINARY (16)    NULL
)
WITH (CLUSTERED INDEX([Sys_BusKey]), DISTRIBUTION = HASH([Sys_BusKey]));

