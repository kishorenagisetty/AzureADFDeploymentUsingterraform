CREATE TABLE [LZ].[AtW_cm_caseservicesource_dv] (
    [caseServiceSourceId] INT           NULL,
    [source]              VARCHAR (255) NULL,
    [active]              BIT           NULL,
    [Sys_RunID]           INT           NULL,
    [Sys_LoadDate]        DATETIME      NULL
)
WITH (HEAP, DISTRIBUTION = ROUND_ROBIN);

