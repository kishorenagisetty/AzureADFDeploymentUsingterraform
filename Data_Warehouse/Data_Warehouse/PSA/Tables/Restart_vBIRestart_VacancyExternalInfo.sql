CREATE TABLE [PSA].[Restart_vBIRestart_VacancyExternalInfo] (
    [vei_key]                  INT            NOT NULL,
    [vacancy_external_info_id] INT            NULL,
    [vei_external_id]          BIGINT         NULL,
    [vei_title]                VARCHAR (200)  NULL,
    [vei_description]          VARCHAR (1000) NULL,
    [vei_company]              VARCHAR (200)  NULL,
    [vei_location]             VARCHAR (200)  NULL,
    [vei_salary_min]           NVARCHAR (20)  NULL,
    [vei_salary_max]           NVARCHAR (20)  NULL,
    [vei_salary_predicted]     NVARCHAR (5)   NULL,
    [vei_contract_type]        VARCHAR (20)   NULL,
    [vei_contract_time]        VARCHAR (20)   NULL,
    [vei_redirect_url]         VARCHAR (400)  NULL,
    [vei_category]             VARCHAR (200)  NULL,
    [vei_created_date]         NVARCHAR (12)  NULL,
    [Sys_RunID]                INT            NULL,
    [Sys_LoadDate]             DATETIME       NULL,
    [Sys_LoadExpiryDate]       DATETIME       NULL,
    [Sys_IsCurrent]            BIT            NULL,
    [Sys_BusKey]               INT            NULL,
    [Sys_HashKey]              BINARY (16)    NULL
)
WITH (CLUSTERED INDEX([Sys_BusKey]), DISTRIBUTION = HASH([Sys_BusKey]));



