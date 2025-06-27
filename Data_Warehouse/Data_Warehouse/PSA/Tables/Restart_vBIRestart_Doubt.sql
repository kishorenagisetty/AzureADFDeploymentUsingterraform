CREATE TABLE [PSA].[Restart_vBIRestart_Doubt] (
    [doubt_key]                    INT             NOT NULL,
    [doubt_id]                     INT             NULL,
    [doubt_raised_by_user_id]      INT             NULL,
    [doubt_raised_by_display]      VARCHAR (101)   NULL,
    [doubt_raised_by_other]        VARCHAR (500)   NULL,
    [doubt_tran_date]              DATETIME        NULL,
    [doubt_tran_status_1]          VARCHAR (500)   NULL,
    [doubt_tran_added_by_user_id]  INT             NULL,
    [doubt_tran_added_by_display]  VARCHAR (101)   NULL,
    [doubt_tran_added_date]        DATETIME        NULL,
    [doubt_tran_engagement_id]     INT             NULL,
    [doubt_tran_individual_id]     INT             NULL,
    [doubt_tran_notes]             NVARCHAR (4000) NULL,
    [doubt_tran_last_updated_date] DATETIME        NULL,
    [Sys_RunID]                    INT             NULL,
    [Sys_LoadDate]                 DATETIME        NULL,
    [Sys_LoadExpiryDate]           DATETIME        NULL,
    [Sys_IsCurrent]                BIT             NULL,
    [Sys_BusKey]                   INT             NULL,
    [Sys_HashKey]                  BINARY (16)     NULL
)
WITH (CLUSTERED INDEX([Sys_BusKey]), DISTRIBUTION = HASH([Sys_BusKey]));

