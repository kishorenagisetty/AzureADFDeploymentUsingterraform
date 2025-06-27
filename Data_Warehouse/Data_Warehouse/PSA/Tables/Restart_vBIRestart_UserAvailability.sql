CREATE TABLE [PSA].[Restart_vBIRestart_UserAvailability] (
    [ucs_key]               INT           NOT NULL,
    [user_availability_id]  INT           NULL,
    [ucs_user_id]           INT           NULL,
    [ucs_site_id]           INT           NULL,
    [ucs_type]              VARCHAR (500) NULL,
    [ucs_sub_type]          VARCHAR (500) NULL,
    [ucs_day]               NVARCHAR (30) NULL,
    [ucs_date]              DATE          NULL,
    [ucs_start_time]        TIME (7)      NULL,
    [ucs_end_time]          TIME (7)      NULL,
    [ucs_week_status]       VARCHAR (500) NULL,
    [ucs_added_date]        DATETIME      NULL,
    [ucs_last_updated_date] DATETIME      NULL,
    [Sys_RunID]             INT           NULL,
    [Sys_LoadDate]          DATETIME      NULL,
    [Sys_LoadExpiryDate]    DATETIME      NULL,
    [Sys_IsCurrent]         BIT           NULL,
    [Sys_BusKey]            INT           NULL,
    [Sys_HashKey]           BINARY (16)   NULL
)
WITH (CLUSTERED INDEX([Sys_BusKey]), DISTRIBUTION = HASH([Sys_BusKey]));

