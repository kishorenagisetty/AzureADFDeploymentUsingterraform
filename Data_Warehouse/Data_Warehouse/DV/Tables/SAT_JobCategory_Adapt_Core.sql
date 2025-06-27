CREATE TABLE [DV].[SAT_JobCategory_Adapt_Core] (
    [JobCategoryHash] BINARY (32)    NULL,
    [JobCategoryKey]  NVARCHAR (100) NULL,
    [RecordSource]    VARCHAR (18)   NOT NULL,
    [JobCategory]     DECIMAL (20)   NULL,
    [Reference]       DECIMAL (16)   NULL,
    [ContentHash]     BINARY (32)    NULL,
    [ValidFrom]       DATETIME2 (0)  NULL,
    [ValidTo]         DATETIME2 (0)  NULL,
    [IsCurrent]       BIT            NULL
)
WITH (HEAP, DISTRIBUTION = HASH([JobCategoryHash]));

