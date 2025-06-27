CREATE EXTERNAL TABLE [DELTA].[ICONI_vBICommon_Outcome_Earnings]
(
	[outcome_earnings_id] [INT] NULL,
	[out_earn_entity_id] [INT] NULL,
	[out_earn_salary_amount] [DECIMAL](19, 4) NULL,
	[out_earn_salary_unit] [NVARCHAR](MAX) NULL,
	[out_earn_hours_per_week] [DECIMAL](19, 2) NULL,
	[out_earn_date_from] [DATE] NULL,
	[out_earn_date_to] [DATE] NULL,
	[out_earn_notes] [NVARCHAR](MAX) NULL,
	[out_earn_updated_by_user_id] [INT] NULL,
	[out_earn_updated_date] [DATETIME2](0) NULL,
	[out_earn_days_per_week] [NVARCHAR](MAX) NULL,
	[ValidFrom] [DATETIME2](0) NULL,
	[ValidTo] [DATETIME2](0) NULL,
	[row_sha2] [NVARCHAR](MAX) NULL
)
WITH (DATA_SOURCE = [ADLG2_PSA],LOCATION = N'delta/ICONI/vBICommon_Outcome_Earnings/IsCurrent=true',FILE_FORMAT = [parquet_file_format],REJECT_TYPE = VALUE,REJECT_VALUE = 0)
GO

