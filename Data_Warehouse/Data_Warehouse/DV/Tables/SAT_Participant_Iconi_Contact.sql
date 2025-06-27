CREATE TABLE [DV].[SAT_Participant_Iconi_Contact] (
    [ParticipantHash]              BINARY (32)    NULL,
    [ParticipantKey]               NVARCHAR (100) NULL,
    [TelephoneHome]                NVARCHAR (MAX) NULL,
    [TelephoneMobile]              NVARCHAR (MAX) NULL,
    [Email]                        NVARCHAR (MAX) NULL,
    [SMSOptOut]                    BIT            NULL,
    [EmailOptOut]                  BIT            NULL,
    [LeaveMessage]                 BIT            NULL,
    [PreferredCommunicationMethod] NVARCHAR (MAX) NULL,
    [ContentHash]                  BINARY (32)    NULL,
    [ValidFrom]                    DATETIME2 (0)  NULL,
    [ValidTo]                      DATETIME2 (0)  NULL,
    [IsCurrent]                    BIT            NULL
)
WITH (HEAP, DISTRIBUTION = HASH([ParticipantHash]));
GO

