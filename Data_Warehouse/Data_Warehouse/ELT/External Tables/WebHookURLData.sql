
CREATE EXTERNAL TABLE [ELT].[WebHookURLData]
(
	[ParentDataFactory] [varchar](100) NULL,
	[SubscriptionID] [varchar](max) NULL,
	[ResourceGroup] [varchar](100) NULL,
	[ChildDataFactory] [varchar](100) NULL,
	[Pipeline] [varchar](100) NULL
)
WITH (DATA_SOURCE = [ADLG2_PSA],LOCATION = N'metadata/WebHookURLs.csv',FILE_FORMAT = [CSVFormatStringDelimited],REJECT_TYPE = VALUE,REJECT_VALUE = 0)
GO