CREATE EXTERNAL TABLE [DELTA].[ICONI_vBIRestart_Expense]
(
	[expense_id] [int] NULL,
	[exp_date] [datetime2](0) NULL,
	[exp_type] [nvarchar](max) NULL,
	[exp_subtype] [nvarchar](max) NULL,
	[exp_cost] [decimal](19, 2) NULL,
	[exp_payment_method] [nvarchar](max) NULL,
	[exp_paid_date] [datetime2](0) NULL,
	[exp_payment_status] [nvarchar](max) NULL,
	[exp_evidence_document_id] [int] NULL,
	[exp_notes] [nvarchar](max) NULL,
	[exp_approval_status] [nvarchar](max) NULL,
	[exp_rejected_reason] [nvarchar](max) NULL,
	[exp_engagement_id] [int] NULL,
	[exp_added_date] [datetime2](0) NULL,
	[exp_added_by_user_id] [int] NULL,
	[exp_approval_decision_by_user_id] [int] NULL,
	[exp_approval_decision_date] [datetime2](0) NULL,
	[exp_complete_date] [datetime2](0) NULL,
	[exp_complete_by_user_id] [int] NULL,
	[exp_provider_agency_id] [int] NULL,
	[exp_site_id] [int] NULL,
	[exp_last_updated_date] [datetime2](0) NULL,
	[ValidFrom] [datetime2](0) NULL,
	[ValidTo] [datetime2](0) NULL,
	[row_sha2] [nvarchar](max) NULL
)
WITH (DATA_SOURCE = [ADLG2_PSA],LOCATION = N'delta/ICONI/vBIRestart_Expense/IsCurrent=true',FILE_FORMAT = [parquet_file_format],REJECT_TYPE = VALUE,REJECT_VALUE = 0)
GO