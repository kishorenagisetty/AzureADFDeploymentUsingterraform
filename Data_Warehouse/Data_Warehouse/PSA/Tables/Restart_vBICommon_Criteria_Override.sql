CREATE TABLE [PSA].[Restart_vBICommon_Criteria_Override] (
    [co_key]                    INT            NOT NULL,
    [criteria_override_id]      INT            NULL,
    [co_criteria_definition_id] INT            NULL,
    [co_entity_id]              INT            NULL,
    [co_entity_type]            VARCHAR (500)  NULL,
    [co_reason]                 VARCHAR (4000) NULL,
    [co_added_by_user_id]       INT            NULL,
    [co_active_to_date]         DATE           NULL,
    [co_added_date]             DATETIME       NULL,
    [Sys_RunID]                 INT            NULL,
    [Sys_LoadDate]              DATETIME       NULL,
    [Sys_LoadExpiryDate]        DATETIME       NULL,
    [Sys_IsCurrent]             BIT            NULL,
    [Sys_BusKey]                INT            NULL,
    [Sys_HashKey]               BINARY (16)    NULL
)
WITH (CLUSTERED INDEX([Sys_BusKey]), DISTRIBUTION = HASH([Sys_BusKey]));

