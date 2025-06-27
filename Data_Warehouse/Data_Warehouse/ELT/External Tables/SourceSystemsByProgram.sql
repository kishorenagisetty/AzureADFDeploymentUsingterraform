
CREATE EXTERNAL TABLE [ELT].[SourceSystemsByProgram]
(
	[Program] [varchar](100) NULL,
	[SourceSystem] [varchar](100) NULL
)
WITH (DATA_SOURCE = [ADLG2_PSA],LOCATION = N'metadata/ProgrammesAndSources.csv',FILE_FORMAT = [CSVFormatStringDelimited],REJECT_TYPE = VALUE,REJECT_VALUE = 0)
GO