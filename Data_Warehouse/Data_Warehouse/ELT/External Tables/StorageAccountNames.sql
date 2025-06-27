
CREATE EXTERNAL TABLE [ELT].[StorageAccountNames]
(
	[ADFName] [varchar](max) NULL,
	[StorageAccountName] [varchar](max) NULL
)
WITH (DATA_SOURCE = [ADLG2_PSA],LOCATION = N'metadata/StorageAccountNames.csv',FILE_FORMAT = [CSVFormatStringDelimited],REJECT_TYPE = VALUE,REJECT_VALUE = 0)
GO

