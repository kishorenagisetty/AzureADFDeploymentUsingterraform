CREATE TABLE [LZ].[AtW_cm_slamissedreason_dv] (
    [missedReasonId] INT           NULL,
    [missedReason]   VARCHAR (255) NULL,
    [isActive]       BIT           NULL,
    [Sys_RunID]      INT           NULL,
    [Sys_LoadDate]   DATETIME      NULL
)
WITH (HEAP, DISTRIBUTION = ROUND_ROBIN);

