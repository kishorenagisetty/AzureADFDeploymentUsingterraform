CREATE TABLE [PSA].[Restart_vBIRestart_Site] (
    [site_key]                      INT           NOT NULL,
    [site_id]                       INT           NULL,
    [site_name]                     VARCHAR (200) NULL,
    [site_type]                     VARCHAR (500) NULL,
    [site_admin_contact_details_id] INT           NULL,
    [site_agency_id]                INT           NULL,
    [site_parent_site_id]           INT           NULL,
    [site_group]                    VARCHAR (500) NULL,
    [site_added_date]               DATETIME      NULL,
    [site_last_updated_date]        DATETIME      NULL,
    [Sys_RunID]                     INT           NULL,
    [Sys_LoadDate]                  DATETIME      NULL,
    [Sys_LoadExpiryDate]            DATETIME      NULL,
    [Sys_IsCurrent]                 BIT           NULL,
    [Sys_BusKey]                    INT           NULL,
    [Sys_HashKey]                   BINARY (16)   NULL
)
WITH (CLUSTERED INDEX([Sys_BusKey]), DISTRIBUTION = HASH([Sys_BusKey]));

