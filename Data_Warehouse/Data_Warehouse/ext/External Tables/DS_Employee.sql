CREATE EXTERNAL TABLE [ext].[DS_Employee] (
    [Team] VARCHAR (255) NULL,
    [TeamLeader] VARCHAR (255) NULL,
    [VRC] VARCHAR (255) NULL,
    [VRCAccount] VARCHAR (255) NULL,
    [PskUserID] VARCHAR (255) NULL,
    [Email] VARCHAR (255) NULL,
    [IsActive] BIT NULL,
    [JobTitle] VARCHAR (255) NULL,
    [CascadeID] VARCHAR (255) NULL,
    [WorksForCascadeID] VARCHAR (255) NULL,
    [IsWorkingForSupportCentre] BIT NULL,
    [Provision] VARCHAR (255) NULL
)
    WITH (
    DATA_SOURCE = [polybasestaging],
    LOCATION = N'DS_Employee/',
    FILE_FORMAT = [TextFileFormat],
    REJECT_TYPE = VALUE,
    REJECT_VALUE = 0
    );

