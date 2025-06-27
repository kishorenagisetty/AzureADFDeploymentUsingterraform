CREATE TABLE [DV].[LINK_WorkFlowEventStage_WorkFlowEventType] (
    [WorkFlowEventStage_WorkFlowEventTypeHash] BINARY (32)   NULL,
    [WorkFlowEventStageHash]                   BINARY (32)   NULL,
    [WorkFlowEventTypeHash]                    BINARY (32)   NULL,
    [RecordSource]                             VARCHAR (50)  NULL,
    [ValidFrom]                                DATETIME2 (0) NULL
)
WITH (HEAP, DISTRIBUTION = REPLICATE);


GO

