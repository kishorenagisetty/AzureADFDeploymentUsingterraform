CREATE TABLE [DV].[HUB_Referral] (
    [ReferralHash] BINARY (32)    NULL,
    [ReferralKey]  NVARCHAR (100) NULL,
    [RecordSource] VARCHAR (50)   NULL,
    [ValidFrom]    DATETIME2 (0)  NULL
)
WITH (HEAP, DISTRIBUTION = HASH([ReferralHash]));

