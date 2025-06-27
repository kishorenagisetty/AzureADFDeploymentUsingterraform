CREATE EXTERNAL TABLE [ext].[DS_Event_Plan] (
    [EventPlan] VARCHAR (255) NULL,
    [EventPlanDescription] VARCHAR (255) NULL
)
    WITH (
    DATA_SOURCE = [polybasestaging],
    LOCATION = N'DS_Event_Plan/',
    FILE_FORMAT = [TextFileFormat],
    REJECT_TYPE = VALUE,
    REJECT_VALUE = 0
    );

