CREATE EXTERNAL TABLE [ELT].[MaskingRule] (
    [MaskingRuleID] INT NULL,
    [RuleName] VARCHAR (100) NULL,
    [Description] VARCHAR (200) NULL,
    [AppliesTo] VARCHAR (20) NULL,
    [RuleCode] NVARCHAR (MAX) NULL
)
    WITH (
    DATA_SOURCE = [ADLG2_PSA],
    LOCATION = N'metadata/MaskingRule.csv',
    FILE_FORMAT = [CSVFormatStringDelimited],
    REJECT_TYPE = VALUE,
    REJECT_VALUE = 0
    );

