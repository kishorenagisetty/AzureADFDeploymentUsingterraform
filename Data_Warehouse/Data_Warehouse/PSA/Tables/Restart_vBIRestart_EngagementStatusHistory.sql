CREATE TABLE [PSA].[Restart_vBIRestart_EngagementStatusHistory] (
    [engagement_status_hist_key]   INT           NOT NULL,
    [engagement_status_history_id] INT           NULL,
    [esh_engagement_id]            INT           NULL,
    [esh_value_before]             VARCHAR (500) NULL,
    [esh_value_after]              VARCHAR (500) NULL,
    [esh_reason]                   VARCHAR (500) NULL,
    [esh_reason_other]             VARCHAR (250) NULL,
    [esh_change_by_user_id]        INT           NULL,
    [esh_change_date]              DATETIME      NULL,
    [esh_last_updated_date]        DATETIME      NULL,
    [Sys_RunID]                    INT           NULL,
    [Sys_LoadDate]                 DATETIME      NULL,
    [Sys_LoadExpiryDate]           DATETIME      NULL,
    [Sys_IsCurrent]                BIT           NULL,
    [Sys_BusKey]                   INT           NULL,
    [Sys_HashKey]                  BINARY (16)   NULL
)
WITH (CLUSTERED INDEX([Sys_BusKey]), DISTRIBUTION = HASH([Sys_BusKey]));

