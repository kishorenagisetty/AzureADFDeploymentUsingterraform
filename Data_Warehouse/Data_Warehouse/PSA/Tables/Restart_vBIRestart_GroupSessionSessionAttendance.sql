CREATE TABLE [PSA].[Restart_vBIRestart_GroupSessionSessionAttendance] (
    [group_session_session_attendance_key] INT            NOT NULL,
    [group_session_session_attendance_id]  INT            NULL,
    [gsa_group_session_session_id]         INT            NULL,
    [gsa_group_session_registration_id]    INT            NULL,
    [gsa_session_title]                    VARCHAR (4000) NULL,
    [gsa_outcome]                          VARCHAR (500)  NULL,
    [gsa_trainer_notes]                    VARCHAR (4000) NULL,
    [gsa_gss_date]                         DATETIME       NULL,
    [gsa_gss_attendance_notes]             VARCHAR (4000) NULL,
    [Sys_RunID]                            INT            NULL,
    [Sys_LoadDate]                         DATETIME       NULL,
    [Sys_LoadExpiryDate]                   DATETIME       NULL,
    [Sys_IsCurrent]                        BIT            NULL,
    [Sys_BusKey]                           INT            NULL,
    [Sys_HashKey]                          BINARY (16)    NULL
)
WITH (CLUSTERED INDEX([Sys_BusKey]), DISTRIBUTION = HASH([Sys_BusKey]));

