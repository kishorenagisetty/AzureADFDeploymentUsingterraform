CREATE EXTERNAL TABLE [DELTA].[ICONI_vBIRestart_EngagementStatusHistory]
(
	[engagement_status_history_id] [int] NULL,
	[esh_engagement_id] [int] NULL,
	[esh_value_before] [nvarchar](max) NULL,
	[esh_value_after] [nvarchar](max) NULL,
	[esh_reason] [nvarchar](max) NULL,
	[esh_reason_other] [nvarchar](max) NULL,
	[esh_change_by_user_id] [int] NULL,
	[esh_change_date] [datetime2](0) NULL,
	[esh_last_updated_date] [datetime2](0) NULL,
	[esh_change_by_source] [nvarchar](max) NULL,
	[esh_change_by_user_external_id] [nvarchar](max) NULL,
	[esh_change_by_user_external_full_name] [nvarchar](max) NULL,
	[ValidFrom] [datetime2](0) NULL,
	[ValidTo] [datetime2](0) NULL,
	[row_sha2] [nvarchar](max) NULL
)
WITH (DATA_SOURCE = [ADLG2_PSA],LOCATION = N'delta/ICONI/vBIRestart_EngagementStatusHistory/IsCurrent=true',FILE_FORMAT = [parquet_file_format],REJECT_TYPE = VALUE,REJECT_VALUE = 0)
GO