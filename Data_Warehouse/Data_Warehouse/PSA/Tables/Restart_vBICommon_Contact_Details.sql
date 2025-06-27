CREATE TABLE [PSA].[Restart_vBICommon_Contact_Details] (
    [contact_details_key] INT           NOT NULL,
    [contact_details_id]  INT           NULL,
    [cd_entity_id]        INT           NULL,
    [cd_type]             VARCHAR (12)  NULL,
    [cd_address_1]        VARCHAR (100) NULL,
    [cd_address_2]        VARCHAR (100) NULL,
    [cd_address_3]        VARCHAR (100) NULL,
    [cd_town]             VARCHAR (100) NULL,
    [cd_postcode]         VARCHAR (8)   NULL,
    [cd_county]           VARCHAR (250) NULL,
    [cd_tel_no]           VARCHAR (20)  NULL,
    [cd_mob_no]           VARCHAR (20)  NULL,
    [cd_fax_no]           VARCHAR (20)  NULL,
    [cd_email]            VARCHAR (250) NULL,
    [cd_web_address]      VARCHAR (250) NULL,
    [cd_added_by_user_id] INT           NULL,
    [cd_added_date]       DATETIME      NULL,
    [cd_archive]          BIT           NULL,
    [Sys_RunID]           INT           NULL,
    [Sys_LoadDate]        DATETIME      NULL,
    [Sys_LoadExpiryDate]  DATETIME      NULL,
    [Sys_IsCurrent]       BIT           NULL,
    [Sys_BusKey]          INT           NULL,
    [Sys_HashKey]         BINARY (16)   NULL
)
WITH (CLUSTERED INDEX([Sys_BusKey]), DISTRIBUTION = HASH([Sys_BusKey]));

