CREATE TABLE [DW].[D_Source] (
    [Source_Skey]      INT           NOT NULL,
    [SourceBusKey]     INT           NOT NULL,
    [Source]           VARCHAR (255) NULL,
    [Active]           BIT           NULL,
    [Sys_LoadDate]     DATETIME      NULL,
    [Sys_ModifiedDate] DATETIME      NULL,
    [Sys_RunID]        INT           NULL
)
WITH (CLUSTERED COLUMNSTORE INDEX, DISTRIBUTION = REPLICATE);

