CREATE TABLE [PSA].[Restart_vBICommon_CustomerPortal] (
    [ind_portal_ind_key]                       INT             NOT NULL,
    [ind_portal_individual_id]                 INT             NULL,
    [ind_portal_username]                      VARCHAR (250)   NULL,
    [ind_portal_registration_date]             NVARCHAR (12)   NULL,
    [ind_portal_registration_status]           VARCHAR (500)   NULL,
    [ind_portal_registration_added_by_user_id] INT             NULL,
    [ind_portal_opt_out]                       BIT             NULL,
    [ind_portal_opt_out_reason]                NVARCHAR (4000) NULL,
    [ind_portal_last_active]                   NVARCHAR (12)   NULL,
    [ind_portal_last_welcome_email]            NVARCHAR (12)   NULL,
    [Sys_RunID]                                INT             NULL,
    [Sys_LoadDate]                             DATETIME        NULL,
    [Sys_LoadExpiryDate]                       DATETIME        NULL,
    [Sys_IsCurrent]                            BIT             NULL,
    [Sys_BusKey]                               INT             NULL,
    [Sys_HashKey]                              BINARY (16)     NULL
)
WITH (CLUSTERED INDEX([Sys_BusKey]), DISTRIBUTION = HASH([Sys_BusKey]));

