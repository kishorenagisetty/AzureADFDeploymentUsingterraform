CREATE TABLE [LZ].[AtW_cm_bookingstatus_dv] (
    [bookingStatusId] INT          NULL,
    [status]          VARCHAR (50) NULL,
    [active]          BIT          NULL,
    [Sys_RunID]       INT          NULL,
    [Sys_LoadDate]    DATETIME     NULL
)
WITH (HEAP, DISTRIBUTION = ROUND_ROBIN);

