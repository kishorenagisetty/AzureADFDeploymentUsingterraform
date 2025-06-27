CREATE TABLE [DV].[HUB_Assignment] (
    [AssignmentHash] BINARY (32)    NULL,
    [AssignmentKey]  NVARCHAR (100) NULL,
    [RecordSource]   VARCHAR (50)   NULL,
    [ValidFrom]      DATETIME2 (0)  NULL
)
WITH (HEAP, DISTRIBUTION = HASH([AssignmentHash]));

