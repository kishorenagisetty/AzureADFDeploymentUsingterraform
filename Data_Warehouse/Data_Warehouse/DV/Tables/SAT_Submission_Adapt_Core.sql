CREATE TABLE [DV].[SAT_Submission_Adapt_Core] (
    [SubmissionHash]         BINARY (32)    NULL,
    [SubmissionKey]          NVARCHAR (100) NULL,
    [SubmissionReferenceKey] INT             NULL,
    [CreatedDate]            DATETIME2 (0)  NULL,
    [UpdatedDate]            DATETIME2 (0)  NULL,
    [DeletedDate]            DATETIME2 (0)  NULL,
    [SubmissionStatus]       NVARCHAR (MAX) NULL,
    [ProgrammeName]          NVARCHAR (MAX) NULL,
    [CaseId]                 NVARCHAR (MAX) NULL,
    [ShortListBy]            NVARCHAR (MAX) NULL,
    [DeliverySiteId]         NVARCHAR (MAX) NULL,
    [ContentHash]            BINARY (32)    NULL,
    [ValidFrom]              DATETIME2 (0)  NULL,
    [ValidTo]                DATETIME2 (0)  NULL,
    [IsCurrent]              BIT            NULL
)
WITH (HEAP, DISTRIBUTION = HASH([SubmissionHash]));
