CREATE TABLE [DW].[D_Rota_Type] (
    [RotaType_Skey]    INT           NOT NULL,
    [RotaTypeBusKey]   INT           NOT NULL,
    [RotaType]         VARCHAR (255) NULL,
    [Description]      VARCHAR (255) NULL,
    [Productive]       VARCHAR (255) NULL,
    [Sys_LoadDate]     DATETIME      NOT NULL,
    [Sys_ModifiedDate] DATETIME      NOT NULL,
    [Sys_RunID]        INT           NOT NULL
)
WITH (CLUSTERED COLUMNSTORE INDEX, DISTRIBUTION = REPLICATE);



