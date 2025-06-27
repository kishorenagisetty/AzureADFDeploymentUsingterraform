CREATE TABLE [ELT].[StoredProceduresToRun] (
    [Schema]   NVARCHAR (128) NULL,
    [Name]     [sysname]      NOT NULL,
    [Stage]    INT            NOT NULL,
    [Active]   INT            NOT NULL,
    [RunOrder] INT            NULL
)
WITH (CLUSTERED COLUMNSTORE INDEX, DISTRIBUTION = ROUND_ROBIN);

