CREATE TABLE [PSA].[Restart_vBICommon_Criteria_Definition] (
    [cd_key]                  INT            NOT NULL,
    [criteria_definition_id]  INT            NULL,
    [cd_parent_id]            INT            NULL,
    [cd_type]                 VARCHAR (10)   NULL,
    [cd_project_id]           INT            NULL,
    [cd_title]                VARCHAR (250)  NULL,
    [cd_overview_help_text]   VARCHAR (1500) NULL,
    [cd_completion_help_text] VARCHAR (1500) NULL,
    [cd_operational_guidance] VARCHAR (1500) NULL,
    [cd_item_sequence]        INT            NULL,
    [cd_required_type]        VARCHAR (500)  NULL,
    [cd_override_permission]  VARCHAR (500)  NULL,
    [Sys_RunID]               INT            NULL,
    [Sys_LoadDate]            DATETIME       NULL,
    [Sys_LoadExpiryDate]      DATETIME       NULL,
    [Sys_IsCurrent]           BIT            NULL,
    [Sys_BusKey]              INT            NULL,
    [Sys_HashKey]             BINARY (16)    NULL
)
WITH (CLUSTERED INDEX([Sys_BusKey]), DISTRIBUTION = HASH([Sys_BusKey]));

