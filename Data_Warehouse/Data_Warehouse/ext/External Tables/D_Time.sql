CREATE EXTERNAL TABLE [ext].[D_Time] (
    [Time] TIME (0) NOT NULL,
    [Hour] VARCHAR (50) NOT NULL,
    [MilitaryHour] VARCHAR (50) NOT NULL,
    [Minute] VARCHAR (50) NOT NULL,
    [Second] VARCHAR (50) NOT NULL,
    [AmPm] VARCHAR (50) NOT NULL,
    [StandardTime] VARCHAR (50) NULL,
    [Time_Hour_Quarter] VARCHAR (50) NULL
)
    WITH (
    DATA_SOURCE = [polybasestaging],
    LOCATION = N'D_Time/',
    FILE_FORMAT = [PipeFileFormat],
    REJECT_TYPE = VALUE,
    REJECT_VALUE = 0
    );

