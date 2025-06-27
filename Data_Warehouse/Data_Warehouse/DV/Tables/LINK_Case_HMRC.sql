CREATE TABLE [DV].[LINK_Case_HMRC] (
    [Case_HMRCHash] BINARY (32)   NULL,
    [CaseHash]      BINARY (32)   NULL,
    [HMRCHash]      BINARY (32)   NULL,
    [RecordSource]  VARCHAR (50)  NULL,
    [ValidFrom]     DATETIME2 (0) NULL
)
WITH (HEAP, DISTRIBUTION = HASH([CaseHash]));
GO