CREATE TABLE [DW].[F_Rota_History_Combined] (
    [Rota_History_Combined_Skey]     INT        NOT NULL,
    [Date_Skey]                      INT        NULL,
    [Employee_Skey]                  INT        NULL,
    [Start_Time_Skey]                INT        NULL,
    [End_Time_Skey]                  INT        NULL,
    [RotaType_Skey]                  INT        NULL,
    [Planned_FTE_Daily]              FLOAT (53) NULL,
    [Planned_FTE_Monthly]            FLOAT (53) NULL,
    [Planned_Duration]               INT        NULL,
    [Planned_Productive_Duration]    INT        NULL,
    [Planned_Productive_FTE_Daily]   FLOAT (53) NULL,
    [Planned_Productive_FTE_Monthly] FLOAT (53) NULL,
    [Actual_FTE_Daily]               FLOAT (53) NULL,
    [Actual_FTE_Monthly]             FLOAT (53) NULL,
    [Actual_Duration]                INT        NULL,
    [Actual_Productive_Duration]     INT        NULL,
    [Actual_Productive_FTE_Daily]    FLOAT (53) NULL,
    [Actual_Productive_FTE_Monthly]  FLOAT (53) NULL,
    [Sys_LoadDate]                   DATETIME   NULL,
    [Sys_LoadExpiryDate]             DATETIME   NULL,
    [Sys_IsCurrent]                  BIT        NULL
)
WITH (CLUSTERED COLUMNSTORE INDEX, DISTRIBUTION = HASH([Employee_Skey]));

