CREATE EXTERNAL TABLE [DELTA].[ICONI_vBIRestart_EngagementSiteHistory]
(
	[engagement_site_history_id] [int] NULL,
	[es_engagement_id] [int] NULL,
	[es_value_before] [nvarchar](max) NULL,
	[es_value_after] [nvarchar](max) NULL,
	[es_reason] [nvarchar](max) NULL,
	[es_reason_other] [nvarchar](max) NULL,
	[es_change_by_user_id] [int] NULL,
	[es_change_date] [datetime2](0) NULL,
	[es_change_by_source] [nvarchar](max) NULL,
	[es_change_by_user_external_id] [nvarchar](max) NULL,
	[es_change_by_user_external_full_name] [nvarchar](max) NULL,
	[ValidFrom] [datetime2](0) NULL,
	[ValidTo] [datetime2](0) NULL,
	[row_sha2] [nvarchar](max) NULL
)
WITH (DATA_SOURCE = [ADLG2_PSA],LOCATION = N'delta/ICONI/vBIRestart_EngagementSiteHistory/IsCurrent=true',FILE_FORMAT = [parquet_file_format],REJECT_TYPE = VALUE,REJECT_VALUE = 0)
GO