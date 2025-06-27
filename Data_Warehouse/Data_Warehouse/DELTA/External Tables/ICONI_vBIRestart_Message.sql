CREATE EXTERNAL TABLE [DELTA].[ICONI_vBIRestart_Message]
(
	[message_id] [int] NULL,
	[msg_destination] [nvarchar](max) NULL,
	[msg_from] [nvarchar](max) NULL,
	[msg_communication_type] [nvarchar](max) NULL,
	[msg_type] [nvarchar](max) NULL,
	[msg_subject] [nvarchar](max) NULL,
	[msg_related_entity_id] [int] NULL,
	[msg_content] [nvarchar](max) NULL,
	[msg_delivery_status] [nvarchar](max) NULL,
	[msg_sent_date] [datetime2](0) NULL,
	[msg_added_by_user_id] [int] NULL,
	[msg_added_by_display] [nvarchar](max) NULL,
	[msg_added_date] [datetime2](0) NULL,
	[msg_last_updated_date] [datetime2](0) NULL,
	[ValidFrom] [datetime2](0) NULL,
	[ValidTo] [datetime2](0) NULL,
	[row_sha2] [nvarchar](max) NULL
)
WITH (DATA_SOURCE = [ADLG2_PSA],LOCATION = N'delta/ICONI/vBIRestart_Message/IsCurrent=true',FILE_FORMAT = [parquet_file_format],REJECT_TYPE = VALUE,REJECT_VALUE = 0)
GO