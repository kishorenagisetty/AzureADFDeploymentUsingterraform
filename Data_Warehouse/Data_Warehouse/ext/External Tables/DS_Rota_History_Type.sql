CREATE EXTERNAL TABLE [ext].[DS_Rota_History_Type] (
    [RotaHistoryID] INT NULL,
    [RotaHistoryType] VARCHAR (255) NULL
)
    WITH (
    DATA_SOURCE = [polybasestaging],
    LOCATION = N'DS_Rota_History_Type/',
    FILE_FORMAT = [TextFileFormat],
    REJECT_TYPE = VALUE,
    REJECT_VALUE = 0
    );

