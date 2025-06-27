CREATE EXTERNAL TABLE [ext].[ELT_Load_Control_Table] (
    [TableName] VARCHAR (255) NULL,
    [Load_Date] DATE NULL
)
    WITH (
    DATA_SOURCE = [polybasestaging],
    LOCATION = N'ELT_MetaData/Load_Control_Table',
    FILE_FORMAT = [PipeFileFormat],
    REJECT_TYPE = VALUE,
    REJECT_VALUE = 0
    );

