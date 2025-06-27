CREATE TABLE [LZ].[AtW_cm_casestatus_dv] (
    [caseStatusId] INT           NULL,
    [status]       VARCHAR (255) NULL,
    [active]       BIT           NULL,
    [Sys_RunID]    INT           NULL,
    [Sys_LoadDate] DATETIME      NULL
)
WITH (HEAP, DISTRIBUTION = ROUND_ROBIN);

