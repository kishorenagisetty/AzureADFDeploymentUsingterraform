CREATE EXTERNAL TABLE [ext].[DS_Attrition_Reason] (
    [AttritionReasonBusKey] VARCHAR (255) NOT NULL,
    [AttritionType] VARCHAR (255) NULL,
    [AttritionReason] VARCHAR (255) NOT NULL
)
    WITH (
    DATA_SOURCE = [polybasestaging],
    LOCATION = N'DS_Attrition_Reason/',
    FILE_FORMAT = [TextFileFormatNEW],
    REJECT_TYPE = VALUE,
    REJECT_VALUE = 0
    );

