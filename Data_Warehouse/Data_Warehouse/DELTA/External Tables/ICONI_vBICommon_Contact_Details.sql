CREATE EXTERNAL TABLE [DELTA].[ICONI_vBICommon_Contact_Details]
(
	[contact_details_id] [INT] NULL,
	[cd_entity_id] [INT] NULL,
	[cd_type] [NVARCHAR](MAX) NULL,
	[cd_address_1] [NVARCHAR](MAX) NULL,
	[cd_address_2] [NVARCHAR](MAX) NULL,
	[cd_address_3] [NVARCHAR](MAX) NULL,
	[cd_town] [NVARCHAR](MAX) NULL,
	[cd_postcode] [NVARCHAR](MAX) NULL,
	[cd_county] [NVARCHAR](MAX) NULL,
	[cd_tel_no] [NVARCHAR](MAX) NULL,
	[cd_mob_no] [NVARCHAR](MAX) NULL,
	[cd_fax_no] [NVARCHAR](MAX) NULL,
	[cd_email] [NVARCHAR](MAX) NULL,
	[cd_web_address] [NVARCHAR](MAX) NULL,
	[cd_added_by_user_id] [INT] NULL,
	[cd_added_date] [DATETIME2](0) NULL,
	[cd_archive] [BIT] NULL,
	[ValidFrom] [DATETIME2](0) NULL,
	[ValidTo] [DATETIME2](0) NULL,
	[row_sha2] [NVARCHAR](MAX) NULL
)
WITH (DATA_SOURCE = [ADLG2_PSA],LOCATION = N'delta/ICONI/vBICommon_Contact_Details/IsCurrent=true',FILE_FORMAT = [parquet_file_format],REJECT_TYPE = VALUE,REJECT_VALUE = 0)
GO

