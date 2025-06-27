CREATE TABLE [PSA].[Restart_vBICommon_InterventionRelatedBarrier] (
    [rb_key]                          INT           NOT NULL,
    [intervention_related_barrier_id] INT           NULL,
    [rb_entity_id]                    INT           NULL,
    [rb_entity_type]                  VARCHAR (500) NULL,
    [rb_barrier_id]                   VARCHAR (250) NULL,
    [Sys_RunID]                       INT           NULL,
    [Sys_LoadDate]                    DATETIME      NULL,
    [Sys_LoadExpiryDate]              DATETIME      NULL,
    [Sys_IsCurrent]                   BIT           NULL,
    [Sys_BusKey]                      INT           NULL,
    [Sys_HashKey]                     BINARY (16)   NULL
)
WITH (CLUSTERED INDEX([Sys_BusKey]), DISTRIBUTION = HASH([Sys_BusKey]));

