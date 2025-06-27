CREATE TABLE [DV].[LINK_Submission_Participant] (
    [Submission_ParticipantHash] BINARY (32)   NULL,
    [SubmissionHash]             BINARY (32)   NULL,
    [ParticipantHash]            BINARY (32)   NULL,
    [RecordSource]               VARCHAR (50)  NULL,
    [ValidFrom]                  DATETIME2 (0) NULL
)
WITH (HEAP, DISTRIBUTION=HASH([Submission_ParticipantHash]) ) ;


