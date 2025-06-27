CREATE TABLE [ELT].[PipelineRunLog] (
    [RunID]         INT           NOT NULL,
    [LoadDate]      DATETIME      NULL,
    [PipelineRunID] VARCHAR (100) NULL,
    [LZ]            BIT           NULL,
    [PSA]           BIT           NULL,
    [DS]            BIT           NULL,
    [DW]            BIT           NULL
)
WITH (CLUSTERED COLUMNSTORE INDEX, DISTRIBUTION = ROUND_ROBIN);

