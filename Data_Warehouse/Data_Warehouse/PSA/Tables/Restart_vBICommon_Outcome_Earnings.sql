CREATE TABLE [PSA].[Restart_vBICommon_Outcome_Earnings] (
    [outcome_earnings_key]        INT            NOT NULL,
    [outcome_earnings_id]         INT            NULL,
    [out_earn_entity_id]          INT            NULL,
    [out_earn_salary_amount]      MONEY          NULL,
    [out_earn_salary_unit]        VARCHAR (500)  NULL,
    [out_earn_hours_per_week]     REAL           NULL,
    [out_earn_date_from]          DATE           NULL,
    [out_earn_date_to]            DATE           NULL,
    [out_earn_notes]              VARCHAR (4000) NULL,
    [out_earn_updated_by_user_id] INT            NULL,
    [out_earn_updated_date]       DATETIME       NULL,
    [Sys_RunID]                   INT            NULL,
    [Sys_LoadDate]                DATETIME       NULL,
    [Sys_LoadExpiryDate]          DATETIME       NULL,
    [Sys_IsCurrent]               BIT            NULL,
    [Sys_BusKey]                  INT            NULL,
    [Sys_HashKey]                 BINARY (16)    NULL
)
WITH (CLUSTERED INDEX([Sys_BusKey]), DISTRIBUTION = HASH([Sys_BusKey]));

