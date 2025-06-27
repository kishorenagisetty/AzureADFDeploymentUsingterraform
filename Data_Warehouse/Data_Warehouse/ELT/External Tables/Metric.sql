CREATE EXTERNAL TABLE [ELT].[Metric] (
    [Metric_ID] INT NOT NULL,
    [metricName] VARCHAR (50) NULL
)
    WITH (
    DATA_SOURCE = [ADLG2_PSA],
    LOCATION = N'forecasts/Metric.csv',
    FILE_FORMAT = [CSVFormatStringDelimited],
    REJECT_TYPE = VALUE,
    REJECT_VALUE = 0
    );
GO

