CREATE EXTERNAL TABLE [DELTA].[ICONI_vBIRestart_GroupSessionSite]
(
	[group_session_site_id] [int] NULL,
	[gs_group_session_id] [int] NULL,
	[gs_value] [nvarchar](max) NULL,
	[ValidFrom] [datetime2](0) NULL,
	[ValidTo] [datetime2](0) NULL,
	[row_sha2] [nvarchar](max) NULL
)
WITH (DATA_SOURCE = [ADLG2_PSA],LOCATION = N'delta/ICONI/vBIRestart_GroupSessionSite/IsCurrent=true',FILE_FORMAT = [parquet_file_format],REJECT_TYPE = VALUE,REJECT_VALUE = 0)
GO