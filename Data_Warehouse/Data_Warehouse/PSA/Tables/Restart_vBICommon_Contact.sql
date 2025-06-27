CREATE TABLE [PSA].[Restart_vBICommon_Contact] (
    [con_key]                INT            NOT NULL,
    [contact_id]             INT            NULL,
    [con_contact_details_id] INT            NULL,
    [con_forename]           VARCHAR (250)  NULL,
    [con_surname]            VARCHAR (250)  NULL,
    [con_job_title]          VARCHAR (250)  NULL,
    [con_notes]              VARCHAR (4000) NULL,
    [con_added_date]         DATETIME       NULL,
    [con_title]              VARCHAR (500)  NULL,
    [con_status]             VARCHAR (500)  NULL,
    [con_last_updated_date]  DATETIME       NULL,
    [Sys_RunID]              INT            NULL,
    [Sys_LoadDate]           DATETIME       NULL,
    [Sys_LoadExpiryDate]     DATETIME       NULL,
    [Sys_IsCurrent]          BIT            NULL,
    [Sys_BusKey]             INT            NULL,
    [Sys_HashKey]            BINARY (16)    NULL
)
WITH (CLUSTERED INDEX([Sys_BusKey]), DISTRIBUTION = HASH([Sys_BusKey]));

