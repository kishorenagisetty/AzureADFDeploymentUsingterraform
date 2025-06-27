CREATE TABLE [DV].[SAT_Activity_Adapt_Core] (
    [ActivityHash]               BINARY (32)     NULL,
    [ActivityKey]                NVARCHAR (100)  NULL,
    [RecordSource]               VARCHAR (23)    NOT NULL,
    [ActivityName]               NVARCHAR (MAX)  NULL,
    [ActivityAddDate]            DATETIME2 (0)   NULL, -- 25/08/23 <MK> <26478> Added as per Paul H Advise
    [ActivityStartDate]          DATETIME2 (0)   NULL,
    [ActivityDueDate]            DATETIME2 (0)   NULL,
    [ActivityStatus]             DECIMAL (20)    NULL,
    [ActivityCompleteDate]       DATETIME2 (0)   NULL,
    [ActivityRelatedAssignment]  DECIMAL (16)    NULL,
    [ActivityType]               DECIMAL (20)    NULL,
    [ActivityDescription]        NVARCHAR (MAX)  NULL,
    [ActivityRelatedSupportNeed] NVARCHAR (MAX)  NULL,
    [ActivityHoursSpent]         DECIMAL (12, 2) NULL,
    [ActivityHoursScheduled]     DECIMAL (5, 2)  NULL,
    [ActivityOutcome]            DECIMAL (20)    NULL,
    [ActivityContactMethod]      DECIMAL (20)    NULL,
    [ActivityIsMandatory]        NVARCHAR (MAX)  NULL,
    [ActivityIsLTURelated]       NVARCHAR (MAX)  NULL,
    [ActivityIsNEORelated]       NVARCHAR (MAX)  NULL,
    [ActivityNEOType]            DECIMAL (20)    NULL,
    [ActivityVenue]              NVARCHAR (MAX)  NULL,
    [ContentHash]                BINARY (32)     NULL,
    [ValidFrom]                  DATETIME2 (0)   NULL,
    [ValidTo]                    DATETIME2 (0)   NULL,
    [IsCurrent]                  BIT             NULL
)
WITH (HEAP, DISTRIBUTION = HASH([ActivityHash]));


GO