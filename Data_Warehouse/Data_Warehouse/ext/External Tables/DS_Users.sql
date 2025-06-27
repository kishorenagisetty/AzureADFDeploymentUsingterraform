CREATE EXTERNAL TABLE [ext].[DS_Users] (
    [ID] INT NULL,
    [Team] VARCHAR (255) NULL,
    [TeamLeader] VARCHAR (255) NULL,
    [VRC] VARCHAR (255) NULL,
    [VRCAccount] VARCHAR (255) NULL,
    [Email] VARCHAR (255) NULL,
    [IsActive] BIT NULL,
    [CascadeID] VARCHAR (255) NULL,
    [WorksForCascadeID] VARCHAR (255) NULL
)
    WITH (
    DATA_SOURCE = [polybasestaging],
    LOCATION = N'DS_Users/',
    FILE_FORMAT = [TextFileFormat],
    REJECT_TYPE = VALUE,
    REJECT_VALUE = 0
    );

