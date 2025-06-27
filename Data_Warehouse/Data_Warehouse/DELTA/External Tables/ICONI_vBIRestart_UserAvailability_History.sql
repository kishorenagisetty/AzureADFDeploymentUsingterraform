CREATE EXTERNAL TABLE [DELTA].[ICONI_vBIRestart_UserAvailability_History]
(
	[user_availability_id] [int] NULL,
	[ucs_user_id] [int] NULL,
	[ucs_site_id] [int] NULL,
	[ucs_type] [nvarchar](max) NULL,
	[ucs_sub_type] [nvarchar](max) NULL,
	[ucs_day] [nvarchar](max) NULL,
	[ucs_date] [date] NULL,
	[ucs_start_time] [datetime2](0) NULL,
	[ucs_end_time] [datetime2](0) NULL,
	[ucs_week_status] [nvarchar](max) NULL,
	[ucs_added_date] [datetime2](0) NULL,
	[ucs_last_updated_date] [datetime2](0) NULL,
	[ValidFrom] [datetime2](0) NULL,
	[ValidTo] [datetime2](0) NULL,
	[row_sha2] [nvarchar](max) NULL
)
WITH (DATA_SOURCE = [ADLG2_PSA],LOCATION = N'delta/ICONI/vBIRestart_UserAvailability/IsCurrent=false',FILE_FORMAT = [parquet_file_format],REJECT_TYPE = VALUE,REJECT_VALUE = 0)
GO