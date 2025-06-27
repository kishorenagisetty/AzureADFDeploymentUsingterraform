CREATE TABLE [PSA].[Restart_vBIRestart_EngagementResource] (
    [engagement_resource_key] INT           NOT NULL,
    [engagement_resource_id]  INT           NULL,
    [er_engagement_id]        INT           NULL,
    [er_res_title]            VARCHAR (250) NULL,
    [er_res_type]             VARCHAR (500) NULL,
    [er_share_status]         VARCHAR (500) NULL,
    [er_res_description]      VARCHAR (500) NULL,
    [er_added_date]           DATETIME      NULL,
    [er_res_proj_id]          INT           NULL,
    [er_last_updated_date]    DATETIME      NULL,
    [Sys_RunID]               INT           NULL,
    [Sys_LoadDate]            DATETIME      NULL,
    [Sys_LoadExpiryDate]      DATETIME      NULL,
    [Sys_IsCurrent]           BIT           NULL,
    [Sys_BusKey]              INT           NULL,
    [Sys_HashKey]             BINARY (16)   NULL
)
WITH (CLUSTERED INDEX([Sys_BusKey]), DISTRIBUTION = HASH([Sys_BusKey]));

