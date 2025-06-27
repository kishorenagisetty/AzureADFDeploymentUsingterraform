CREATE EXTERNAL TABLE [DELTA].[ICONI_vBICommon_EarningsNotification]
(
	[earnings_notification_id] [INT] NULL,
	[ern_engagement_id] [INT] NULL,
	[ern_notification_type] [NVARCHAR](MAX) NULL,
	[ern_date_created] [DATETIME2](0) NULL,
	[ern_notification_date] [DATETIME2](0) NULL,
	[ern_nino] [NVARCHAR](MAX) NULL,
	[ern_prap_po_number] [NVARCHAR](MAX) NULL,
	[ern_asn_creation_status] [NVARCHAR](MAX) NULL,
	[ern_asn_number] [NVARCHAR](MAX) NULL,
	[ern_invoice_number] [NVARCHAR](MAX) NULL,
	[ern_acknowledgement_required] [BIT] NULL,
	[ern_added_by_user_id] [INT] NULL,
	[ern_added_date] [DATETIME2](0) NULL,
	[ern_proj_id] [INT] NULL,
	[ern_last_updated_date] [DATETIME2](0) NULL,
	[ValidFrom] [DATETIME2](0) NULL,
	[ValidTo] [DATETIME2](0) NULL,
	[row_sha2] [NVARCHAR](MAX) NULL
)
WITH (DATA_SOURCE = [ADLG2_PSA],LOCATION = N'delta/ICONI/vBICommon_EarningsNotification/IsCurrent=true',FILE_FORMAT = [parquet_file_format],REJECT_TYPE = VALUE,REJECT_VALUE = 0)
GO

