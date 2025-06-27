CREATE EXTERNAL TABLE [ELT].[Forecasts] (
    [Forecasts_ID] INT NOT NULL,
    [ForecastDate] DATE NULL,
    [ForecastType] VARCHAR (250) NULL,
    [Metric] VARCHAR (50) NULL,
    [SourceType] VARCHAR (50) NULL,
    [Programme] VARCHAR (250) NULL,
    [Region] VARCHAR (250) NULL,
    [Zone] VARCHAR (250) NULL,
    [Value] DECIMAL (18, 3) NULL,
    [FileName] VARCHAR (50) NULL
)
    WITH (
    DATA_SOURCE = [ADLG2_PSA],
    LOCATION = N'forecasts/Forecasts.csv',
    FILE_FORMAT = [CSVFormatStringDelimited],
    REJECT_TYPE = VALUE,
    REJECT_VALUE = 0
    );
GO