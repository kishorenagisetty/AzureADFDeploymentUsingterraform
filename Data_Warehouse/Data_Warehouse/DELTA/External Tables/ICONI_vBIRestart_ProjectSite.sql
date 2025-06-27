CREATE EXTERNAL TABLE [DELTA].[ICONI_vBIRestart_ProjectSite]
(
	[project_site_id] [int] NULL,
	[ps_site_id] [int] NULL,
	[ps_site_name] [nvarchar](max) NULL,
	[ps_parent_agency_id] [int] NULL,
	[ps_parent_agency_name] [nvarchar](max) NULL,
	[ps_contract_area] [nvarchar](max) NULL,
	[ps_area] [nvarchar](max) NULL,
	[ValidFrom] [datetime2](0) NULL,
	[ValidTo] [datetime2](0) NULL,
	[row_sha2] [nvarchar](max) NULL
)
WITH (DATA_SOURCE = [ADLG2_PSA],LOCATION = N'delta/ICONI/vBIRestart_ProjectSite/IsCurrent=true',FILE_FORMAT = [parquet_file_format],REJECT_TYPE = VALUE,REJECT_VALUE = 0)
GO

 
