CREATE EXTERNAL TABLE [DELTA].[ICONI_vBIRestart_VacancyInterest_History]
(
	[vacancy_interest_id] [int] NULL,
	[vai_vacancy_id] [int] NULL,
	[vai_individual_id] [int] NULL,
	[vai_engagement_id] [int] NULL,
	[vai_date] [nvarchar](max) NULL,
	[vai_complete_date] [nvarchar](max) NULL,
	[vai_outcome_1] [nvarchar](max) NULL,
	[vai_outcome_reason] [nvarchar](max) NULL,
	[vai_outcome_reason_2] [nvarchar](max) NULL,
	[vai_outcome_reason_other] [nvarchar](max) NULL,
	[vai_notes] [nvarchar](max) NULL,
	[vai_acknowledgement_required_by_user_id] [int] NULL,
	[vai_acknowledgement_required] [datetime2](0) NULL,
	[vai_stage] [nvarchar](max) NULL,
	[vai_employer_email_sent_date] [nvarchar](max) NULL,
	[vai_proj_id] [int] NULL,
	[vai_notification_raised] [nvarchar](max) NULL,
	[vai_notification_read] [nvarchar](max) NULL,
	[vai_added_by_user_id] [int] NULL,
	[vai_added_date] [nvarchar](max) NULL,
	[vai_complete_by_user_id] [int] NULL,
	[vai_vacancy_external_info_id] [int] NULL,
	[vai_last_viewed] [nvarchar](max) NULL,
	[vai_added_by_source] [nvarchar](max) NULL,
	[vai_added_by_external_id] [nvarchar](max) NULL,
	[vai_added_by_external_full_name] [nvarchar](max) NULL,
	[ValidFrom] [datetime2](0) NULL,
	[ValidTo] [datetime2](0) NULL,
	[row_sha2] [nvarchar](max) NULL
)
WITH (DATA_SOURCE = [ADLG2_PSA],LOCATION = N'delta/ICONI/vBIRestart_VacancyInterest/IsCurrent=false',FILE_FORMAT = [parquet_file_format],REJECT_TYPE = VALUE,REJECT_VALUE = 0)
GO