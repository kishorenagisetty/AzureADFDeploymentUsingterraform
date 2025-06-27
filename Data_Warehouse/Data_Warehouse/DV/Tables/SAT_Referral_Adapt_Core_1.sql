CREATE TABLE [DV].[SAT_Referral_Adapt_Core] (
    [ReferralHash]       BINARY (32)    NULL,
    [ReferralKey]        NVARCHAR (100) NULL,
    [PONumber]           NVARCHAR (MAX) NULL,
    [PODescription]      NVARCHAR (MAX) NULL,
    [ReferralDate]       DATETIME2 (0)  NULL,
    [ReferralType]       BIGINT         NULL,
    [Disability]         BIGINT         NULL,
    [FastTrack]          NVARCHAR (MAX) NULL,
    [Incident]           INT            NULL,
    [WelshSpoken]        INT            NULL,
    [WelshWritten]       INT            NULL,
    [ReferringWorkCoach] NVARCHAR (MAX) NULL,
    [ReferringJCP]       NVARCHAR (MAX) NULL,
    [ContentHash]        BINARY (32)    NULL,
    [ValidFrom]          DATETIME2 (0)  NULL,
    [ValidTo]            DATETIME2 (0)  NULL,
    [IsCurrent]          BIT            NULL
)
WITH (HEAP, DISTRIBUTION = HASH([ReferralHash]));



