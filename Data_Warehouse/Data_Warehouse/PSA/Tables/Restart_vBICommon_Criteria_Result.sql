CREATE TABLE [PSA].[Restart_vBICommon_Criteria_Result] (
    [cr_key]                    INT           NOT NULL,
    [criteria_result_id]        INT           NULL,
    [cr_criteria_definition_id] INT           NULL,
    [cr_entity_id]              INT           NULL,
    [cr_added_date]             DATETIME      NULL,
    [cr_entity_type]            VARCHAR (500) NULL,
    [cr_type]                   VARCHAR (3)   NULL,
    [cr_status]                 VARCHAR (500) NULL,
    [Sys_RunID]                 INT           NULL,
    [Sys_LoadDate]              DATETIME      NULL,
    [Sys_LoadExpiryDate]        DATETIME      NULL,
    [Sys_IsCurrent]             BIT           NULL,
    [Sys_BusKey]                INT           NULL,
    [Sys_HashKey]               BINARY (16)   NULL
)
WITH (CLUSTERED INDEX([Sys_BusKey]), DISTRIBUTION = HASH([Sys_BusKey]));

