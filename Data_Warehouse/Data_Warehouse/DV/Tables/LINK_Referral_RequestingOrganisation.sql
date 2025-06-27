CREATE TABLE [DV].[LINK_Referral_RequestingOrganisation] (
    [Referral_RequestingOrganisationHash] BINARY (32)   NULL,
    [ReferralHash]                        BINARY (32)   NULL,
    [RequestingOrganisationHash]          BINARY (32)   NULL,
    [RecordSource]                        VARCHAR (50)  NULL,
    [ValidFrom]                           DATETIME2 (0) NULL
)
WITH (HEAP, DISTRIBUTION=HASH([Referral_RequestingOrganisationHash]) ) ;




