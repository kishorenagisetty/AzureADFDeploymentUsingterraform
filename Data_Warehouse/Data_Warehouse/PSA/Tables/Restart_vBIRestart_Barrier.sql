CREATE TABLE [PSA].[Restart_vBIRestart_Barrier] (
    [eb_key]                INT            NOT NULL,
    [engagement_barrier_id] INT            NULL,
    [eb_engagement_id]      INT            NULL,
    [eb_barrier]            VARCHAR (500)  NULL,
    [eb_value]              INT            NULL,
    [eb_status]             INT            NULL,
    [eb_notes]              VARCHAR (4000) NULL,
    [eb_added_date]         DATETIME       NULL,
    [eb_last_updated_date]  DATETIME       NULL,
    [Sys_RunID]             INT            NULL,
    [Sys_LoadDate]          DATETIME       NULL,
    [Sys_LoadExpiryDate]    DATETIME       NULL,
    [Sys_IsCurrent]         BIT            NULL,
    [Sys_BusKey]            INT            NULL,
    [Sys_HashKey]           BINARY (16)    NULL
)
WITH (CLUSTERED INDEX([Sys_BusKey]), DISTRIBUTION = HASH([Sys_BusKey]));

