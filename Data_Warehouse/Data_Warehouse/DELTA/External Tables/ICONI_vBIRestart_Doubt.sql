CREATE EXTERNAL TABLE [DELTA].[ICONI_vBIRestart_Doubt]
(
	[doubt_id] [int] NULL,
	[doubt_raised_by_user_id] [int] NULL,
	[doubt_raised_by_display] [nvarchar](max) NULL,
	[doubt_raised_by_other] [nvarchar](max) NULL,
	[doubt_tran_date] [datetime2](0) NULL,
	[doubt_tran_status_1] [nvarchar](max) NULL,
	[doubt_tran_added_by_user_id] [int] NULL,
	[doubt_tran_added_by_display] [nvarchar](max) NULL,
	[doubt_tran_added_date] [datetime2](0) NULL,
	[doubt_tran_engagement_id] [int] NULL,
	[doubt_tran_individual_id] [int] NULL,
	[doubt_tran_notes] [nvarchar](max) NULL,
	[doubt_tran_last_updated_date] [datetime2](0) NULL,
	[doubt_tran_type_1] [nvarchar](max) NULL,
	[ValidFrom] [datetime2](0) NULL,
	[ValidTo] [datetime2](0) NULL,
	[row_sha2] [nvarchar](max) NULL
)
WITH (DATA_SOURCE = [ADLG2_PSA],LOCATION = N'delta/ICONI/vBIRestart_Doubt/IsCurrent=true',FILE_FORMAT = [parquet_file_format],REJECT_TYPE = VALUE,REJECT_VALUE = 0)
GO

