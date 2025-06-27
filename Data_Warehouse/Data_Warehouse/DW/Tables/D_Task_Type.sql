CREATE TABLE [DW].[D_Task_Type] (
    [Task_Type_Skey]   INT           NOT NULL,
    [TaskTypeBusKey]   INT           NOT NULL,
    [TaskType]         VARCHAR (255) NULL,
    [Active]           BIT           NULL,
    [Sys_LoadDate]     DATETIME      NULL,
    [Sys_ModifiedDate] DATETIME      NULL,
    [Sys_RunID]        INT           NULL
)
WITH (CLUSTERED COLUMNSTORE INDEX, DISTRIBUTION = REPLICATE);



