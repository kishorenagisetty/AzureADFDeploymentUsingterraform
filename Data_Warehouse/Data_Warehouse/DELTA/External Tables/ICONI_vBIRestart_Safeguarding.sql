CREATE EXTERNAL TABLE [DELTA].[ICONI_vBIRestart_Safeguarding]
(
	[safeguarding_id] [int] NULL,
	[sg_date] [datetime2](0) NULL,
	[sg_engagement_id] [int] NULL,
	[sg_type] [nvarchar](max) NULL,
	[sg_advisor_user_id] [int] NULL,
	[sg_status] [nvarchar](max) NULL,
	[sg_rejection_reason] [nvarchar](max) NULL,
	[sg_added_date] [datetime2](0) NULL,
	[sg_added_by_user_id] [int] NULL,
	[sg_completed_date] [datetime2](0) NULL,
	[sg_complete_by_user_id] [int] NULL,
	[sg_last_updated_date] [datetime2](0) NULL,
	[ValidFrom] [datetime2](0) NULL,
	[ValidTo] [datetime2](0) NULL,
	[row_sha2] [nvarchar](max) NULL
)
WITH (DATA_SOURCE = [ADLG2_PSA],LOCATION = N'delta/ICONI/vBIRestart_Safeguarding/IsCurrent=true',FILE_FORMAT = [parquet_file_format],REJECT_TYPE = VALUE,REJECT_VALUE = 0)
GO