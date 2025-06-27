CREATE TABLE [DV].[LINK_Referral_Participant] (
    [Referral_ParticipantHash] BINARY (32)   NULL,
    [ReferralHash]             BINARY (32)   NULL,
    [ParticipantHash]          BINARY (32)   NULL,
    [RecordSource]             VARCHAR (50)  NULL,
    [ValidFrom]                DATETIME2 (0) NULL
)
WITH (HEAP, DISTRIBUTION=HASH([Referral_ParticipantHash]) ) 
GO

