CREATE TABLE [DV].[SAT_Participant_Iconi_Core] (
    [ParticipantHash]      BINARY (32)    NULL,
    [ParticipantKey]       NVARCHAR (100) NULL,
    [ParticipantID]        VARCHAR (33)   NULL,
    [DateOfBirth]          DATETIME2 (0)  NULL,
    [NationalInsuranceNo]  NVARCHAR (MAX) NULL,
    [Title]                NVARCHAR (MAX) NULL,
    [FirstName]            NVARCHAR (MAX) NULL,
    [LastName]             NVARCHAR (MAX) NULL,
    [SafeguardingConcerns] NVARCHAR (MAX) NULL,
    [ContentHash]          BINARY (32)    NULL,
    [ValidFrom]            DATETIME2 (0)  NULL,
    [ValidTo]              DATETIME2 (0)  NULL,
    [IsCurrent]            BIT            NULL
)
WITH (HEAP, DISTRIBUTION = HASH([ParticipantHash]));
GO

