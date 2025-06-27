--12/09/2023-SK-27410
CREATE EXTERNAL TABLE [Ext].[CSS_Catalogue]
(
	[CSS_ContractRefNo] [nvarchar](10) NULL,
	[ProgrammeName] [nvarchar](500) NULL,
	[CSSName] [nvarchar](500) NULL,
	[DWP_Description] [nvarchar](1000) NULL,
	[DWP_DueDate] [nvarchar](1000) NULL,
	[DWP_SuccessCriteria] [nvarchar](1000) NULL,
	[DWP_HowManyRecords] [nvarchar](1000) NULL,
	[DWP_HowManyRecordsExempt] [nvarchar](1000) NULL,
	[DWP_HowManyRecordsNotes] [nvarchar](1000) NULL,
	[CSS_SortOrder] [int] NULL
)
WITH (DATA_SOURCE  = [ADLG2_PSA]
	 ,LOCATION     = N'WorkflowEvents/CSS_Catalogue.csv'
	 ,FILE_FORMAT  = [PipeFileFormat]
	 ,REJECT_TYPE  = VALUE
	 ,REJECT_VALUE = 0
	 );
GO