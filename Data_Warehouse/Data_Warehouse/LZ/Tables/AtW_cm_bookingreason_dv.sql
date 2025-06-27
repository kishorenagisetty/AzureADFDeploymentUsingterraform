CREATE TABLE [LZ].[AtW_cm_bookingreason_dv] (
    [bookingReasonId] INT          NULL,
    [reason]          VARCHAR (50) NULL,
    [active]          BIT          NULL,
    [Sys_RunID]       INT          NULL,
    [Sys_LoadDate]    DATETIME     NULL
)
WITH (HEAP, DISTRIBUTION = ROUND_ROBIN);

