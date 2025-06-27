CREATE EXTERNAL TABLE [DELTA].[ICONI_vBICommon_Document]
(
	[document_id] [INT] NULL,
	[rf_filename] [NVARCHAR](MAX) NULL,
	[rf_version] [INT] NULL,
	[rf_entity_id] [INT] NULL,
	[rf_entity_type] [NVARCHAR](MAX) NULL,
	[rf_type] [NVARCHAR](MAX) NULL,
	[rf_notes] [NVARCHAR](MAX) NULL,
	[rf_added_date] [DATETIME2](0) NULL,
	[rf_added_by_user_id] [INT] NULL,
	[rf_file_size] [INT] NULL,
	[ValidFrom] [DATETIME2](0) NULL,
	[ValidTo] [DATETIME2](0) NULL,
	[row_sha2] [NVARCHAR](MAX) NULL
)
WITH (DATA_SOURCE = [ADLG2_PSA],LOCATION = N'delta/ICONI/vBICommon_Document/IsCurrent=true',FILE_FORMAT = [parquet_file_format],REJECT_TYPE = VALUE,REJECT_VALUE = 0)
GO