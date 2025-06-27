CREATE EXTERNAL TABLE [ELT].[DVObjectMapping] (
    [ObjectMappingID] INT NULL,
    [SourceConnection] VARCHAR (20) NULL,
    [ObjectType] VARCHAR (20) NULL,
    [SourceSchema] VARCHAR (20) NULL,
    [SourceTable] VARCHAR (50) NULL,
    [DestinationConnection] VARCHAR (20) NULL,
    [DestinationSchema] VARCHAR (20) NULL,
    [DestinationTable] VARCHAR (50) NULL,
    [IsEnabled] BIT NULL,
    [SourceGroup] [varchar](20) NULL
)
    WITH (
    DATA_SOURCE = [ADLG2_PSA],
    LOCATION = N'metadata/DVObjectMapping.csv',
    FILE_FORMAT = [CSVFormat],
    REJECT_TYPE = VALUE,
    REJECT_VALUE = 0
    );

