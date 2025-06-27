CREATE EXTERNAL TABLE [DELTA].[ICONI_vBICommon_User]
(
	[user_id] [INT] NULL,
	[user_forename] [NVARCHAR](MAX) NULL,
	[user_surname] [NVARCHAR](MAX) NULL,
	[user_fullname] [NVARCHAR](MAX) NULL,
	[user_agency_id] [INT] NULL,
	[user_email] [NVARCHAR](MAX) NULL,
	[user_suspended_date] [DATETIME2](0) NULL,
	[user_type] [NVARCHAR](MAX) NULL,
	[user_organisation_id] [INT] NULL,
	[user_added_date] [DATETIME2](0) NULL,
	[user_username] [NVARCHAR](MAX) NULL,
	[user_supports_over_50] [NVARCHAR](MAX) NULL,
	[user_locked] [BIT] NULL,
	[user_sso_identifier] [NVARCHAR](MAX) NULL,
	[user_sso_enabled] [BIT] NULL,
	[role_name] [NVARCHAR](MAX) NULL,
	[user_notes] [NVARCHAR](MAX) NULL,
	[user_last_login] [DATETIME2](0) NULL,
	[user_archive] [BIT] NULL,
	[user_timeout_timer] [INT] NULL,
	[user_licencing_prog] [INT] NULL,
	[user_last_updated_date] [DATETIME2](0) NULL,
	[user_tk_access] [BIT] NULL,
	[user_date_removed] [DATETIME2](0) NULL,
	[ValidFrom] [DATETIME2](0) NULL,
	[ValidTo] [DATETIME2](0) NULL,
	[row_sha2] [NVARCHAR](MAX) NULL
)
WITH (DATA_SOURCE = [ADLG2_PSA],LOCATION = N'delta/ICONI/vBICommon_User/IsCurrent=true',FILE_FORMAT = [parquet_file_format],REJECT_TYPE = VALUE,REJECT_VALUE = 0)
GO