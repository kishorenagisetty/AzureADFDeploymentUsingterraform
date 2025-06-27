CREATE TABLE [DV].[HUB_ReferralDocument] (
    [ReferralDocumentHash] BINARY (32)    NULL,
    [ReferralDocumentKey]  NVARCHAR (100) NULL,
    [RecordSource]         VARCHAR (50)   NULL,
    [ValidFrom]            DATETIME2 (0)  NULL
)
WITH (HEAP, DISTRIBUTION = HASH([ReferralDocumentHash]));

