CREATE TABLE [DW].[D_Case_Source] (
    [Case_Source_Skey] INT           NOT NULL,
    [CaseSourceBusKey] INT           NOT NULL,
    [CaseSource]       VARCHAR (255) NULL,
    [Active]           BIT           NULL,
    [Sys_LoadDate]     DATETIME      NULL,
    [Sys_ModifiedDate] DATETIME      NULL,
    [Sys_RunID]        INT           NULL
)
WITH (CLUSTERED COLUMNSTORE INDEX, DISTRIBUTION = REPLICATE);

