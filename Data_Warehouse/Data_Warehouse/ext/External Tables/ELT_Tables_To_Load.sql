CREATE EXTERNAL TABLE [ext].[ELT_Tables_To_Load] (
    [ID] INT NULL,
    [Source_Name] VARCHAR (128) NULL,
    [Source_Schema] VARCHAR (128) NULL,
    [Source_Table] VARCHAR (128) NULL,
    [Dest_Schema] VARCHAR (128) NULL,
    [Dest_table] VARCHAR (128) NULL,
    [Columns] VARCHAR (5000) NULL,
    [WatermarkColumn] VARCHAR (128) NULL,
    [WatermarkValue] DATETIME NULL,
    [Enabled] BIT NULL,
    [Distribution_Type] VARCHAR (255) NULL,
    [ObjectType] VARCHAR (2) NULL,
    [Dest_Table_Prefix] VARCHAR (128) NULL
)
    WITH (
    DATA_SOURCE = [polybasestaging],
    LOCATION = N'ELT_MetaData/Tables_To_Load',
    FILE_FORMAT = [PipeFileFormat],
    REJECT_TYPE = VALUE,
    REJECT_VALUE = 0
    );

