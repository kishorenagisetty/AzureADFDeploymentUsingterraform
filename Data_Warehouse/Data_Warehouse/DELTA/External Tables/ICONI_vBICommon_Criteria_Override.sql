CREATE EXTERNAL TABLE [DELTA].[ICONI_vBICommon_Criteria_Override]
(
	[criteria_override_id] [INT] NULL,
	[co_criteria_definition_id] [INT] NULL,
	[co_entity_id] [INT] NULL,
	[co_entity_type] [NVARCHAR](MAX) NULL,
	[co_reason] [NVARCHAR](MAX) NULL,
	[co_added_by_user_id] [INT] NULL,
	[co_active_to_date] [DATE] NULL,
	[co_added_date] [DATETIME2](0) NULL,
	[ValidFrom] [DATETIME2](0) NULL,
	[ValidTo] [DATETIME2](0) NULL,
	[row_sha2] [NVARCHAR](MAX) NULL
)
WITH (DATA_SOURCE = [ADLG2_PSA],LOCATION = N'delta/ICONI/vBICommon_Criteria_Override/IsCurrent=true',FILE_FORMAT = [parquet_file_format],REJECT_TYPE = VALUE,REJECT_VALUE = 0)
GO

