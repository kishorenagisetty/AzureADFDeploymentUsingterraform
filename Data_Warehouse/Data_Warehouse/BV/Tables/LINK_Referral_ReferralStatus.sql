CREATE TABLE [BV].[LINK_Referral_ReferralStatus] (
    [Referral_ReferralStatusHash] BINARY (32)      NULL,
    [ReferralHash]                BINARY (32)      NULL,
    [ReferralStatusHash]          VARBINARY (8000) NULL,
    [RecordSource]                VARCHAR (24)     NOT NULL,
    [ValidFrom]                   DATETIME         NOT NULL
)
WITH (HEAP, DISTRIBUTION = HASH([ReferralHash]));

