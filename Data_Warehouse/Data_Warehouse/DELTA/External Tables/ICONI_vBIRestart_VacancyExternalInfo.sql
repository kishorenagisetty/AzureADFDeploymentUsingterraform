CREATE EXTERNAL TABLE [DELTA].[ICONI_vBIRestart_VacancyExternalInfo]
(
	[vacancy_external_info_id] [int] NULL,
	[vei_external_id] [bigint] NULL,
	[vei_title] [nvarchar](max) NULL,
	[vei_description] [nvarchar](max) NULL,
	[vei_company] [nvarchar](max) NULL,
	[vei_location] [nvarchar](max) NULL,
	[vei_salary_min] [nvarchar](max) NULL,
	[vei_salary_max] [nvarchar](max) NULL,
	[vei_salary_predicted] [nvarchar](max) NULL,
	[vei_contract_type] [nvarchar](max) NULL,
	[vei_contract_time] [nvarchar](max) NULL,
	[vei_redirect_url] [nvarchar](max) NULL,
	[vei_category] [nvarchar](max) NULL,
	[vei_created_date] [nvarchar](max) NULL,
	[ValidFrom] [datetime2](0) NULL,
	[ValidTo] [datetime2](0) NULL,
	[row_sha2] [nvarchar](max) NULL
)
WITH (DATA_SOURCE = [ADLG2_PSA],LOCATION = N'delta/ICONI/vBIRestart_VacancyExternalInfo/IsCurrent=true',FILE_FORMAT = [parquet_file_format],REJECT_TYPE = VALUE,REJECT_VALUE = 0)
GO