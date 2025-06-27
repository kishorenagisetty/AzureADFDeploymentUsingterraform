CREATE TABLE [DV].[LINK_Referral_Programme] (
    [Referral_ProgrammeHash] BINARY (32)   NULL,
    [ReferralHash]           BINARY (32)   NULL,
    [ProgrammeHash]          BINARY (32)   NULL,
    [RecordSource]           VARCHAR (50)  NULL,
    [ValidFrom]              DATETIME2 (0) NULL
)
WITH (HEAP, DISTRIBUTION=HASH([Referral_ProgrammeHash]) ) 
GO;


