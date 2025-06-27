CREATE EXTERNAL TABLE [DELTA].[ICONI_vBICommon_Portal_Message]
(
	[portal_message_id] [INT] NULL,
	[pom_related_engagement_id] [INT] NULL,
	[pom_related_individual_id] [INT] NULL,
	[pom_content] [NVARCHAR](MAX) NULL,
	[pom_recorded_by] [NVARCHAR](MAX) NULL,
	[pom_read_receipt] [BIT] NULL,
	[pom_sent_by_user_id] [INT] NULL,
	[pom_sent_date] [DATETIME2](0) NULL,
	[ValidFrom] [DATETIME2](0) NULL,
	[ValidTo] [DATETIME2](0) NULL,
	[row_sha2] [NVARCHAR](MAX) NULL
)
WITH (DATA_SOURCE = [ADLG2_PSA],LOCATION = N'delta/ICONI/vBICommon_Portal_Message/IsCurrent=true',FILE_FORMAT = [parquet_file_format],REJECT_TYPE = VALUE,REJECT_VALUE = 0)
GO

