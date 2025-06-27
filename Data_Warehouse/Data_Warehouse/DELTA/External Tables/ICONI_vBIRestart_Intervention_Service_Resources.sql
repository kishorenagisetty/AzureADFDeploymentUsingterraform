CREATE EXTERNAL TABLE [DELTA].[ICONI_vBIRestart_Intervention_Service_Resources]
(
	[intervention_service_resource_id] [int] NULL,
	[iscr_intervention_service_id] [int] NULL,
	[iscr_resource_id] [nvarchar](max) NULL,
	[iscr_added] [datetime2](0) NULL,
	[iscr_resource_title] [nvarchar](max) NULL,
	[iscr_status] [nvarchar](max) NULL,
	[ValidFrom] [datetime2](0) NULL,
	[ValidTo] [datetime2](0) NULL,
	[row_sha2] [nvarchar](max) NULL
)
WITH (DATA_SOURCE = [ADLG2_PSA],LOCATION = N'delta/ICONI/vBIRestart_Intervention_Service_Resources/IsCurrent=true',FILE_FORMAT = [parquet_file_format],REJECT_TYPE = VALUE,REJECT_VALUE = 0)
GO