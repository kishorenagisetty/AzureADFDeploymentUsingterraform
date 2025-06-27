CREATE TABLE [LZ].[AtW_vw_CM_Booking] (
    [bookingId]       INT           NULL,
    [caseId]          INT           NULL,
    [bookingTypeId]   INT           NULL,
    [bookingStatusId] INT           NULL,
    [bookingDateTime] DATETIME      NULL,
    [assignee]        VARCHAR (255) NULL,
    [location]        VARCHAR (11)  NULL,
    [duration]        INT           NULL,
    [bookingReasonId] INT           NULL,
    [note]            VARCHAR (11)  NULL,
    [includeEmployer] BIT           NULL,
    [createdDate]     DATETIME      NULL,
    [createdBy]       VARCHAR (255) NULL,
    [Sys_RunID]       INT           NULL,
    [Sys_LoadDate]    DATETIME      NULL
)
WITH (HEAP, DISTRIBUTION = ROUND_ROBIN);

