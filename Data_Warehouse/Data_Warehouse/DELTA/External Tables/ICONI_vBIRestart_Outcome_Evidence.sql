CREATE EXTERNAL TABLE [DELTA].[ICONI_vBIRestart_Outcome_Evidence]
(
	[outcome_evidence_id] [int] NULL,
	[oev_date] [date] NULL,
	[oev_type] [nvarchar](max) NULL,
	[oev_advisor_user_id] [int] NULL,
	[oev_evidence_document_id] [int] NULL,
	[oev_notes] [nvarchar](max) NULL,
	[oev_status] [nvarchar](max) NULL,
	[oev_rejection_reason] [nvarchar](max) NULL,
	[oev_engagement_id] [int] NULL,
	[oev_added_date] [datetime2](0) NULL,
	[oev_added_by_user_id] [int] NULL,
	[oev_complete_date] [datetime2](0) NULL,
	[oev_complete_by_user_id] [int] NULL,
	[oev_last_updated_date] [datetime2](0) NULL,
	[ValidFrom] [datetime2](0) NULL,
	[ValidTo] [datetime2](0) NULL,
	[row_sha2] [nvarchar](max) NULL
)
WITH (DATA_SOURCE = [ADLG2_PSA],LOCATION = N'delta/ICONI/vBIRestart_Outcome_Evidence/IsCurrent=true',FILE_FORMAT = [parquet_file_format],REJECT_TYPE = VALUE,REJECT_VALUE = 0)
GO