CREATE TABLE [PSA].[Restart_vBIRestart_DoubtRelatedActivity] (
    [doubt_related_activity_key] INT           NOT NULL,
    [doubt_related_activity_id]  INT           NULL,
    [dra_entity_type]            VARCHAR (500) NULL,
    [dra_entity_id]              INT           NULL,
    [dra_doubt_id]               INT           NULL,
    [dra_tran_last_updated_date] DATETIME      NULL,
    [Sys_RunID]                  INT           NULL,
    [Sys_LoadDate]               DATETIME      NULL,
    [Sys_LoadExpiryDate]         DATETIME      NULL,
    [Sys_IsCurrent]              BIT           NULL,
    [Sys_BusKey]                 INT           NULL,
    [Sys_HashKey]                BINARY (16)   NULL
)
WITH (CLUSTERED INDEX([Sys_BusKey]), DISTRIBUTION = HASH([Sys_BusKey]));

