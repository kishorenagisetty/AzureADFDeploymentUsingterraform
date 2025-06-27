CREATE TABLE [LZ].[AtW_vw_cm_logtask] (
    [logTaskId]         INT           NULL,
    [caseId]            INT           NULL,
    [typeId]            INT           NULL,
    [statusId]          INT           NULL,
    [assignee]          VARCHAR (255) NULL,
    [assigneeType]      VARCHAR (255) NULL,
    [description]       VARCHAR (11)  NULL,
    [documentsUploaded] INT           NULL,
    [deadline]          DATETIME      NULL,
    [createdDate]       DATETIME      NULL,
    [createdBy]         VARCHAR (255) NULL,
    [Sys_RunID]         INT           NULL,
    [Sys_LoadDate]      DATETIME      NULL
)
WITH (HEAP, DISTRIBUTION = ROUND_ROBIN);

