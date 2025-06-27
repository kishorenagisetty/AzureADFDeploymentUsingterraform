CREATE TABLE [ELT].[ProgrammesToRun] (
    [ProgrammeID] INT           NOT NULL,
    [Programme]   VARCHAR (255) NOT NULL,
    [Active]      INT           NOT NULL,
    [RunOrder]    INT           NULL,
    [batch]       VARCHAR (100) NULL
)
WITH (CLUSTERED COLUMNSTORE INDEX, DISTRIBUTION = ROUND_ROBIN);



