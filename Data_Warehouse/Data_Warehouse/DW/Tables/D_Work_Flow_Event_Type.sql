CREATE TABLE [DW].[D_Work_Flow_Event_Type] (
    [Work_Flow_Event_Type_Skey]    INT           NOT NULL,
    [WorkFlowEventTypeBusKey]      INT           NOT NULL,
    [WorkFlowEventType]            VARCHAR (255) NULL,
    [EventID]                      INT           NULL,
    [PreviousEventID]              INT           NULL,
    [WorkFlowEventSLAType]         VARCHAR (255) NULL,
    [WorkFlowEventSLADurationType] VARCHAR (255) NULL,
    [WorkFlowEventSLADuration]     INT           NULL,
    [MonthlyActivityType]          VARCHAR (255) NULL,
    [SkippableEventID]             INT           NULL,
    [Sys_LoadDate]                 DATETIME      NOT NULL,
    [Sys_ModifiedDate]             DATETIME      NOT NULL,
    [Sys_RunID]                    INT           NOT NULL
)
WITH (CLUSTERED COLUMNSTORE INDEX, DISTRIBUTION = REPLICATE);





