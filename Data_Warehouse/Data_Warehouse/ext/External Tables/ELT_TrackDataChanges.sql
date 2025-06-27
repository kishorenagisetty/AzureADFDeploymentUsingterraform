CREATE EXTERNAL TABLE [ext].[ELT_TrackDataChanges] (
    [TrackDataChangesID] INT NULL,
    [Source_Name] VARCHAR (128) NULL,
    [Source_Schema] VARCHAR (128) NULL,
    [Stage_Schema] VARCHAR (128) NULL,
    [Dest_Schema] VARCHAR (128) NULL,
    [Table] VARCHAR (128) NULL,
    [ID] VARCHAR (128) NULL,
    [Key] VARCHAR (128) NULL,
    [Enabled] BIT NULL
)
    WITH (
    DATA_SOURCE = [polybasestaging],
    LOCATION = N'ELT_MetaData/TrackDataChanges',
    FILE_FORMAT = [PipeFileFormat],
    REJECT_TYPE = VALUE,
    REJECT_VALUE = 0
    );



