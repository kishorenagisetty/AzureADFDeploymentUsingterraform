CREATE TABLE [DV].[LINK_Case_Participant] (
    [Case_ParticipantHash] BINARY (32)   NULL,
    [CaseHash]             BINARY (32)   NULL,
    [ParticipantHash]      BINARY (32)   NULL,
    [RecordSource]         VARCHAR (50)  NULL,
    [ValidFrom]            DATETIME2 (0) NULL
)
WITH (HEAP, DISTRIBUTION=HASH([Case_ParticipantHash]) ) 
GO


