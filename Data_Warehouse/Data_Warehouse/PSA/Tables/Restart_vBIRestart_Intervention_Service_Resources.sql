CREATE TABLE [PSA].[Restart_vBIRestart_Intervention_Service_Resources] (
    [iscr_key]                         INT           NOT NULL,
    [intervention_service_resource_id] INT           NULL,
    [iscr_intervention_service_id]     INT           NULL,
    [iscr_resource_id]                 VARCHAR (50)  NULL,
    [iscr_added]                       DATETIME      NULL,
    [iscr_resource_title]              VARCHAR (250) NULL,
    [iscr_status]                      VARCHAR (500) NULL,
    [Sys_RunID]                        INT           NULL,
    [Sys_LoadDate]                     DATETIME      NULL,
    [Sys_LoadExpiryDate]               DATETIME      NULL,
    [Sys_IsCurrent]                    BIT           NULL,
    [Sys_BusKey]                       INT           NULL,
    [Sys_HashKey]                      BINARY (16)   NULL
)
WITH (CLUSTERED INDEX([Sys_BusKey]), DISTRIBUTION = HASH([Sys_BusKey]));

