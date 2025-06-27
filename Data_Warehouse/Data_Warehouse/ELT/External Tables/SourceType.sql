CREATE EXTERNAL TABLE [ELT].[SourceType] (
    [sourceType_ID] INT NOT NULL,
    [sourceTypeName] VARCHAR (50) NULL
)
    WITH (
    DATA_SOURCE = [ADLG2_PSA],
    LOCATION = N'forecasts/SourceType.csv',
    FILE_FORMAT = [CSVFormatStringDelimited],
    REJECT_TYPE = VALUE,
    REJECT_VALUE = 0
    );
GO

