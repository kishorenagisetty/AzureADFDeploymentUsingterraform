CREATE TABLE [LZ].[AtW_cm_servicesource_dv] (
    [caseServiceSourceId] INT           NULL,
    [source]              VARCHAR (255) NULL,
    [active]              BIT           NULL,
    [Sys_RunID]           INT           NULL,
    [Sys_LoadDate]        DATETIME      NULL
)
WITH (CLUSTERED COLUMNSTORE INDEX, DISTRIBUTION = ROUND_ROBIN);

