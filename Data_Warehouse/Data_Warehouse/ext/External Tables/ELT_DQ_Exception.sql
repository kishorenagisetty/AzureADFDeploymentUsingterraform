CREATE EXTERNAL TABLE [ext].[ELT_DQ_Exception] (
    [DqExceptionID] INT NULL,
    [DqExceptionTypeID] INT NULL,
    [DqExceptionAreaID] INT NULL,
    [Impact] CHAR (10) NULL,
    [AdHoc] CHAR (1) NOT NULL,
    [Active] CHAR (1) NOT NULL,
    [Exception_Name] VARCHAR (2000) NULL,
    [Exception_Details] VARCHAR (2000) NULL
)
    WITH (
    DATA_SOURCE = [polybasestaging],
    LOCATION = N'ELT_MetaData/Data_Quality/DQ_Exception',
    FILE_FORMAT = [PipeFileFormat],
    REJECT_TYPE = VALUE,
    REJECT_VALUE = 0
    );

