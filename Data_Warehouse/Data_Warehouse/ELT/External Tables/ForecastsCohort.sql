CREATE EXTERNAL TABLE [ELT].[ForecastsCohort]
(
	[ForecastsCohort_ID] [int] NOT NULL,
	[ForecastDate] [date] NULL,
	[CohortMonthNumber] [int] NOT NULL,
	[Metric] [varchar](50) NULL,
	[SourceType] [varchar](50) NULL,
	[Programme] [varchar](250) NULL,
	[Conv] [decimal](18, 4) NULL,
	[CumulConv] [decimal](18, 4) NULL,
	[FileName] [varchar](50) NULL
)
WITH (DATA_SOURCE = [ADLG2_PSA]
	,LOCATION = N'forecasts/ForecastsCohort.csv'
	,FILE_FORMAT = [CSVFormatStringDelimited]
	,REJECT_TYPE = VALUE
	,REJECT_VALUE = 0);
GO
