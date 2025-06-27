CREATE EXTERNAL TABLE [ext].[ELT_DQ_Exception_Area] (
    [DqExceptionAreaID] INT NULL,
    [Exception_Area] VARCHAR (2000) NULL
)
    WITH (
    DATA_SOURCE = [polybasestaging],
    LOCATION = N'ELT_MetaData/Data_Quality/DQ_Exception_Area',
    FILE_FORMAT = [PipeFileFormat],
    REJECT_TYPE = VALUE,
    REJECT_VALUE = 0
    );

