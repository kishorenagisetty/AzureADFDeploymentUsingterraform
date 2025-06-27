CREATE EXTERNAL TABLE [DELTA].[ICONI_vBICommon_Admin_Contact_Details]
(
	[admin_contact_details_id] [INT] NULL,
	[acd_entity_id] [INT] NULL,
	[acd_type] [NVARCHAR](MAX) NULL,
	[acd_address_1] [NVARCHAR](MAX) NULL,
	[acd_address_2] [NVARCHAR](MAX) NULL,
	[acd_address_3] [NVARCHAR](MAX) NULL,
	[acd_town] [NVARCHAR](MAX) NULL,
	[acd_postcode] [NVARCHAR](MAX) NULL,
	[acd_tel_no] [NVARCHAR](MAX) NULL,
	[acd_mob_no] [NVARCHAR](MAX) NULL,
	[acd_fax_no] [NVARCHAR](MAX) NULL,
	[acd_email] [NVARCHAR](MAX) NULL,
	[acd_web_address] [NVARCHAR](MAX) NULL,
	[acd_added_by_user_id] [INT] NULL,
	[acd_added_date] [DATETIME2](0) NULL,
	[acd_archive] [BIT] NULL,
	[ValidFrom] [DATETIME2](0) NULL,
	[ValidTo] [DATETIME2](0) NULL,
	[row_sha2] [NVARCHAR](MAX) NULL
)
WITH (DATA_SOURCE = [ADLG2_PSA],LOCATION = N'delta/ICONI/vBICommon_Admin_Contact_Details/IsCurrent=true',FILE_FORMAT = [parquet_file_format],REJECT_TYPE = VALUE,REJECT_VALUE = 0)
GO

