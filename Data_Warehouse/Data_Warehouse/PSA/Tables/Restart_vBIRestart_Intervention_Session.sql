CREATE TABLE [PSA].[Restart_vBIRestart_Intervention_Session] (
    [ins_key]                     INT            NOT NULL,
    [intervention_session_id]     INT            NULL,
    [ins_date_time]               DATETIME       NULL,
    [ins_duration]                INT            NULL,
    [ins_advisor_user_id]         INT            NULL,
    [ins_external_advisor]        VARCHAR (250)  NULL,
    [ins_notes]                   VARCHAR (4000) NULL,
    [ins_outcome]                 VARCHAR (500)  NULL,
    [ins_intervention_id]         INT            NULL,
    [ins_site_id]                 INT            NULL,
    [ins_service_session_site_id] INT            NULL,
    [ins_added_date]              DATETIME       NULL,
    [ins_added_by_user_id]        INT            NULL,
    [ins_complete_date]           DATETIME       NULL,
    [ins_complete_by_user_id]     INT            NULL,
    [ins_outcome_type]            VARCHAR (500)  NULL,
    [ins_last_updated_date]       DATETIME       NULL,
    [Sys_RunID]                   INT            NULL,
    [Sys_LoadDate]                DATETIME       NULL,
    [Sys_LoadExpiryDate]          DATETIME       NULL,
    [Sys_IsCurrent]               BIT            NULL,
    [Sys_BusKey]                  INT            NULL,
    [Sys_HashKey]                 BINARY (16)    NULL
)
WITH (CLUSTERED INDEX([Sys_BusKey]), DISTRIBUTION = HASH([Sys_BusKey]));

