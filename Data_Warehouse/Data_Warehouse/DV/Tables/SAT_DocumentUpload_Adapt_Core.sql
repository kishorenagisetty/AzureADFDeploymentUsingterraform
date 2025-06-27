CREATE TABLE [DV].[SAT_DocumentUpload_Adapt_Core]
(
	[DocumentUploadHash] [binary](32) NULL,
	[DocumentUploadKey] [nvarchar](100) NULL,
	[DocumentCategory] [nvarchar](max) NULL,
	[DocumentName] [nvarchar](max) NULL,
	[DocumentDescription] [nvarchar](max) NULL,
	[CreatedDate] [datetime2](0) NULL,
	[UploadedDate] [datetime2](0) NULL,
	[ModifiedDate] [datetime2](0) NULL,
	[ContentHash] [binary](32) NULL,
	[ValidFrom] [datetime2](0) NULL,
	[ValidTo] [datetime2](0) NULL,
	[IsCurrent] [bit] NULL
)
WITH
(
	DISTRIBUTION = HASH ( [DocumentUploadHash] ),
	HEAP
)
GO