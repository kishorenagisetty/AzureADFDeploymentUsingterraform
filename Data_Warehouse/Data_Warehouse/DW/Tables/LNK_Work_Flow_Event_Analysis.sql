CREATE TABLE [DW].[LNK_Work_Flow_Event_Analysis] (
    [Work_Flow_Events_Skey]             INT      NOT NULL,
    [Case_Analysis_Skey]                INT      NULL,
    [WorkFlowStages_Skey]               INT      NULL,
    [WorkFlowEventType_Skey]            INT      NULL,
    [WorkFlowEventDate_Skey]            INT      NULL,
    [WorkFlowEventTime_Skey]            INT      NULL,
    [WorkFlowEstimatedStartDate_Skey]   INT      NULL,
    [WorkFlowEstimatedStartTime_Skey]   INT      NULL,
    [WorkFlowEstimatedEndDate_Skey]     INT      NULL,
    [WorkFlowEstimatedEndTime_Skey]     INT      NULL,
    [WorkFlowOriginalStartDate_Skey]    INT      NULL,
    [WorkFlowOriginalStartTime_Skey]    INT      NULL,
    [WorkFlowEndDate_Skey]              INT      NULL,
    [WorkFlowEndTime_Skey]              INT      NULL,
    [WorkFlowEventEmployee_Skey]        INT      NULL,
    [WorkFlowEventEmployeeHistory_Skey] INT      NULL,
    [StageOrder]                        INT      NULL,
    [EventCount]                        INT      NOT NULL,
    [EventOutstandingCount]             INT      NOT NULL,
    [EventCompletedCount]               INT      NOT NULL,
    [EventOverDueCount]                 INT      NOT NULL,
    [EventCompletedWithinSLACount]      INT      NOT NULL,
    [EventCompletedOutsideSLACount]     INT      NOT NULL,
    [EventSkippedCount]                 INT      NULL,
    [Sys_LoadDate]                      DATETIME NULL,
    [Sys_ModifiedDate]                  DATETIME NULL,
    [Sys_RunID]                         INT      NULL
)
WITH (CLUSTERED COLUMNSTORE INDEX, DISTRIBUTION = HASH([Case_Analysis_Skey]));





