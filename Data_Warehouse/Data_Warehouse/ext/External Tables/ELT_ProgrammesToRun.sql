CREATE EXTERNAL TABLE [ext].[ELT_ProgrammesToRun] (
    [ProgrammeID] INT NULL,
    [Programme] VARCHAR (255) NULL,
    [Active] INT NULL,
    [RunOrder] INT NULL,
    [batch] VARCHAR (100) NULL
)
    WITH (
    DATA_SOURCE = [polybasestaging],
    LOCATION = N'ELT_MetaData/ProgrammesToRun',
    FILE_FORMAT = [PipeFileFormat],
    REJECT_TYPE = VALUE,
    REJECT_VALUE = 0
    );

