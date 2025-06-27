CREATE TABLE [ELT].[CTL_Load] (
    [RunID]           INT           NOT NULL,
    [StartTime]       DATETIME      NOT NULL,
    [EndTime]         DATETIME      NULL,
    [DurationSeconds] INT           NULL,
    [LoadDate]        DATE          NULL,
    [Status]          VARCHAR (10)  NULL,
    [PipelineRunID]   VARCHAR (100) NULL,
    [PipelineName]    VARCHAR (500) NOT NULL,
    CONSTRAINT [PK_CTL_Load_LoadNumber] PRIMARY KEY NONCLUSTERED ([RunID] ASC) NOT ENFORCED
)
WITH (CLUSTERED COLUMNSTORE INDEX, DISTRIBUTION = ROUND_ROBIN);

