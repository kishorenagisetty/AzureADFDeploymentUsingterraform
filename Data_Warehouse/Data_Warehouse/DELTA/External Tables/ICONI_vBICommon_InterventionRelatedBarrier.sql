CREATE EXTERNAL TABLE [DELTA].[ICONI_vBICommon_InterventionRelatedBarrier]
(
	[intervention_related_barrier_id] [INT] NULL,
	[rb_entity_id] [INT] NULL,
	[rb_entity_type] [NVARCHAR](MAX) NULL,
	[rb_barrier_id] [NVARCHAR](MAX) NULL,
	[rb_added_by_user_id] [INT] NULL,
	[rb_added_date] [DATETIME2](0) NULL,
	[ValidFrom] [DATETIME2](0) NULL,
	[ValidTo] [DATETIME2](0) NULL,
	[row_sha2] [NVARCHAR](MAX) NULL
)
WITH (DATA_SOURCE = [ADLG2_PSA],LOCATION = N'delta/ICONI/vBICommon_InterventionRelatedBarrier/IsCurrent=true',FILE_FORMAT = [parquet_file_format],REJECT_TYPE = VALUE,REJECT_VALUE = 0)
GO

