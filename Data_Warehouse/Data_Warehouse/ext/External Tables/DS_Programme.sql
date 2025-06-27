CREATE EXTERNAL TABLE [ext].[DS_Programme] (
    [ProgrammeBusKey] VARCHAR (255) NOT NULL,
    [Programme] VARCHAR (255) NOT NULL,
    [ProgrammeGroup] VARCHAR (255) NULL,
    [ProgrammeCategory] VARCHAR (255) NULL,
    [ProgrammeStartDate] DATE NULL,
    [ProgrammeEndDate] DATE NULL,
    [IsActive] BIT NULL
)
    WITH (
    DATA_SOURCE = [polybasestaging],
    LOCATION = N'DS_Programme/',
    FILE_FORMAT = [TextFileFormat],
    REJECT_TYPE = VALUE,
    REJECT_VALUE = 0
    );

