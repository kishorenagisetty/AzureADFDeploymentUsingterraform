CREATE EXTERNAL TABLE [DELTA].[ICONI_vBIRestart_Correspondence]
(
	[correspondence_id] [int] NULL,
	[cor_date_time] [datetime2](0) NULL,
	[cor_duration] [int] NULL,
	[cor_owner_user_id] [int] NULL,
	[cor_purpose] [nvarchar](max) NULL,
	[cor_purpose_other] [nvarchar](max) NULL,
	[cor_type] [nvarchar](max) NULL,
	[cor_recipient] [nvarchar](max) NULL,
	[cor_recipient_oth] [nvarchar](max) NULL,
	[cor_successful] [nvarchar](max) NULL,
	[cor_notes] [nvarchar](max) NULL,
	[cor_provider_agency_id] [int] NULL,
	[cor_site_id] [int] NULL,
	[cor_related_entity_type] [nvarchar](max) NULL,
	[cor_organisation_id] [int] NULL,
	[cor_individual_id] [int] NULL,
	[cor_engagement_id] [int] NULL,
	[cor_added_date] [datetime2](0) NULL,
	[cor_added_by_user_id] [int] NULL,
	[cor_last_updated_date] [datetime2](0) NULL,
	[cor_id_check] [nvarchar](max) NULL,
	[ValidFrom] [datetime2](0) NULL,
	[ValidTo] [datetime2](0) NULL,
	[row_sha2] [nvarchar](max) NULL
)
WITH (DATA_SOURCE = [ADLG2_PSA],LOCATION = N'delta/ICONI/vBIRestart_Correspondence/IsCurrent=true',FILE_FORMAT = [parquet_file_format],REJECT_TYPE = VALUE,REJECT_VALUE = 0)
GO