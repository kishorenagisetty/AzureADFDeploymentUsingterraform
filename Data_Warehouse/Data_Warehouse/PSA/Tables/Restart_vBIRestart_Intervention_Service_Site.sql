CREATE TABLE [PSA].[Restart_vBIRestart_Intervention_Service_Site] (
    [iscs_key]                     INT          NOT NULL,
    [intervention_service_site_id] INT          NULL,
    [iscs_intervention_service_id] INT          NULL,
    [iscs_site_id]                 VARCHAR (50) NULL,
    [Sys_RunID]                    INT          NULL,
    [Sys_LoadDate]                 DATETIME     NULL,
    [Sys_LoadExpiryDate]           DATETIME     NULL,
    [Sys_IsCurrent]                BIT          NULL,
    [Sys_BusKey]                   INT          NULL,
    [Sys_HashKey]                  BINARY (16)  NULL
)
WITH (CLUSTERED INDEX([Sys_BusKey]), DISTRIBUTION = HASH([Sys_BusKey]));

