CREATE EXTERNAL TABLE [DELTA].[ICONI_vBICommon_CustomerPortal]
(
	[ind_portal_individual_id] [INT] NULL,
	[ind_portal_username] [NVARCHAR](MAX) NULL,
	[ind_portal_registration_date] [NVARCHAR](MAX) NULL,
	[ind_portal_registration_status] [NVARCHAR](MAX) NULL,
	[ind_portal_registration_added_by_user_id] [INT] NULL,
	[ind_portal_opt_out] [BIT] NULL,
	[ind_portal_opt_out_reason] [NVARCHAR](MAX) NULL,
	[ind_portal_last_active] [NVARCHAR](MAX) NULL,
	[ind_portal_last_welcome_email] [NVARCHAR](MAX) NULL,
	[ind_portal_login_type] [NVARCHAR](MAX) NULL,
	[ind_portal_expiry_date] [NVARCHAR](MAX) NULL,
	[ValidFrom] [DATETIME2](0) NULL,
	[ValidTo] [DATETIME2](0) NULL,
	[row_sha2] [NVARCHAR](MAX) NULL
)
WITH (DATA_SOURCE = [ADLG2_PSA],LOCATION = N'delta/ICONI/vBICommon_CustomerPortal/IsCurrent=true',FILE_FORMAT = [parquet_file_format],REJECT_TYPE = VALUE,REJECT_VALUE = 0)
GO

