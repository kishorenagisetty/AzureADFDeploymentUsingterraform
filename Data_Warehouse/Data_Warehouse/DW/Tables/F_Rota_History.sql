CREATE TABLE [DW].[F_Rota_History] (
    [Rota_History_Skey]      INT        NOT NULL,
    [RotaHistoryBusKey]      INT        NOT NULL,
    [Date_Skey]              INT        NULL,
    [Employee_Skey]          INT        NULL,
    [Start_Time_Skey]        INT        NULL,
    [End_Time_Skey]          INT        NULL,
    [RotaType_Skey]          INT        NULL,
    [RotaHistoryType_Skey]   INT        NULL,
    [FTE_Daily]              FLOAT (53) NULL,
    [FTE_Monthly]            FLOAT (53) NULL,
    [Duration]               INT        NULL,
    [Productive_Duration]    INT        NULL,
    [Productive_FTE_Daily]   FLOAT (53) NULL,
    [Productive_FTE_Monthly] FLOAT (53) NULL,
    [Sys_LoadDate]           DATETIME   NULL,
    [Sys_LoadExpiryDate]     DATETIME   NULL,
    [Sys_IsCurrent]          BIT        NULL
)
WITH (CLUSTERED COLUMNSTORE INDEX, DISTRIBUTION = HASH([Employee_Skey]));

