CREATE TABLE [DV].[SAT_Participant_Adapt_Contact_Telephone] (
    [ParticipantHash] BINARY (32)    NULL,
    [ParticipantKey]  NVARCHAR (100) NULL,
    [TelephoneHome]   NVARCHAR (MAX) NULL,
    [TelephoneMobile] NVARCHAR (MAX) NULL,
    [TelephoneWork]   NVARCHAR (MAX) NULL,
    [ContentHash]     BINARY (32)    NULL,
    [ValidFrom]       DATETIME2 (0)  NULL,
    [ValidTo]         DATETIME2 (0)  NULL,
    [IsCurrent]       BIT            NULL
)
WITH (HEAP, DISTRIBUTION = HASH([ParticipantHash]));

