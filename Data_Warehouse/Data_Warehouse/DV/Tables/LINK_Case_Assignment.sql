CREATE TABLE [DV].[LINK_Case_Assignment] (
    [Case_AssignmentHash] BINARY (32)   NULL,
    [CaseHash]            BINARY (32)   NULL,
    [AssignmentHash]      BINARY (32)   NULL,
    [RecordSource]        VARCHAR (50)  NULL,
    [ValidFrom]           DATETIME2 (0) NULL
)
WITH (HEAP, DISTRIBUTION=HASH([Case_AssignmentHash]) ) 
GO


