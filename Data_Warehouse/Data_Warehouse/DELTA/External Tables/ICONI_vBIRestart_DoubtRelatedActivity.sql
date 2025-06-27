CREATE EXTERNAL TABLE [DELTA].[ICONI_vBIRestart_DoubtRelatedActivity]
(
	[doubt_related_activity_id] [int] NULL,
	[dra_entity_type] [nvarchar](max) NULL,
	[dra_entity_id] [int] NULL,
	[dra_doubt_id] [int] NULL,
	[dra_tran_last_updated_date] [datetime2](0) NULL,
	[dra_added_by_user_id] [int] NULL,
	[dra_added_date] [datetime2](0) NULL,
	[ValidFrom] [datetime2](0) NULL,
	[ValidTo] [datetime2](0) NULL,
	[row_sha2] [nvarchar](max) NULL
)
WITH (DATA_SOURCE = [ADLG2_PSA],LOCATION = N'delta/ICONI/vBIRestart_DoubtRelatedActivity/IsCurrent=true',FILE_FORMAT = [parquet_file_format],REJECT_TYPE = VALUE,REJECT_VALUE = 0)
GO