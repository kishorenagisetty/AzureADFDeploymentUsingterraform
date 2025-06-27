CREATE EXTERNAL TABLE [DELTA].[ICONI_vBICommon_Agency]
(
	[agency_id] [INT] NULL,
	[agency_admin_contact_details_id] [INT] NULL,
	[agency_name] [NVARCHAR](MAX) NULL,
	[agency_short_name] [NVARCHAR](MAX) NULL,
	[agency_provide_service] [BIT] NULL,
	[agency_added_date] [DATETIME2](0) NULL,
	[agency_notes] [NVARCHAR](MAX) NULL,
	[agency_type] [NVARCHAR](MAX) NULL,
	[agency_last_updated_date] [DATETIME2](0) NULL,
	[ValidFrom] [DATETIME2](0) NULL,
	[ValidTo] [DATETIME2](0) NULL,
	[row_sha2] [NVARCHAR](MAX) NULL
)
WITH (DATA_SOURCE = [ADLG2_PSA],LOCATION = N'delta/ICONI/vBICommon_Agency/IsCurrent=true',FILE_FORMAT = [parquet_file_format],REJECT_TYPE = VALUE,REJECT_VALUE = 0)
GO

