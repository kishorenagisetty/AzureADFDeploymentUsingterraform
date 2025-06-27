CREATE EXTERNAL TABLE [DELTA].[ICONI_vBICommon_Criteria_Definition]
(
	[criteria_definition_id] [INT] NULL,
	[cd_parent_id] [INT] NULL,
	[cd_type] [NVARCHAR](MAX) NULL,
	[cd_project_id] [INT] NULL,
	[cd_title] [NVARCHAR](MAX) NULL,
	[cd_overview_help_text] [NVARCHAR](MAX) NULL,
	[cd_completion_help_text] [NVARCHAR](MAX) NULL,
	[cd_operational_guidance] [NVARCHAR](MAX) NULL,
	[cd_item_sequence] [INT] NULL,
	[cd_required_type] [NVARCHAR](MAX) NULL,
	[cd_override_permission] [NVARCHAR](MAX) NULL,
	[ValidFrom] [DATETIME2](0) NULL,
	[ValidTo] [DATETIME2](0) NULL,
	[row_sha2] [NVARCHAR](MAX) NULL
)
WITH (DATA_SOURCE = [ADLG2_PSA],LOCATION = N'delta/ICONI/vBICommon_Criteria_Definition/IsCurrent=true',FILE_FORMAT = [parquet_file_format],REJECT_TYPE = VALUE,REJECT_VALUE = 0)
GO

