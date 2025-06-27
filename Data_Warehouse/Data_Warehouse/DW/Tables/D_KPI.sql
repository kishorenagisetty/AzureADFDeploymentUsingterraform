CREATE TABLE [DW].[D_KPI] (
    [KPI_Skey]                         INT            NOT NULL,
    [KPIBusKey]                        VARCHAR (255)  NULL,
    [KPIArea]                          VARCHAR (255)  NULL,
    [KPIName]                          VARCHAR (255)  NULL,
    [KPIDescriptionOfStandardRequired] VARCHAR (255)  NULL,
    [KPIType]                          VARCHAR (255)  NULL,
    [KPIStartType]                     VARCHAR (255)  NULL,
    [KPIStartEventType]                VARCHAR (255)  NULL,
    [KPIEndType]                       VARCHAR (255)  NULL,
    [KPIEndEventType]                  VARCHAR (255)  NULL,
    [KPIDurationType]                  VARCHAR (255)  NULL,
    [KPIDuration]                      INT            NULL,
    [KPIGreenStart]                    DECIMAL (3, 2) NULL,
    [KPIGreenEnd]                      DECIMAL (3, 2) NULL,
    [KPIAmberStart]                    DECIMAL (3, 2) NULL,
    [KPIAmberEnd]                      DECIMAL (3, 2) NULL,
    [KPIRedStart]                      DECIMAL (3, 2) NULL,
    [KPIRedEnd]                        DECIMAL (3, 2) NULL,
    [Sys_LoadDate]                     DATETIME       NOT NULL,
    [Sys_ModifiedDate]                 DATETIME       NOT NULL,
    [Sys_RunID]                        INT            NULL
)
WITH (CLUSTERED COLUMNSTORE INDEX, DISTRIBUTION = REPLICATE);



