CREATE TABLE [LZ].[AtW_vw_cm_sla] (
    [slaId]             INT            NULL,
    [caseId]            INT            NULL,
    [slaTypeId]         INT            NULL,
    [userId]            VARCHAR (255)  NULL,
    [endDateTime]       DATETIME       NULL,
    [deadlineDateTime]  DATETIME       NULL,
    [missedSLAReasonId] INT            NULL,
    [missedComments]    VARCHAR (1000) NULL,
    [Sys_RunID]         INT            NULL,
    [Sys_LoadDate]      DATETIME       NULL
)
WITH (HEAP, DISTRIBUTION = ROUND_ROBIN);

