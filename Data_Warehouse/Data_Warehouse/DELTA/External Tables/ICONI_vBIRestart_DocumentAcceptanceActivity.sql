CREATE EXTERNAL TABLE [DELTA].[ICONI_vBIRestart_DocumentAcceptanceActivity]
(
	[daa_id] [int] NULL,
	[daa_engagement_id] [int] NULL,
	[daa_document_id] [int] NULL,
	[daa_action_type] [nvarchar](max) NULL,
	[daa_date] [datetime2](0) NULL,
	[ValidFrom] [datetime2](0) NULL,
	[ValidTo] [datetime2](0) NULL,
	[row_sha2] [nvarchar](max) NULL
)
WITH (DATA_SOURCE = [ADLG2_PSA],LOCATION = N'delta/ICONI/vBIRestart_DocumentAcceptanceActivity/IsCurrent=true',FILE_FORMAT = [parquet_file_format],REJECT_TYPE = VALUE,REJECT_VALUE = 0)
GO