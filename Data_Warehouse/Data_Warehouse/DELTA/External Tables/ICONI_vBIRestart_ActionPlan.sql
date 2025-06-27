CREATE EXTERNAL TABLE [DELTA].[ICONI_vBIRestart_ActionPlan]
(
	[ap_id] [INT] NULL,
	[ap_entity_id] [INT] NULL,
	[ap_entity_type] [NVARCHAR](MAX) NULL,
	[ap_ind_id] [INT] NULL,
	[ap_status] [NVARCHAR](MAX) NULL,
	[ap_signature_method] [NVARCHAR](MAX) NULL,
	[ap_advisor_telephone_number] [NVARCHAR](MAX) NULL,
	[ap_sources_of_support] [NVARCHAR](MAX) NULL,
	[ap_general_activities] [NVARCHAR](MAX) NULL,
	[ap_exception_raised] [BIT] NULL,
	[ap_exception_type] [NVARCHAR](MAX) NULL,
	[ap_exception_statement] [NVARCHAR](MAX) NULL,
	[ap_agency_id] [INT] NULL,
	[ap_site_id] [INT] NULL,
	[ap_signed_date] [DATETIME2](0) NULL,
	[ap_record_locked] [BIT] NULL,
	[ap_added_by] [INT] NULL,
	[ap_added_date] [DATETIME2](0) NULL,
	[ap_last_updated_date] [DATETIME2](0) NULL,
	[ValidFrom] [DATETIME2](0) NULL,
	[ValidTo] [DATETIME2](0) NULL,
	[row_sha2] [NVARCHAR](MAX) NULL
)
WITH (DATA_SOURCE = [ADLG2_PSA],LOCATION = N'delta/ICONI/vBIRestart_ActionPlan/IsCurrent=true',FILE_FORMAT = [parquet_file_format],REJECT_TYPE = VALUE,REJECT_VALUE = 0)
GO