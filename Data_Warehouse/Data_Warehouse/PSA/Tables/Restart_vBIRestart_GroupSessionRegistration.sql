CREATE TABLE [PSA].[Restart_vBIRestart_GroupSessionRegistration] (
    [group_session_registration_key] INT            NOT NULL,
    [group_session_registration_id]  INT            NULL,
    [gsr_crr_status]                 VARCHAR (500)  NULL,
    [gsr_advisor]                    VARCHAR (101)  NULL,
    [gsr_tran_date]                  NVARCHAR (12)  NULL,
    [gsr_tran_time]                  VARCHAR (5)    NULL,
    [gsr_advisor_notes]              VARCHAR (4000) NULL,
    [gsr_barriers]                   VARCHAR (8000) NULL,
    [gsr_tran_added_by_fullname]     VARCHAR (101)  NULL,
    [gsr_outcome]                    VARCHAR (500)  NULL,
    [gsr_group_session_id]           INT            NULL,
    [gsr_grs_title]                  VARCHAR (50)   NULL,
    [gsr_category]                   VARCHAR (1003) NULL,
    [gsr_gss_duration]               INT            NULL,
    [gsr_grs_status]                 VARCHAR (500)  NULL,
    [gss_last_updated_date]          DATETIME       NULL,
    [Sys_RunID]                      INT            NULL,
    [Sys_LoadDate]                   DATETIME       NULL,
    [Sys_LoadExpiryDate]             DATETIME       NULL,
    [Sys_IsCurrent]                  BIT            NULL,
    [Sys_BusKey]                     INT            NULL,
    [Sys_HashKey]                    BINARY (16)    NULL
)
WITH (CLUSTERED INDEX([Sys_BusKey]), DISTRIBUTION = HASH([Sys_BusKey]));

