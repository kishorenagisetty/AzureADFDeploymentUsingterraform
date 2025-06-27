CREATE EXTERNAL TABLE [DELTA].[ICONI_vBIRestart_AssessmentValue]
(
	[assessment_value_id] [int] NULL,
	[av_assessment_id] [int] NULL,
	[av_code] [nvarchar](max) NULL,
	[av_value] [int] NULL,
	[av_value_string] [nvarchar](max) NULL,
	[av_last_updated_date] [datetime2](0) NULL,
	[av_notes] [nvarchar](max) NULL,
	[ValidFrom] [datetime2](0) NULL,
	[ValidTo] [datetime2](0) NULL,
	[row_sha2] [nvarchar](max) NULL
)
WITH (DATA_SOURCE = [ADLG2_PSA],LOCATION = N'delta/ICONI/vBIRestart_AssessmentValue/IsCurrent=true',FILE_FORMAT = [parquet_file_format],REJECT_TYPE = VALUE,REJECT_VALUE = 0)
GO

