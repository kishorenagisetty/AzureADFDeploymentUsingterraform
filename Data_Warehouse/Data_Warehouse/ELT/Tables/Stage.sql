CREATE TABLE [ELT].[Stage] (
    [StageID]          INT            NOT NULL,
    [Stage]            VARCHAR (255)  NULL,
    [StageDescription] VARCHAR (4000) NULL,
    [Active]           INT            NOT NULL,
    [RunOrder]         INT            NULL
)
WITH (CLUSTERED COLUMNSTORE INDEX, DISTRIBUTION = ROUND_ROBIN);

