CREATE EXTERNAL TABLE [ext].[DS_Event_Time_Allocation] (
    [Event_Type] VARCHAR (255) NULL,
    [Plan_1] VARCHAR (255) NULL,
    [Plan_2] VARCHAR (255) NULL,
    [Plan_3] VARCHAR (255) NULL,
    [Plan_4] VARCHAR (255) NULL,
    [Plan_5] VARCHAR (255) NULL,
    [Plan_6] VARCHAR (255) NULL,
    [Plan_7] VARCHAR (255) NULL,
    [Plan_8] VARCHAR (255) NULL,
    [Plan_9] VARCHAR (255) NULL,
    [Plan_10] VARCHAR (255) NULL,
    [Plan_11] VARCHAR (255) NULL,
    [Plan_12] VARCHAR (255) NULL,
    [Plan_13] VARCHAR (255) NULL,
    [Plan_14] VARCHAR (255) NULL,
    [Plan_15] VARCHAR (255) NULL,
    [Plan_16] VARCHAR (255) NULL,
    [Plan_17] VARCHAR (255) NULL,
    [Plan_18] VARCHAR (255) NULL,
    [Plan_19] VARCHAR (255) NULL,
    [Plan_20] VARCHAR (255) NULL
)
    WITH (
    DATA_SOURCE = [polybasestaging],
    LOCATION = N'DS_Event_Time_Allocation/',
    FILE_FORMAT = [TextFileFormat],
    REJECT_TYPE = VALUE,
    REJECT_VALUE = 0
    );

