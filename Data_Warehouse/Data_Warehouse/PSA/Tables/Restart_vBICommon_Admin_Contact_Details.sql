CREATE TABLE [PSA].[Restart_vBICommon_Admin_Contact_Details] (
    [admin_contact_details_key] INT           NOT NULL,
    [admin_contact_details_id]  INT           NULL,
    [acd_entity_id]             INT           NULL,
    [acd_type]                  VARCHAR (8)   NULL,
    [acd_address_1]             VARCHAR (100) NULL,
    [acd_address_2]             VARCHAR (100) NULL,
    [acd_address_3]             VARCHAR (100) NULL,
    [acd_town]                  VARCHAR (100) NULL,
    [acd_postcode]              VARCHAR (8)   NULL,
    [acd_tel_no]                VARCHAR (20)  NULL,
    [acd_mob_no]                VARCHAR (20)  NULL,
    [acd_fax_no]                VARCHAR (20)  NULL,
    [acd_email]                 VARCHAR (250) NULL,
    [acd_web_address]           VARCHAR (250) NULL,
    [acd_added_by_user_id]      INT           NULL,
    [acd_added_date]            DATETIME      NULL,
    [acd_archive]               BIT           NULL,
    [Sys_RunID]                 INT           NULL,
    [Sys_LoadDate]              DATETIME      NULL,
    [Sys_LoadExpiryDate]        DATETIME      NULL,
    [Sys_IsCurrent]             BIT           NULL,
    [Sys_BusKey]                INT           NULL,
    [Sys_HashKey]               BINARY (16)   NULL
)
WITH (CLUSTERED INDEX([Sys_BusKey]), DISTRIBUTION = HASH([Sys_BusKey]));

