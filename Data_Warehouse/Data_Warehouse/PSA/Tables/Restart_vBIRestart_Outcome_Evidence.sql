CREATE TABLE [PSA].[Restart_vBIRestart_Outcome_Evidence] (
    [oev_key]                  INT            NOT NULL,
    [outcome_evidence_id]      INT            NULL,
    [oev_date]                 DATE           NULL,
    [oev_type]                 VARCHAR (500)  NULL,
    [oev_advisor_user_id]      INT            NULL,
    [oev_evidence_document_id] INT            NULL,
    [oev_notes]                VARCHAR (4000) NULL,
    [oev_status]               VARCHAR (500)  NULL,
    [oev_rejection_reason]     VARCHAR (4000) NULL,
    [oev_engagement_id]        INT            NULL,
    [oev_added_date]           DATETIME       NULL,
    [oev_added_by_user_id]     INT            NULL,
    [oev_complete_date]        DATETIME       NULL,
    [oev_complete_by_user_id]  INT            NULL,
    [oev_last_updated_date]    DATETIME       NULL,
    [Sys_RunID]                INT            NULL,
    [Sys_LoadDate]             DATETIME       NULL,
    [Sys_LoadExpiryDate]       DATETIME       NULL,
    [Sys_IsCurrent]            BIT            NULL,
    [Sys_BusKey]               INT            NULL,
    [Sys_HashKey]              BINARY (16)    NULL
)
WITH (CLUSTERED INDEX([Sys_BusKey]), DISTRIBUTION = HASH([Sys_BusKey]));

