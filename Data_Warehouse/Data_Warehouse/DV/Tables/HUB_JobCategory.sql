CREATE TABLE [DV].[HUB_JobCategory] (
    [JobCategoryHash] BINARY (32)    NULL,
    [JobCategoryKey]  NVARCHAR (100) NULL,
    [RecordSource]    VARCHAR (50)   NULL,
    [ValidFrom]       DATETIME2 (0)  NULL
)
WITH (HEAP, DISTRIBUTION = HASH([JobCategoryHash]));

