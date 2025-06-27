CREATE TABLE [DW].[D_Case_Status] (
    [Case_Status_Skey] INT           NOT NULL,
    [CaseStatusBusKey] INT           NOT NULL,
    [CaseStatus]       VARCHAR (255) NULL,
    [IsActiveCase]     INT           NULL,
    [Active]           BIT           NULL,
    [Sys_LoadDate]     DATETIME      NULL,
    [Sys_ModifiedDate] DATETIME      NULL,
    [Sys_RunID]        INT           NULL
)
WITH (CLUSTERED COLUMNSTORE INDEX, DISTRIBUTION = REPLICATE);

