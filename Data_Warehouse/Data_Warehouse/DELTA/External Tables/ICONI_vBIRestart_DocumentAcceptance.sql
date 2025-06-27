CREATE EXTERNAL TABLE [DELTA].[ICONI_vBIRestart_DocumentAcceptance]
(
	[da_engagement_id] [int] NULL,
	[da_document_id] [int] NULL,
	[da_sent_to_portal_date] [datetime2](0) NULL,
	[da_portal_accepted_date] [datetime2](0) NULL,
	[ValidFrom] [datetime2](0) NULL,
	[ValidTo] [datetime2](0) NULL,
	[row_sha2] [nvarchar](max) NULL
)
WITH (DATA_SOURCE = [ADLG2_PSA],LOCATION = N'delta/ICONI/vBIRestart_DocumentAcceptance/IsCurrent=true',FILE_FORMAT = [parquet_file_format],REJECT_TYPE = VALUE,REJECT_VALUE = 0)
GO