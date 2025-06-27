CREATE EXTERNAL TABLE [ext].[ELT_StoredProceduresToRUn] (
    [Schema] NVARCHAR (128) NULL,
    [Name] NVARCHAR (128) NULL,
    [Stage] INT NULL,
    [Active] INT NULL,
    [RunOrder] INT NULL
)
    WITH (
    DATA_SOURCE = [polybasestaging],
    LOCATION = N'ELT_MetaData/StoredProceduresToRun',
    FILE_FORMAT = [PipeFileFormat],
    REJECT_TYPE = VALUE,
    REJECT_VALUE = 0
    );

