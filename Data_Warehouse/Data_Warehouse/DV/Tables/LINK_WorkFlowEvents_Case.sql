CREATE TABLE [DV].[LINK_WorkFlowEvents_Case] (
    [WorkFlowEvents_CaseHash] BINARY (32)   NULL,
    [WorkFlowEventsHash]      BINARY (32)   NULL,
    [CaseHash]                BINARY (32)   NULL,
    [RecordSource]            VARCHAR (50)  NULL,
    [ValidFrom]               DATETIME2 (0) NULL
)
WITH (HEAP, DISTRIBUTION = HASH([WorkFlowEventsHash]));
GO

