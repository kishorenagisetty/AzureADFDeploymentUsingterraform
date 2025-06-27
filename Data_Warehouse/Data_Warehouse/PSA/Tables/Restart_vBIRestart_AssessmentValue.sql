CREATE TABLE [PSA].[Restart_vBIRestart_AssessmentValue] (
    [av_key]               INT           NOT NULL,
    [assessment_value_id]  INT           NULL,
    [av_assessment_id]     INT           NULL,
    [av_code]              VARCHAR (250) NULL,
    [av_value]             INT           NULL,
    [av_last_updated_date] DATETIME      NULL,
    [Sys_RunID]            INT           NULL,
    [Sys_LoadDate]         DATETIME      NULL,
    [Sys_LoadExpiryDate]   DATETIME      NULL,
    [Sys_IsCurrent]        BIT           NULL,
    [Sys_BusKey]           INT           NULL,
    [Sys_HashKey]          BINARY (16)   NULL
)
WITH (CLUSTERED INDEX([Sys_BusKey]), DISTRIBUTION = HASH([Sys_BusKey]));

