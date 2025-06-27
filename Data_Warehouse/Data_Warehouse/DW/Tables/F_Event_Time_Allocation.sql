CREATE TABLE [DW].[F_Event_Time_Allocation] (
    [Event_Time_Allocation_Skey] INT      NOT NULL,
    [EventTimeAllocationBusKey]  INT      NOT NULL,
    [Work_Flow_Event_Type_Skey]  INT      NULL,
    [Event_Plan_Skey]            INT      NULL,
    [EventTimeInSeconds]         INT      NULL,
    [EventTimeInMinutes]         INT      NULL,
    [Sys_LoadDate]               DATETIME NOT NULL,
    [Sys_RunID]                  INT      NULL
)
WITH (CLUSTERED COLUMNSTORE INDEX, DISTRIBUTION = HASH([Work_Flow_Event_Type_Skey]));





