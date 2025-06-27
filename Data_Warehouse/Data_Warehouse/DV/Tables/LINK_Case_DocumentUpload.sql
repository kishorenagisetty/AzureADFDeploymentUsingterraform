CREATE TABLE [DV].[LINK_Case_DocumentUpload] (
    [Case_DocumentUploadHash] BINARY (32)   NULL,
    [CaseHash]                BINARY (32)   NULL,
    [DocumentUploadHash]      BINARY (32)   NULL,
    [RecordSource]            VARCHAR (50)  NULL,
    [ValidFrom]               DATETIME2 (0) NULL
)
WITH (HEAP, DISTRIBUTION=HASH([Case_DocumentUploadHash]));


GO

