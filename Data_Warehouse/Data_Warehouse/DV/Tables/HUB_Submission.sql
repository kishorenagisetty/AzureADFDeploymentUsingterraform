CREATE TABLE [DV].[HUB_Submission] (
    [SubmissionHash] BINARY (32)    NULL,
    [SubmissionKey]  NVARCHAR (100) NULL,
    [RecordSource]   VARCHAR (50)   NULL,
    [ValidFrom]      DATETIME2 (0)  NULL
)
WITH (HEAP, DISTRIBUTION = HASH([SubmissionHash]));
