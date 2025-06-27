CREATE EXTERNAL TABLE [ELT].[DataFactoriesandKeyVaults]
(
	[DataFactory] [varchar](max) NULL,
	[KeyVault] [varchar](max) NULL
)
WITH (DATA_SOURCE = [polybasestaging],LOCATION = N'DataFactoriesandKeyVaults.csv',FILE_FORMAT = [CSVFormatStringDelimited],REJECT_TYPE = VALUE,REJECT_VALUE = 0)
GO