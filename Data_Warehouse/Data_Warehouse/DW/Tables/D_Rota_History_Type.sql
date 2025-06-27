CREATE TABLE [DW].[D_Rota_History_Type] (
    [RotaHistoryType_Skey]  INT           NOT NULL,
    [RotaHistoryTypeBusKey] INT           NOT NULL,
    [RotaHistoryType]       VARCHAR (255) NULL,
    [Sys_LoadDate]          DATETIME      NOT NULL,
    [Sys_ModifiedDate]      DATETIME      NOT NULL,
    [Sys_RunID]             INT           NOT NULL
)
WITH (CLUSTERED COLUMNSTORE INDEX, DISTRIBUTION = REPLICATE);





