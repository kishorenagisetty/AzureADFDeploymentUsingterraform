CREATE EXTERNAL TABLE [ELT].[ColumnMask] (
    [ColumnMaskID] INT NULL,
    [TableName] VARCHAR (100) NULL,
    [ColumnName] VARCHAR (100) NULL,
    [MaskingRuleID] INT NULL
)
    WITH (
    DATA_SOURCE = [ADLG2_PSA],
    LOCATION = N'metadata/ColumnMask.csv',
    FILE_FORMAT = [CSVFormatStringDelimited],
    REJECT_TYPE = VALUE,
    REJECT_VALUE = 0
    );

