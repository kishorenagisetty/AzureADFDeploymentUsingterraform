CREATE EXTERNAL TABLE [ext].[DS_Rota_Type] (
    [Type] VARCHAR (255) NULL,
    [Description] VARCHAR (255) NULL,
    [Productive] VARCHAR (255) NULL
)
    WITH (
    DATA_SOURCE = [polybasestaging],
    LOCATION = N'DS_Rota_Type/',
    FILE_FORMAT = [TextFileFormat],
    REJECT_TYPE = VALUE,
    REJECT_VALUE = 0
    );

