CREATE TABLE [PSA].[Restart_vBICommon_EarningsNotification] (
    [ern_key]                      INT           NOT NULL,
    [earnings_notification_id]     INT           NULL,
    [ern_engagement_id]            INT           NULL,
    [ern_notification_type]        VARCHAR (250) NULL,
    [ern_date_created]             DATETIME      NULL,
    [ern_notification_date]        DATETIME      NULL,
    [ern_nino]                     VARCHAR (50)  NULL,
    [ern_prap_po_number]           VARCHAR (50)  NULL,
    [ern_asn_creation_status]      VARCHAR (250) NULL,
    [ern_asn_number]               VARCHAR (250) NULL,
    [ern_invoice_number]           VARCHAR (250) NULL,
    [ern_acknowledgement_required] BIT           NULL,
    [ern_added_by_user_id]         INT           NULL,
    [ern_added_date]               DATETIME      NULL,
    [ern_proj_id]                  INT           NULL,
    [ern_last_updated_date]        DATETIME      NULL,
    [Sys_RunID]                    INT           NULL,
    [Sys_LoadDate]                 DATETIME      NULL,
    [Sys_LoadExpiryDate]           DATETIME      NULL,
    [Sys_IsCurrent]                BIT           NULL,
    [Sys_BusKey]                   INT           NULL,
    [Sys_HashKey]                  BINARY (16)   NULL
)
WITH (CLUSTERED INDEX([Sys_BusKey]), DISTRIBUTION = HASH([Sys_BusKey]));

