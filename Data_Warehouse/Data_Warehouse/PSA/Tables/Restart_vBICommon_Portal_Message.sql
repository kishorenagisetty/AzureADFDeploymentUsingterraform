CREATE TABLE [PSA].[Restart_vBICommon_Portal_Message] (
    [pom_related_ind_key]       INT             NOT NULL,
    [portal_message_id]         INT             NULL,
    [pom_related_engagement_id] INT             NULL,
    [pom_related_individual_id] INT             NULL,
    [pom_content]               NVARCHAR (4000) NULL,
    [pom_recorded_by]           VARCHAR (500)   NULL,
    [pom_read_receipt]          BIT             NULL,
    [pom_sent_by_user_id]       INT             NULL,
    [pom_sent_date]             DATETIME        NULL,
    [Sys_RunID]                 INT             NULL,
    [Sys_LoadDate]              DATETIME        NULL,
    [Sys_LoadExpiryDate]        DATETIME        NULL,
    [Sys_IsCurrent]             BIT             NULL,
    [Sys_BusKey]                INT             NULL,
    [Sys_HashKey]               BINARY (16)     NULL
)
WITH (CLUSTERED INDEX([Sys_BusKey]), DISTRIBUTION = HASH([Sys_BusKey]));

