CREATE TABLE [DW].[D_Stage] (
    [Stage_Skey]       INT           NOT NULL,
    [StageBusKey]      INT           NOT NULL,
    [StageGroup]       VARCHAR (255) NULL,
    [StageCategory]    VARCHAR (255) NULL,
    [Stage]            VARCHAR (255) NULL,
    [StageOrder]       INT           NULL,
    [Sys_LoadDate]     DATETIME      NOT NULL,
    [Sys_ModifiedDate] DATETIME      NOT NULL,
    [Sys_RunID]        INT           NOT NULL
)
WITH (CLUSTERED COLUMNSTORE INDEX, DISTRIBUTION = REPLICATE);



