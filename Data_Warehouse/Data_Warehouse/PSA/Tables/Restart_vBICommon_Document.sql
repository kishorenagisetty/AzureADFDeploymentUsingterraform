CREATE TABLE [PSA].[Restart_vBICommon_Document] (
    [document_key]        INT            NOT NULL,
    [document_id]         INT            NULL,
    [rf_filename]         VARCHAR (500)  NULL,
    [rf_version]          INT            NULL,
    [rf_entity_id]        INT            NULL,
    [rf_entity_type]      VARCHAR (10)   NULL,
    [rf_type]             VARCHAR (200)  NULL,
    [rf_notes]            NVARCHAR (100) NULL,
    [rf_added_date]       DATETIME       NULL,
    [rf_added_by_user_id] INT            NULL,
    [Sys_RunID]           INT            NULL,
    [Sys_LoadDate]        DATETIME       NULL,
    [Sys_LoadExpiryDate]  DATETIME       NULL,
    [Sys_IsCurrent]       BIT            NULL,
    [Sys_BusKey]          INT            NULL,
    [Sys_HashKey]         BINARY (16)    NULL
)
WITH (CLUSTERED INDEX([Sys_BusKey]), DISTRIBUTION = HASH([Sys_BusKey]));

