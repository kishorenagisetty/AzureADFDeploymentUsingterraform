CREATE TABLE [LZ].[hmrc_Files]
(
	[DATE CREATED] [nvarchar](255) NULL,
	[REFERRAL NUMBER] [nvarchar](255) NULL,
	[NINO] [nvarchar](255) NULL,
	[NOTIFICATION TYPE] [nvarchar](255) NULL,
	[NOTIFICATION DATE] [nvarchar](255) NULL,
	[SOURCE SYSTEM] [nvarchar](255) NULL,
	[SUPPLIER NAME] [nvarchar](255) NULL,
	[SUPPLIER SITE CODE] [nvarchar](255) NULL,
	[CPA] [nvarchar](255) NULL,
	[RECORD STATUS] [nvarchar](255) NULL,
	[ASN CREATION STATUS] [nvarchar](255) NULL,
	[ASN NUMBER] [nvarchar](255) NULL,
	[INVOICE NUMBER] [nvarchar](255) NULL,
	[ValidFrom] [datetime2](0) NULL
)
WITH
(
	DISTRIBUTION = ROUND_ROBIN,
	CLUSTERED COLUMNSTORE INDEX
)
GO
