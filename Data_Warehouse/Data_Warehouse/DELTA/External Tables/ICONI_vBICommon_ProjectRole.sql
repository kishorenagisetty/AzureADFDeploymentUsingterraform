CREATE EXTERNAL TABLE [DELTA].[ICONI_vBICommon_ProjectRole]
(
	[user_id] [INT] NULL,
	[Project] [NVARCHAR](MAX) NULL,
	[Role] [NVARCHAR](MAX) NULL,
	[ValidFrom] [DATETIME2](0) NULL,
	[ValidTo] [DATETIME2](0) NULL,
	[row_sha2] [NVARCHAR](MAX) NULL
)
WITH (DATA_SOURCE = [ADLG2_PSA],LOCATION = N'delta/ICONI/vBICommon_ProjectRole/IsCurrent=true',FILE_FORMAT = [parquet_file_format],REJECT_TYPE = VALUE,REJECT_VALUE = 0)
GO

