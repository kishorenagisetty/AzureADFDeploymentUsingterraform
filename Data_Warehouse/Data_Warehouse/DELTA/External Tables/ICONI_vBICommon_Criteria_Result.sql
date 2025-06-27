CREATE EXTERNAL TABLE [DELTA].[ICONI_vBICommon_Criteria_Result]
(
	[criteria_result_id] [INT] NULL,
	[cr_criteria_definition_id] [INT] NULL,
	[cr_entity_id] [INT] NULL,
	[cr_added_date] [DATETIME2](0) NULL,
	[cr_entity_type] [NVARCHAR](MAX) NULL,
	[cr_type] [NVARCHAR](MAX) NULL,
	[cr_status] [NVARCHAR](MAX) NULL,
	[ValidFrom] [DATETIME2](0) NULL,
	[ValidTo] [DATETIME2](0) NULL,
	[row_sha2] [NVARCHAR](MAX) NULL
)
WITH (DATA_SOURCE = [ADLG2_PSA],LOCATION = N'delta/ICONI/vBICommon_Criteria_Result/IsCurrent=true',FILE_FORMAT = [parquet_file_format],REJECT_TYPE = VALUE,REJECT_VALUE = 0)
GO

