CREATE EXTERNAL TABLE [DELTA].[ICONI_vBIRestart_Barrier]
(
	[engagement_barrier_id] [int] NULL,
	[eb_engagement_id] [int] NULL,
	[eb_barrier] [nvarchar](max) NULL,
	[eb_value] [int] NULL,
	[eb_status] [int] NULL,
	[eb_notes] [nvarchar](max) NULL,
	[eb_added_date] [datetime2](0) NULL,
	[eb_last_updated_date] [datetime2](0) NULL,
	[ValidFrom] [datetime2](0) NULL,
	[ValidTo] [datetime2](0) NULL,
	[row_sha2] [nvarchar](max) NULL
)
WITH (DATA_SOURCE = [ADLG2_PSA],LOCATION = N'delta/ICONI/vBIRestart_Barrier/IsCurrent=true',FILE_FORMAT = [parquet_file_format],REJECT_TYPE = VALUE,REJECT_VALUE = 0)
GO

