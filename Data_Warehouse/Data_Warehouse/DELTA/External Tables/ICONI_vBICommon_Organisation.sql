CREATE EXTERNAL TABLE [DELTA].[ICONI_vBICommon_Organisation]
(
	[organisation_id] [INT] NULL,
	[org_contact_details_id] [INT] NULL,
	[org_primary_contact_id] [INT] NULL,
	[org_name] [NVARCHAR](MAX) NULL,
	[org_type] [NVARCHAR](MAX) NULL,
	[org_soc] [NVARCHAR](MAX) NULL,
	[org_iconi_notes] [NVARCHAR](MAX) NULL,
	[org_version_no] [INT] NULL,
	[org_notes] [NVARCHAR](MAX) NULL,
	[org_legal_status] [NVARCHAR](MAX) NULL,
	[org_no_of_employees] [NVARCHAR](MAX) NULL,
	[org_sic] [NVARCHAR](MAX) NULL,
	[org_disability_conf] [NVARCHAR](MAX) NULL,
	[org_disability_conf_level] [NVARCHAR](MAX) NULL,
	[org_status] [NVARCHAR](MAX) NULL,
	[org_source] [NVARCHAR](MAX) NULL,
	[org_initial_prog] [NVARCHAR](MAX) NULL,
	[org_added_by_user_id] [INT] NULL,
	[org_added_date] [DATETIME2](0) NULL,
	[org_last_updated_date] [DATETIME2](0) NULL,
	[org_added_by_source] [NVARCHAR](MAX) NULL,
	[org_added_by_user_external_id] [NVARCHAR](MAX) NULL,
	[org_added_by_user_external_full_name] [NVARCHAR](MAX) NULL,
	[ValidFrom] [DATETIME2](0) NULL,
	[ValidTo] [DATETIME2](0) NULL,
	[row_sha2] [NVARCHAR](MAX) NULL
)
WITH (DATA_SOURCE = [ADLG2_PSA],LOCATION = N'delta/ICONI/vBICommon_Organisation/IsCurrent=true',FILE_FORMAT = [parquet_file_format],REJECT_TYPE = VALUE,REJECT_VALUE = 0)
GO

