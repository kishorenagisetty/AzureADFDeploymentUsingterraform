CREATE TABLE [PSA].[Restart_vBIRestart_Resource] (
    [res_key]               INT            NOT NULL,
    [resource_id]           INT            NULL,
    [res_status]            VARCHAR (500)  NULL,
    [res_title]             VARCHAR (250)  NULL,
    [res_description]       VARCHAR (500)  NULL,
    [res_type]              VARCHAR (500)  NULL,
    [res_file]              INT            NULL,
    [res_review_date]       DATETIME       NULL,
    [res_categories]        NVARCHAR (MAX) NULL,
    [res_publish_location]  NVARCHAR (MAX) NULL,
    [res_added_by_user_id]  INT            NULL,
    [res_added_date]        DATETIME       NULL,
    [res_last_updated_date] DATETIME       NULL,
    [Sys_RunID]             INT            NULL,
    [Sys_LoadDate]          DATETIME       NULL,
    [Sys_LoadExpiryDate]    DATETIME       NULL,
    [Sys_IsCurrent]         BIT            NULL,
    [Sys_BusKey]            INT            NULL,
    [Sys_HashKey]           BINARY (16)    NULL
)
WITH (CLUSTERED INDEX([Sys_BusKey]), DISTRIBUTION = HASH([Sys_BusKey]));

