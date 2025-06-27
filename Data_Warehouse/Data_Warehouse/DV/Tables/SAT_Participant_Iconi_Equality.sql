CREATE TABLE [DV].[SAT_Participant_Iconi_Equality] (
    [ParticipantHash]        BINARY (32)    NULL,
    [ParticipantKey]         NVARCHAR (100) NULL,
    [Gender]                 NVARCHAR (MAX) NULL,
    [Religion]               NVARCHAR (MAX) NULL,
    [Ethnicity]              NVARCHAR (MAX) NULL,
    [AgeAtRecordCreation]    INT            NULL,
    [EligibilityStatus]      NVARCHAR (MAX) NULL,
    [ReasonableAdjustments]  NVARCHAR (MAX) NULL,
    [ParticipantAddedDate]   DATETIME2 (0)  NULL,
    [ParticipantAddedBy]     INT            NULL,
    [ParticipantUpdatedDate] DATETIME2 (0)  NULL,
    [ContentHash]            BINARY (32)    NULL,
    [ValidFrom]              DATETIME2 (0)  NULL,
    [ValidTo]                DATETIME2 (0)  NULL,
    [IsCurrent]              BIT            NULL
)
WITH (HEAP, DISTRIBUTION = HASH([ParticipantHash]));
GO

