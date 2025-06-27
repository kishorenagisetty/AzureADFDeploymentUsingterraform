CREATE TABLE [DV].[LINK_Case_Document] (
    [Case_DocumentHash] BINARY (32)   NULL,
    [CaseHash]          BINARY (32)   NULL,
    [DocumentHash]      BINARY (32)   NULL,
    [RecordSource]      VARCHAR (50)  NULL,
    [ValidFrom]         DATETIME2 (0) NULL
)
WITH (HEAP, DISTRIBUTION=HASH([Case_DocumentHash]) ) 
GO
