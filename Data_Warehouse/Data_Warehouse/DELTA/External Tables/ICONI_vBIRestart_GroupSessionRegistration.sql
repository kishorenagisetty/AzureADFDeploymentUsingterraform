CREATE EXTERNAL TABLE [DELTA].[ICONI_vBIRestart_GroupSessionRegistration]
(
	[group_session_registration_id] [int] NULL,
	[gsr_crr_status] [nvarchar](max) NULL,
	[gsr_advisor] [nvarchar](max) NULL,
	[gsr_tran_date] [nvarchar](max) NULL,
	[gsr_tran_time] [nvarchar](max) NULL,
	[gsr_advisor_notes] [nvarchar](max) NULL,
	[gsr_barriers] [nvarchar](max) NULL,
	[gsr_tran_added_by_fullname] [nvarchar](max) NULL,
	[gsr_outcome] [nvarchar](max) NULL,
	[gsr_group_session_id] [int] NULL,
	[gsr_grs_title] [nvarchar](max) NULL,
	[gsr_category] [nvarchar](max) NULL,
	[gsr_gss_duration] [int] NULL,
	[gsr_grs_status] [nvarchar](max) NULL,
	[gsr_last_updated_date] [datetime2](0) NULL,
	[gsr_added_by_user_id] [int] NULL,
	[gsr_added_date] [datetime2](0) NULL,
	[gsr_individual_id] [int] NULL,
	[gsr_engagement_id] [int] NULL,
	[ValidFrom] [datetime2](0) NULL,
	[ValidTo] [datetime2](0) NULL,
	[row_sha2] [nvarchar](max) NULL
)
WITH (DATA_SOURCE = [ADLG2_PSA],LOCATION = N'delta/ICONI/vBIRestart_GroupSessionRegistration/IsCurrent=true',FILE_FORMAT = [parquet_file_format],REJECT_TYPE = VALUE,REJECT_VALUE = 0)
GO