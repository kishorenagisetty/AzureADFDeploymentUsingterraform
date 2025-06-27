CREATE EXTERNAL TABLE [DELTA].[ADAPT_vw_zSysUsers]
(
	[UserID] [bigint] NULL,
	[FullName] [nvarchar](max) NULL,
	[UserName] [nvarchar](max) NULL,
	[Initials] [nvarchar](max) NULL,
	[Status] [nvarchar](max) NULL,
	[EmailAddress] [nvarchar](max) NULL,
	[UserType] [int] NULL,
	[CanConfig] [nvarchar](max) NULL,
	[ADUserName] [nvarchar](max) NULL,
	[PasswordChangeDate] [datetime2](0) NULL,
	[EmployeeReferenceID] [decimal](16, 0) NULL,
	[ValidFrom] [datetime2](0) NULL,
	[ValidTo] [datetime2](0) NULL,
	[row_sha2] [nvarchar](max) NULL
)
WITH (DATA_SOURCE = [ADLG2_PSA],LOCATION = N'delta/ADAPT/vw_zSysUsers/IsCurrent=true',FILE_FORMAT = [parquet_file_format],REJECT_TYPE = VALUE,REJECT_VALUE = 0)
GO