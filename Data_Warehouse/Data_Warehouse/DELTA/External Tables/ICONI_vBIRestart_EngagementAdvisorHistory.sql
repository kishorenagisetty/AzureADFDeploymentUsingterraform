CREATE EXTERNAL TABLE [DELTA].[ICONI_vBIRestart_EngagementAdvisorHistory]
(
	[engagement_advisor_history_id] [int] NULL,
	[eah_engagement_id] [int] NULL,
	[eah_value_before] [nvarchar](max) NULL,
	[eah_value_after] [nvarchar](max) NULL,
	[eah_reason] [nvarchar](max) NULL,
	[eah_reason_other] [nvarchar](max) NULL,
	[eah_change_by_user_id] [int] NULL,
	[eah_change_date] [datetime2](0) NULL,
	[eah_change_by_source] [nvarchar](max) NULL,
	[eah_change_by_user_external_id] [nvarchar](max) NULL,
	[eah_change_by_user_external_full_name] [nvarchar](max) NULL,
	[ValidFrom] [datetime2](0) NULL,
	[ValidTo] [datetime2](0) NULL,
	[row_sha2] [nvarchar](max) NULL
)
WITH (DATA_SOURCE = [ADLG2_PSA],LOCATION = N'delta/ICONI/vBIRestart_EngagementAdvisorHistory/IsCurrent=true',FILE_FORMAT = [parquet_file_format],REJECT_TYPE = VALUE,REJECT_VALUE = 0)
GO