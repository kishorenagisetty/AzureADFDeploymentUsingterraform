CREATE EXTERNAL TABLE [ext].[DS_Work_Flow_Event_Type] (
    [StageID] INT NULL,
    [WorkFlowEventType] VARCHAR (255) NULL,
    [WorkFlowEventID] INT NULL,
    [WorkFlowEventSequence] INT NULL,
    [WorkFlowPreviousEventID] INT NULL,
    [WorkFlowEventSLAType] VARCHAR (255) NULL,
    [WorkFlowEventSLADurationType] VARCHAR (255) NULL,
    [WorkFlowEventSLADuration] INT NULL,
    [WorkFlowEventActionType] VARCHAR (255) NULL,
    [WorkFlowSLAName] VARCHAR (255) NULL,
    [WorkFlowTaskName] VARCHAR (255) NULL,
    [WorkFlowEventAppointmentType] VARCHAR (255) NULL,
    [Rule] VARCHAR (255) NULL,
    [Notes] VARCHAR (255) NULL,
    [MonthlyActivityType] VARCHAR (255) NULL,
    [SkippableEventID] INT NULL
)
    WITH (
    DATA_SOURCE = [polybasestaging],
    LOCATION = N'DS_Work_Flow_Event_Type/',
    FILE_FORMAT = [TextFileFormat],
    REJECT_TYPE = VALUE,
    REJECT_VALUE = 0
    );



