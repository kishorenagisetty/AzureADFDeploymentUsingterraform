CREATE TABLE [ELT].[ImportJsonAAS] (
    [Id]          INT            IDENTITY (1, 1) NOT NULL,
    [refreshId]   VARCHAR (200)  NULL,
    [startTime]   DATETIME       NULL,
    [endTime]     DATETIME       NULL,
    [status]      NVARCHAR (200) NULL,
    [CreatedDate] DATETIME       NOT NULL
)
WITH (CLUSTERED COLUMNSTORE INDEX, DISTRIBUTION = ROUND_ROBIN);



