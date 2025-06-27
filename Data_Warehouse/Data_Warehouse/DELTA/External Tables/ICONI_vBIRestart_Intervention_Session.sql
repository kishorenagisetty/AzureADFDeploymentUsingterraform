CREATE EXTERNAL TABLE [DELTA].[ICONI_vBIRestart_Intervention_Session]
(
	[intervention_session_id] [int] NULL,
	[ins_date_time] [datetime2](0) NULL,
	[ins_duration] [int] NULL,
	[ins_advisor_user_id] [int] NULL,
	[ins_external_advisor] [nvarchar](max) NULL,
	[ins_notes] [nvarchar](max) NULL,
	[ins_outcome] [nvarchar](max) NULL,
	[ins_intervention_id] [int] NULL,
	[ins_site_id] [int] NULL,
	[ins_service_session_site_id] [int] NULL,
	[ins_added_date] [datetime2](0) NULL,
	[ins_added_by_user_id] [int] NULL,
	[ins_complete_date] [datetime2](0) NULL,
	[ins_complete_by_user_id] [int] NULL,
	[ins_outcome_type] [nvarchar](max) NULL,
	[ins_last_updated_date] [datetime2](0) NULL,
	[ValidFrom] [datetime2](0) NULL,
	[ValidTo] [datetime2](0) NULL,
	[row_sha2] [nvarchar](max) NULL
)
WITH (DATA_SOURCE = [ADLG2_PSA],LOCATION = N'delta/ICONI/vBIRestart_Intervention_Session/IsCurrent=true',FILE_FORMAT = [parquet_file_format],REJECT_TYPE = VALUE,REJECT_VALUE = 0)
GO