CREATE TABLE [DV].[SAT_Participant_Adapt_Core_CandGen] (
    [ParticipantHash]              BINARY (32)    NULL,
    [ParticipantKey]               NVARCHAR (100) NULL,
    [HasCriminalConviction]        NVARCHAR (MAX) NULL,
    [IsDriver]                     NVARCHAR (MAX) NULL,
    [BetterOffCalculationStatus]   NVARCHAR (MAX) NULL,
    [HasOwnTransport]              NVARCHAR (MAX) NULL,
    [MarketingPermissions]         BIGINT            NULL,
    [HasUpToDateCV]                NVARCHAR (MAX) NULL,
    [PreferredCommunicationMethod] BIGINT         NULL,
    [ContactStatus]                BIGINT            NULL,
    [DOB]                          DATE           NULL,
    [ContentHash]                  BINARY (32)    NULL,
    [ValidFrom]                    DATETIME2 (0)  NULL,
    [ValidTo]                      DATETIME2 (0)  NULL,
    [IsCurrent]                    BIT            NULL
)
WITH (HEAP, DISTRIBUTION = HASH([ParticipantHash]));

