CREATE EXTERNAL TABLE [DELTA].[ICONI_vBIRestart_GroupSessionSession]
(
	[group_session_session_id] [int] NULL,
	[gss_title] [nvarchar](max) NULL,
	[gss_date_display] [nvarchar](max) NULL,
	[gss_time_display] [nvarchar](max) NULL,
	[gss_duration] [int] NULL,
	[gss_trainer_fullname] [nvarchar](max) NULL,
	[gss_delivery_method_display] [nvarchar](max) NULL,
	[gss_location] [nvarchar](max) NULL,
	[gss_details] [nvarchar](max) NULL,
	[gss_non_registered_attendees] [int] NULL,
	[gss_attendance_notes] [nvarchar](max) NULL,
	[gss_added_by_user_id] [int] NULL,
	[gss_added_by_fullname] [nvarchar](max) NULL,
	[gss_added_date_display] [nvarchar](max) NULL,
	[gss_last_updated_date] [datetime2](0) NULL,
	[ValidFrom] [datetime2](0) NULL,
	[ValidTo] [datetime2](0) NULL,
	[row_sha2] [nvarchar](max) NULL
)
WITH (DATA_SOURCE = [ADLG2_PSA],LOCATION = N'delta/ICONI/vBIRestart_GroupSessionSession/IsCurrent=true',FILE_FORMAT = [parquet_file_format],REJECT_TYPE = VALUE,REJECT_VALUE = 0)
GO