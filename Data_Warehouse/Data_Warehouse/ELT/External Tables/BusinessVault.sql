CREATE EXTERNAL TABLE [ELT].[BusinessVault] (
    [BusinessVaultID] INT NULL,
    [ExecutionGroup] INT NULL,
    [ProcedureName] VARCHAR (200) NULL,
    [Description] VARCHAR (MAX) NULL
)
    WITH (
    DATA_SOURCE = [ADLG2_PSA],
    LOCATION = N'metadata/BusinessVault.csv',
    FILE_FORMAT = [CSVFormatStringDelimited],
    REJECT_TYPE = VALUE,
    REJECT_VALUE = 0
    );

