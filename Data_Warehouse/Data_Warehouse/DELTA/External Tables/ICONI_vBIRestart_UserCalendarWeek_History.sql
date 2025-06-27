CREATE EXTERNAL TABLE [DELTA].[ICONI_vBIRestart_UserCalendarWeek_History]
(
	[user_calendar_week_id] [int] NULL,
	[ucw_user_id] [int] NULL,
	[ucw_week_start_on] [date] NULL,
	[ucw_creation_type] [nvarchar](max) NULL,
	[ucw_week_status] [nvarchar](max) NULL,
	[ucw_added_date] [datetime2](0) NULL,
	[ucw_last_updated_date] [datetime2](0) NULL,
	[ValidFrom] [datetime2](0) NULL,
	[ValidTo] [datetime2](0) NULL,
	[row_sha2] [nvarchar](max) NULL
)
WITH (DATA_SOURCE = [ADLG2_PSA],LOCATION = N'delta/ICONI/vBIRestart_UserCalendarWeek/IsCurrent=false',FILE_FORMAT = [parquet_file_format],REJECT_TYPE = VALUE,REJECT_VALUE = 0)
GO