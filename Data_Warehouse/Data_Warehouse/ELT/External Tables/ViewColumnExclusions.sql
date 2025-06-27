CREATE EXTERNAL TABLE [ELT].[ViewColumnExclusions]
(
	[TableName] [varchar](100) NULL,
	[ColumnName] [varchar](100) NULL
)
WITH (DATA_SOURCE = [ADLG2_PSA],LOCATION = N'metadata/view_column_exclusions.csv',FILE_FORMAT = [CSVFormatStringDelimited],REJECT_TYPE = VALUE,REJECT_VALUE = 0)
GO


