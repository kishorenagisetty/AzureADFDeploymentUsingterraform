CREATE TABLE [DV].[HUB_DocumentUpload]
(
	[DocumentUploadHash] [binary](32) NULL,
	[DocumentUploadKey] [nvarchar](100) NULL,
	[RecordSource] [varchar](50) NULL,
	[ValidFrom] [datetime2](0) NULL
)
WITH
(
	DISTRIBUTION = HASH ( [DocumentUploadHash] ),
	HEAP
)
GO