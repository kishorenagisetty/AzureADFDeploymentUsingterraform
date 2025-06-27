CREATE EXTERNAL TABLE [DELTA].[ICONI_vBIRestart_Intervention_Service_Site]
(
	[intervention_service_site_id] [int] NULL,
	[iscs_intervention_service_id] [int] NULL,
	[iscs_site_value] [nvarchar](max) NULL,
	[ValidFrom] [datetime2](0) NULL,
	[ValidTo] [datetime2](0) NULL,
	[row_sha2] [nvarchar](max) NULL
)
WITH (DATA_SOURCE = [ADLG2_PSA],LOCATION = N'delta/ICONI/vBIRestart_Intervention_Service_Site/IsCurrent=true',FILE_FORMAT = [parquet_file_format],REJECT_TYPE = VALUE,REJECT_VALUE = 0)
GO