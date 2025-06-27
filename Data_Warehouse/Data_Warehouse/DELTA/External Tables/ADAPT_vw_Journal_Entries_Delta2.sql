
CREATE EXTERNAL TABLE [DELTA].[ADAPT_vw_Journal_Entries_Delta2]
(
	[Journal_ID] [decimal](16, 0) NULL,
	[AddDate] [datetime2](0) NULL,
	[AddUser] [nvarchar](max) NULL,
	[BusinessObject] [nvarchar](max) NULL,
	[Notes] [nvarchar](max) NULL,
	[EntityID_1] [bigint] NULL,
	[UPDATEDDATE] [datetime2](0) NULL,
	[ValidFrom] [datetime2](0) NULL,
	[ValidTo] [datetime2](0) NULL,
	[row_sha2] [nvarchar](max) NULL
)
WITH (DATA_SOURCE = [ADLG2_PSA],LOCATION = N'delta/ADAPT/vw_Journal_Entries_Delta2/IsCurrent=true',FILE_FORMAT = [parquet_file_format],REJECT_TYPE = VALUE,REJECT_VALUE = 0)
GO