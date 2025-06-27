CREATE TABLE [DV].[LINK_Case_Referral] (
    [Case_ReferralHash] BINARY (32)   NULL,
    [CaseHash]          BINARY (32)   NULL,
    [ReferralHash]      BINARY (32)   NULL,
    [RecordSource]      VARCHAR (50)  NULL,
    [ValidFrom]         DATETIME2 (0) NULL
)
WITH (HEAP, DISTRIBUTION=HASH([Case_ReferralHash]) ) 
GO


