CREATE TABLE [PSA].[Restart_vBIRestart_Message] (
    [msg_key]                INT            NOT NULL,
    [message_id]             INT            NULL,
    [msg_destination]        VARCHAR (8000) NULL,
    [msg_from]               VARCHAR (500)  NULL,
    [msg_communication_type] VARCHAR (500)  NULL,
    [msg_type]               VARCHAR (500)  NULL,
    [msg_subject]            VARCHAR (500)  NULL,
    [msg_related_entity_id]  INT            NULL,
    [msg_content]            NVARCHAR (MAX) NULL,
    [msg_delivery_status]    VARCHAR (500)  NULL,
    [msg_sent_date]          DATETIME       NULL,
    [msg_added_by_user_id]   INT            NULL,
    [msg_added_by_display]   VARCHAR (101)  NULL,
    [msg_added_date]         DATETIME       NULL,
    [msg_last_updated_date]  DATETIME       NULL,
    [Sys_RunID]              INT            NULL,
    [Sys_LoadDate]           DATETIME       NULL,
    [Sys_LoadExpiryDate]     DATETIME       NULL,
    [Sys_IsCurrent]          BIT            NULL,
    [Sys_BusKey]             INT            NULL,
    [Sys_HashKey]            BINARY (16)    NULL
)
WITH (CLUSTERED INDEX([Sys_BusKey]), DISTRIBUTION = HASH([Sys_BusKey]));

