CREATE EXTERNAL TABLE [DELTA].[ICONI_vBIRestart_ActionPlanRelatedEntity]
(
	[apre_id] [int] NULL,
	[apre_ap_id] [int] NULL,
	[apre_entity_id] [int] NULL,
	[apre_entity_type] [nvarchar](max) NULL,
	[apre_added_by] [int] NULL,
	[apre_added_date] [datetime2](0) NULL,
	[apre_last_updated] [datetime2](0) NULL,
	[apre_archive] [bit] NULL,
	[ValidFrom] [datetime2](0) NULL,
	[ValidTo] [datetime2](0) NULL,
	[row_sha2] [nvarchar](max) NULL
)
WITH (DATA_SOURCE = [ADLG2_PSA],LOCATION = N'delta/ICONI/vBIRestart_ActionPlanRelatedEntity/IsCurrent=true',FILE_FORMAT = [parquet_file_format],REJECT_TYPE = VALUE,REJECT_VALUE = 0)
GO