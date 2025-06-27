CREATE TABLE [PSA].[Restart_vBIRestart_GroupSessionSession] (
    [group_session_session_key]    INT            NOT NULL,
    [group_session_session_id]     INT            NULL,
    [gss_title]                    VARCHAR (4000) NULL,
    [gss_date_display]             NVARCHAR (12)  NULL,
    [gss_time_display]             VARCHAR (5)    NULL,
    [gss_duration]                 INT            NULL,
    [gss_trainer_fullname]         VARCHAR (101)  NULL,
    [gss_delivery_method_display]  VARCHAR (500)  NULL,
    [gss_location]                 VARCHAR (4000) NULL,
    [gss_details]                  VARCHAR (4000) NULL,
    [gss_non_registered_attendees] INT            NULL,
    [gss_attendance_notes]         VARCHAR (4000) NULL,
    [gss_added_by_user_id]         INT            NULL,
    [gss_added_by_fullname]        VARCHAR (101)  NULL,
    [gss_added_date_display]       NVARCHAR (12)  NULL,
    [gss_last_updated_date]        DATETIME       NULL,
    [Sys_RunID]                    INT            NULL,
    [Sys_LoadDate]                 DATETIME       NULL,
    [Sys_LoadExpiryDate]           DATETIME       NULL,
    [Sys_IsCurrent]                BIT            NULL,
    [Sys_BusKey]                   INT            NULL,
    [Sys_HashKey]                  BINARY (16)    NULL
)
WITH (CLUSTERED INDEX([Sys_BusKey]), DISTRIBUTION = HASH([Sys_BusKey]));

