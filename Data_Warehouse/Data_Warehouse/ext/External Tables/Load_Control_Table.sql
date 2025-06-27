CREATE EXTERNAL TABLE [ext].[Load_Control_Table] (
    [TableName] VARCHAR (255) NULL,
    [Load_Date] DATE NULL
)
    WITH (
    DATA_SOURCE = [polybasestaging],
    LOCATION = N'ELT_MetaData/Load_Control_Table',
    FILE_FORMAT = [CSVFormat],
    REJECT_TYPE = VALUE,
    REJECT_VALUE = 0
    );

