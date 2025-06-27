CREATE TABLE [DW].[D_Task_Status] (
    [Task_Status_Skey] INT           NOT NULL,
    [TaskStatusBusKey] INT           NOT NULL,
    [TaskStatus]       VARCHAR (255) NULL,
    [Active]           BIT           NULL,
    [Sys_LoadDate]     DATETIME      NULL,
    [Sys_ModifiedDate] DATETIME      NULL,
    [Sys_RunID]        INT           NULL
)
WITH (CLUSTERED COLUMNSTORE INDEX, DISTRIBUTION = REPLICATE);

