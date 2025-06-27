CREATE TABLE [DV].[HUB_WorkFlowEvents] (
    [WorkFlowEventsHash] BINARY (32)    NULL,
    [WorkFlowEventsKey]  NVARCHAR (100) NULL,
    [RecordSource]       VARCHAR (50)   NULL,
    [ValidFrom]          DATETIME2 (0)  NULL
)
WITH (HEAP, DISTRIBUTION = HASH([WorkFlowEventsHash]));
GO

