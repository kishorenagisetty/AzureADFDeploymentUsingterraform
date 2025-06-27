CREATE TABLE [LZ].[AtW_vw_cm_logtask_history] (
    [historyId]     INT           NULL,
    [logTaskId]     INT           NULL,
    [statusId]      INT           NULL,
    [description]   VARCHAR (11)  NULL,
    [duration]      INT           NULL,
    [documentNames] VARCHAR (11)  NULL,
    [deadline]      DATETIME      NULL,
    [createdDate]   DATETIME      NULL,
    [createdBy]     VARCHAR (255) NULL,
    [Sys_RunID]     INT           NULL,
    [Sys_LoadDate]  DATETIME      NULL
)
WITH (HEAP, DISTRIBUTION = ROUND_ROBIN);

