CREATE TABLE [DV].[HUB_WorkFlowEventStage] (
    [WorkFlowEventStageHash] BINARY (32)    NULL,
    [WorkFlowEventStageKey]  NVARCHAR (100) NULL,
    [RecordSource]           VARCHAR (50)   NULL,
    [ValidFrom]              DATETIME2 (0)  NULL
)
WITH (HEAP, DISTRIBUTION = HASH([WorkFlowEventStageHash]));
GO

