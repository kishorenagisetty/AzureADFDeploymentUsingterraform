CREATE TABLE [DV].[SAT_ReferralDocument_Adapt_Core] (
    [ReferralDocumentHash] BINARY (32)    NULL,
    [ReferralDocumentKey]  NVARCHAR (100) NULL,
    [DocumentName]         NVARCHAR (MAX) NULL,
    [DocumentStatus]       BIGINT         NULL,
    [ContentHash]          BINARY (32)    NULL,
    [ValidFrom]            DATETIME2 (0)  NULL,
    [ValidTo]              DATETIME2 (0)  NULL,
    [IsCurrent]            BIT            NULL
)
WITH (HEAP, DISTRIBUTION = HASH([ReferralDocumentHash]));

