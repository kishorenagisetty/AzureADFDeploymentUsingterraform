CREATE TABLE [PSA].[Restart_vBICommon_Agency] (
    [agency_key]                      INT            NOT NULL,
    [agency_id]                       INT            NULL,
    [agency_admin_contact_details_id] INT            NULL,
    [agency_name]                     VARCHAR (100)  NULL,
    [agency_short_name]               VARCHAR (50)   NULL,
    [agency_provide_service]          BIT            NULL,
    [agency_added_date]               DATETIME       NULL,
    [agency_notes]                    VARCHAR (4000) NULL,
    [agency_type]                     VARCHAR (500)  NULL,
    [agency_last_updated_date]        DATETIME       NULL,
    [Sys_RunID]                       INT            NULL,
    [Sys_LoadDate]                    DATETIME       NULL,
    [Sys_LoadExpiryDate]              DATETIME       NULL,
    [Sys_IsCurrent]                   BIT            NULL,
    [Sys_BusKey]                      INT            NULL,
    [Sys_HashKey]                     BINARY (16)    NULL
)
WITH (CLUSTERED INDEX([Sys_BusKey]), DISTRIBUTION = HASH([Sys_BusKey]));

