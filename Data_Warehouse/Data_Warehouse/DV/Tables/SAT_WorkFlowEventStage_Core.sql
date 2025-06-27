CREATE TABLE [DV].[SAT_WorkFlowEventStage_core] (
    [WorkFlowEventStageHash] BINARY (32)   NULL,
    [WorkFlowEventStageKey]  INT           NULL,
    [WorkFlowStageKey]       INT           NULL,
    [ProgrammeKey]           VARCHAR (255) NULL,
    [StageCategory]          VARCHAR (100) NULL,
    [Enquiry]                CHAR (1)      NULL,
    [Referral]               CHAR (1)      NULL,
    [PlanActive]             CHAR (1)      NULL,
    [InWork]                 CHAR (1)      NULL,
    [Closed]                 CHAR (1)      NULL,
    [ContentHash]            BINARY (32)   NULL,
    [ValidFrom]              DATETIME2 (0) NULL,
    [ValidTo]                DATETIME2 (0) NULL,
    [IsCurrent]              BIT           NULL
)
WITH (HEAP, DISTRIBUTION = HASH([WorkFlowEventStageHash]));
GO

