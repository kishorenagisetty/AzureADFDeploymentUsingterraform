CREATE EXTERNAL TABLE [DELTA].[ICONI_vBICommon_Contact]
(
	[contact_id] [INT] NULL,
	[con_contact_details_id] [INT] NULL,
	[con_forename] [NVARCHAR](MAX) NULL,
	[con_surname] [NVARCHAR](MAX) NULL,
	[con_job_title] [NVARCHAR](MAX) NULL,
	[con_notes] [NVARCHAR](MAX) NULL,
	[con_added_date] [DATETIME2](0) NULL,
	[con_title] [NVARCHAR](MAX) NULL,
	[con_status] [NVARCHAR](MAX) NULL,
	[con_last_updated_date] [DATETIME2](0) NULL,
	[con_added_by_source] [NVARCHAR](MAX) NULL,
	[con_added_by_external_id] [NVARCHAR](MAX) NULL,
	[con_added_by_external_full_name] [NVARCHAR](MAX) NULL,
	[con_version_no] [INT] NULL,
	[ValidFrom] [DATETIME2](0) NULL,
	[ValidTo] [DATETIME2](0) NULL,
	[row_sha2] [NVARCHAR](MAX) NULL
)
WITH (DATA_SOURCE = [ADLG2_PSA],LOCATION = N'delta/ICONI/vBICommon_Contact/IsCurrent=true',FILE_FORMAT = [parquet_file_format],REJECT_TYPE = VALUE,REJECT_VALUE = 0)
GO

