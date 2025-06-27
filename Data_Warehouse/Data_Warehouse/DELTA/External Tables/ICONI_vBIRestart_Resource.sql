CREATE EXTERNAL TABLE [DELTA].[ICONI_vBIRestart_Resource]
(
	[resource_id] [int] NULL,
	[res_status] [nvarchar](max) NULL,
	[res_title] [nvarchar](max) NULL,
	[res_description] [nvarchar](max) NULL,
	[res_type] [nvarchar](max) NULL,
	[res_file] [int] NULL,
	[res_review_date] [datetime2](0) NULL,
	[res_categories] [nvarchar](max) NULL,
	[res_publish_location] [nvarchar](max) NULL,
	[res_added_by_user_id] [int] NULL,
	[res_added_date] [datetime2](0) NULL,
	[res_last_updated_date] [datetime2](0) NULL,
	[ValidFrom] [datetime2](0) NULL,
	[ValidTo] [datetime2](0) NULL,
	[row_sha2] [nvarchar](max) NULL
)
WITH (DATA_SOURCE = [ADLG2_PSA],LOCATION = N'delta/ICONI/vBIRestart_Resource/IsCurrent=true',FILE_FORMAT = [parquet_file_format],REJECT_TYPE = VALUE,REJECT_VALUE = 0)
GO