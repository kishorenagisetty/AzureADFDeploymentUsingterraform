CREATE EXTERNAL TABLE [DELTA].[ICONI_vBIRestart_Payment]
(
	[payment_id] [int] NULL,
	[pay_engagement_id] [int] NULL,
	[pay_agency_id] [int] NULL,
	[pay_site_id] [int] NULL,
	[pay_project] [int] NULL,
	[pay_related_entity_id] [int] NULL,
	[pay_date] [datetime2](0) NULL,
	[pay_bat_id] [int] NULL,
	[pay_amount] [nvarchar](max) NULL,
	[pay_provider_bat_id] [int] NULL,
	[pay_provider_amount] [nvarchar](max) NULL,
	[pay_received_date] [datetime2](0) NULL,
	[pay_finance_ref_number] [nvarchar](max) NULL,
	[pay_dwp_payment_level] [nvarchar](max) NULL,
	[pay_performance_level] [nvarchar](max) NULL,
	[pay_notes] [nvarchar](max) NULL,
	[pay_type] [nvarchar](max) NULL,
	[pay_category] [nvarchar](max) NULL,
	[pay_status] [nvarchar](max) NULL,
	[pay_added_date] [datetime2](0) NULL,
	[ValidFrom] [datetime2](0) NULL,
	[ValidTo] [datetime2](0) NULL
)
WITH (DATA_SOURCE = [ADLG2_PSA],LOCATION = N'delta/ICONI/vBIRestart_Payment/IsCurrent=true',FILE_FORMAT = [parquet_file_format],REJECT_TYPE = VALUE,REJECT_VALUE = 0)
GO