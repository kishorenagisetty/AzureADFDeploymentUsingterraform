CREATE EXTERNAL TABLE [DELTA].[ICONI_vBIRestart_Assessment]
(
	[assessment_id] [int] NULL,
	[ass_advisor_user_id] [int] NULL,
	[ass_date_time] [datetime2](0) NULL,
	[ass_score] [nvarchar](max) NULL,
	[ass_type] [nvarchar](max) NULL,
	[ass_sub_type] [nvarchar](max) NULL,
	[ass_stage] [nvarchar](max) NULL,
	[ass_provider_agency_id] [int] NULL,
	[ass_site_id] [int] NULL,
	[ass_notes] [nvarchar](max) NULL,
	[ass_engagement_id] [int] NULL,
	[ass_added_date] [datetime2](0) NULL,
	[ass_added_by_user_id] [int] NULL,
	[ass_complete_date] [datetime2](0) NULL,
	[ass_complete_by_user_id] [int] NULL,
	[ass_last_updated_date] [datetime2](0) NULL,
	[ValidFrom] [datetime2](0) NULL,
	[ValidTo] [datetime2](0) NULL,
	[row_sha2] [nvarchar](max) NULL
)
WITH (DATA_SOURCE = [ADLG2_PSA],LOCATION = N'delta/ICONI/vBIRestart_Assessment/IsCurrent=true',FILE_FORMAT = [parquet_file_format],REJECT_TYPE = VALUE,REJECT_VALUE = 0)
GO

