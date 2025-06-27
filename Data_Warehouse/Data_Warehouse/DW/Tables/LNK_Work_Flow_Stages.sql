CREATE TABLE [DW].[LNK_Work_Flow_Stages] (
    [Work_Flow_Stages_Skey]  INT      NOT NULL,
    [Case_Analysis_Skey]     INT      NULL,
    [Stage_Skey]             INT      NULL,
    [WorkFlowStartDate_Skey] INT      NULL,
    [WorkFlowStartTime_Skey] INT      NULL,
    [WorkFlowEndDate_Skey]   INT      NULL,
    [WorkFlowEndTime_Skey]   INT      NULL,
    [StageOrder]             INT      NULL,
    [Sys_LoadDate]           DATETIME NULL,
    [Sys_ModifiedDate]       DATETIME NULL,
    [Sys_RunID]              INT      NULL
)
WITH (CLUSTERED COLUMNSTORE INDEX, DISTRIBUTION = HASH([Case_Analysis_Skey]));

