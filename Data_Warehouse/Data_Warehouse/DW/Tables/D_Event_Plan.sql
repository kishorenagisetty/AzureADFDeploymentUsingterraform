CREATE TABLE [DW].[D_Event_Plan] (
    [Event_Plan_Skey]      INT           NOT NULL,
    [EventPlanBusKey]      INT           NOT NULL,
    [EventPlanDescription] VARCHAR (255) NULL,
    [Sys_LoadDate]         DATETIME      NOT NULL,
    [Sys_ModifiedDate]     DATETIME      NOT NULL,
    [Sys_RunID]            INT           NOT NULL
)
WITH (CLUSTERED COLUMNSTORE INDEX, DISTRIBUTION = REPLICATE);



