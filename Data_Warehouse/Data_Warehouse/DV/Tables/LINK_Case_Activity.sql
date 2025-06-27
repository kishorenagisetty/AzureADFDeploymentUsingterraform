CREATE TABLE [DV].[LINK_Case_Activity] (
    [Case_ActivityHash] BINARY (32)   NULL,
    [CaseHash]          BINARY (32)   NULL,
    [ActivityHash]      BINARY (32)   NULL,
    [RecordSource]      VARCHAR (50)  NULL,
    [ValidFrom]         DATETIME2 (0) NULL
)
WITH (HEAP, DISTRIBUTION=HASH([Case_ActivityHash]) ) ;


GO


