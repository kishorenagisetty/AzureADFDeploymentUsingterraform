CREATE EXTERNAL TABLE [DELTA].[ICONI_vBIRestart_EngagementResource]
(
	[engagement_resource_id] [int] NULL,
	[er_engagement_id] [int] NULL,
	[er_res_title] [nvarchar](max) NULL,
	[er_res_type] [nvarchar](max) NULL,
	[er_share_status] [nvarchar](max) NULL,
	[er_res_description] [nvarchar](max) NULL,
	[er_added_date] [datetime2](0) NULL,
	[er_res_proj_id] [int] NULL,
	[er_last_updated_date] [datetime2](0) NULL,
	[ValidFrom] [datetime2](0) NULL,
	[ValidTo] [datetime2](0) NULL,
	[row_sha2] [nvarchar](max) NULL
)
WITH (DATA_SOURCE = [ADLG2_PSA],LOCATION = N'delta/ICONI/vBIRestart_EngagementResource/IsCurrent=true',FILE_FORMAT = [parquet_file_format],REJECT_TYPE = VALUE,REJECT_VALUE = 0)
GO