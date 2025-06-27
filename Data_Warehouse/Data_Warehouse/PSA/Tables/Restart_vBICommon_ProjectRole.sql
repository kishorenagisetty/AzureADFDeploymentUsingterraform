CREATE TABLE [PSA].[Restart_vBICommon_ProjectRole] (
    [user_key]           INT           NOT NULL,
    [user_id]            INT           NULL,
    [Project]            VARCHAR (100) NULL,
    [Role]               VARCHAR (50)  NULL,
    [Sys_RunID]          INT           NULL,
    [Sys_LoadDate]       DATETIME      NULL,
    [Sys_LoadExpiryDate] DATETIME      NULL,
    [Sys_IsCurrent]      BIT           NULL,
    [Sys_BusKey]         INT           NULL,
    [Sys_HashKey]        BINARY (16)   NULL
)
WITH (CLUSTERED INDEX([Sys_BusKey]), DISTRIBUTION = HASH([Sys_BusKey]));

