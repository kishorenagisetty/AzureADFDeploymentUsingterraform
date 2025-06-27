CREATE TABLE [DV].[SAT_Participant_Adapt_Address] (
    [ParticipantHash] BINARY (32)    NULL,
    [ParticipantKey]  NVARCHAR (100) NULL,
    [AddressLine1]    NVARCHAR (MAX) NULL,
    [AddressLine2]    NVARCHAR (MAX) NULL,
    [Locality]        NVARCHAR (MAX) NULL,
    [Town]            NVARCHAR (MAX) NULL,
    [County]          NVARCHAR (MAX) NULL,
    [PostCode]        NVARCHAR (MAX) NULL,
    [PostCodeSector]  INT            NULL,
    [ContentHash]     BINARY (32)    NULL,
    [ValidFrom]       DATETIME2 (0)  NULL,
    [ValidTo]         DATETIME2 (0)  NULL,
    [IsCurrent]       BIT            NULL
)
WITH (HEAP, DISTRIBUTION = HASH([ParticipantHash]));

