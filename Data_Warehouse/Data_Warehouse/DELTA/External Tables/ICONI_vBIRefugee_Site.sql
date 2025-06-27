CREATE EXTERNAL TABLE [DELTA].[ICONI_vBIRefugee_Site]
(
	[site_id] [int] NULL,
	[site_name] [nvarchar](max) NULL,
	[site_type] [nvarchar](max) NULL,
	[site_admin_contact_details_id] [int] NULL,
	[site_agency_id] [int] NULL,
	[site_parent_site_id] [int] NULL,
	[site_group] [nvarchar](max) NULL,
	[site_added_date] [datetime2](0) NULL,
	[site_last_updated_date] [datetime2](0) NULL,
	[ValidFrom] [datetime2](0) NULL,
	[ValidTo] [datetime2](0) NULL,
	[row_sha2] [nvarchar](max) NULL
)
WITH (DATA_SOURCE = [ADLG2_PSA],LOCATION = N'delta/ICONI/vBIRefugee_Site/IsCurrent=true',FILE_FORMAT = [parquet_file_format],REJECT_TYPE = VALUE,REJECT_VALUE = 0)
GO

