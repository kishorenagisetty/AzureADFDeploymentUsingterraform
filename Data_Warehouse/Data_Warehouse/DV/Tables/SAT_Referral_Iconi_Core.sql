CREATE TABLE [DV].[SAT_Referral_Iconi_Core] (
    [ReferralHash]        BINARY (32)    NULL,
    [ReferralKey]         NVARCHAR (100) NULL,
    [PONumber]            NVARCHAR (MAX) NULL,
    [PODescription]       NVARCHAR (MAX) NULL,
    [ReferralDate]        DATETIME2 (0)  NULL,
    [ReferralType]        NVARCHAR (MAX) NULL,
    [ReferralSourceOther] NVARCHAR (MAX) NULL,
    [Disability]          NVARCHAR (MAX) NULL,
    [ContentHash]         BINARY (32)    NULL,
    [ValidFrom]           DATETIME2 (0)  NULL,
    [ValidTo]             DATETIME2 (0)  NULL,
    [IsCurrent]           BIT            NULL
)
WITH (HEAP, DISTRIBUTION = HASH([ReferralHash]));
GO

