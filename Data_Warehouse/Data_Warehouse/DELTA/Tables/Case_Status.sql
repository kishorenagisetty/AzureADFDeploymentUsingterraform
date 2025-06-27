CREATE TABLE [DELTA].[Case_Status] (
    [CaseStatusID]     INT           NOT NULL,
    [CaseStatusBusKey] INT           NULL,
    [CaseStatus]       VARCHAR (255) NULL,
    [Active]           BIT           NULL,
    [Sys_LoadDate]     DATETIME      NULL,
    [Sys_ModifiedDate] DATETIME      NULL,
    [Sys_RunID]        INT           NULL,
    [Sys_HashKey]      BINARY (16)   NULL
)
WITH (CLUSTERED COLUMNSTORE INDEX, DISTRIBUTION = ROUND_ROBIN);

