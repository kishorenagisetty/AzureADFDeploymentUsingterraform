CREATE EXTERNAL TABLE [ELT].[ForecastType] (
    [ForecastType_ID] INT NOT NULL,
    [Effective_From] DATE NULL,
    [Effective_To] DATE NULL,
    [Type] VARCHAR (50) NULL,
    [Longname] VARCHAR (50) NULL
)
    WITH (
    DATA_SOURCE = [ADLG2_PSA],
    LOCATION = N'forecasts/ForecastType.csv',
    FILE_FORMAT = [CSVFormatStringDelimited],
    REJECT_TYPE = VALUE,
    REJECT_VALUE = 0
    );
GO

