CREATE EXTERNAL TABLE [DELTA].[ICONI_vBICommon_Organisation_Employer_Info]
(
	[organisation_employer_info_id] [INT] NULL,
	[org_emp_info_organisation_id] [INT] NULL,
	[org_emp_info_contact] [NVARCHAR](MAX) NULL,
	[org_emp_info_managing_erm] [NVARCHAR](MAX) NULL,
	[org_emp_info_locations] [NVARCHAR](MAX) NULL,
	[org_emp_info_relationships] [NVARCHAR](MAX) NULL,
	[org_emp_info_notes] [NVARCHAR](MAX) NULL,
	[org_emp_info_added_by_user_id] [INT] NULL,
	[org_emp_info_added_by_display] [NVARCHAR](MAX) NULL,
	[org_emp_info_added_date] [NVARCHAR](MAX) NULL,
	[ValidFrom] [DATETIME2](0) NULL,
	[ValidTo] [DATETIME2](0) NULL,
	[row_sha2] [NVARCHAR](MAX) NULL
)
WITH (DATA_SOURCE = [ADLG2_PSA],LOCATION = N'delta/ICONI/vBICommon_Organisation_Employer_Info/IsCurrent=true',FILE_FORMAT = [parquet_file_format],REJECT_TYPE = VALUE,REJECT_VALUE = 0)
GO

