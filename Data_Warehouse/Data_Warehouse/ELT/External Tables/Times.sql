CREATE EXTERNAL TABLE [ELT].[Times] (
    [Time_Skey] INT NOT NULL,
    [Time] TIME (7) NULL,
    [Hour] VARCHAR (50) NOT NULL,
    [MilitaryHour] VARCHAR (50) NOT NULL,
    [Minute] VARCHAR (50) NOT NULL,
    [Second] VARCHAR (50) NOT NULL,
    [AmPm] VARCHAR (50) NOT NULL,
    [StandardTime] VARCHAR (50) NULL,
    [Time_Hour_Quarter] VARCHAR (50) NULL,
    [Sys_LoadDate] DATETIME NOT NULL,
    [Sys_ModifiedDate] DATETIME NOT NULL
)
    WITH (
    DATA_SOURCE = [ADLG2_PSA],
    LOCATION = N'metadata/Times.csv',
    FILE_FORMAT = [CSVFormat],
    REJECT_TYPE = VALUE,
    REJECT_VALUE = 0
    );
GO

