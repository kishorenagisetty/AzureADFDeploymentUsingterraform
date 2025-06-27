CREATE EXTERNAL TABLE [ELT].[ActivityCategories] (
    [ActivityType] VARCHAR (100) NULL,
    [Vol] INT NULL,
    [ActivityRole] VARCHAR (100) NULL,
    [Category] VARCHAR (100) NULL,
    [Source] VARCHAR (100) NULL
)
    WITH (
    DATA_SOURCE = [ADLG2_PSA],
    LOCATION = N'metadata/Activity_Categories.csv',
    FILE_FORMAT = [CSVFormatStringDelimited],
    REJECT_TYPE = VALUE,
    REJECT_VALUE = 0
    );

