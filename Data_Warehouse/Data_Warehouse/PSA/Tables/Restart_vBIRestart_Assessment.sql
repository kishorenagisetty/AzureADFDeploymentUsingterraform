CREATE TABLE [PSA].[Restart_vBIRestart_Assessment] (
    [ass_key]                 INT             NOT NULL,
    [assessment_id]           INT             NULL,
    [ass_advisor_user_id]     INT             NULL,
    [ass_date_time]           DATETIME        NULL,
    [ass_score]               VARCHAR (50)    NULL,
    [ass_type]                VARCHAR (500)   NULL,
    [ass_sub_type]            VARCHAR (500)   NULL,
    [ass_stage]               VARCHAR (500)   NULL,
    [ass_provider_agency_id]  INT             NULL,
    [ass_site_id]             INT             NULL,
    [ass_notes]               NVARCHAR (4000) NULL,
    [ass_engagement_id]       INT             NULL,
    [ass_added_date]          DATETIME        NULL,
    [ass_added_by_user_id]    INT             NULL,
    [ass_complete_date]       DATETIME        NULL,
    [ass_complete_by_user_id] INT             NULL,
    [ass_last_updated_date]   DATETIME        NULL,
    [Sys_RunID]               INT             NULL,
    [Sys_LoadDate]            DATETIME        NULL,
    [Sys_LoadExpiryDate]      DATETIME        NULL,
    [Sys_IsCurrent]           BIT             NULL,
    [Sys_BusKey]              INT             NULL,
    [Sys_HashKey]             BINARY (16)     NULL
)
WITH (CLUSTERED INDEX([Sys_BusKey]), DISTRIBUTION = HASH([Sys_BusKey]));

