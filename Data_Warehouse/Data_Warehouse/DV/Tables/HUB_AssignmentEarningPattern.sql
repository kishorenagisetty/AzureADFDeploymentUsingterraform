CREATE TABLE [DV].[HUB_AssignmentEarningPattern] (
    [AssignmentEarningPatternHash] BINARY (32)    NULL,
    [AssignmentEarningPatternKey]  NVARCHAR (100) NULL,
    [RecordSource]                 VARCHAR (50)   NULL,
    [ValidFrom]                    DATETIME2 (0)  NULL
)
WITH (HEAP, DISTRIBUTION = HASH([AssignmentEarningPatternHash]));
GO

