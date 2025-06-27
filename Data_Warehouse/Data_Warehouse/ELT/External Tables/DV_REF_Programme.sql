CREATE EXTERNAL TABLE [ELT].[DV_REF_Programme] (
    [ProgrammeKey] VARCHAR (20) NULL,
    [RecordSource] VARCHAR (50) NULL,
    [ProgrammeName] VARCHAR (250) NULL,
    [ProgrammeSupportLength] INT NULL,
    [ProgrammeSupportExtensionLength] INT NULL,
    [ProgrammeOutcomeTrackingLength] INT NULL,
    [ProgrammeOutcomeOneThresholdEarnings] NUMERIC (18, 2) NULL,
    [ProgrammeOutcomeOneThresholdDays] INT NULL,
    [ProgrammeSelfEmployedOutcomeOneThreshold] INT NULL,
    [ProgrammeOutcomeModel] VARCHAR (50) NULL,
    [ProgrammeOutcomeTwoThresholdEarnings] NUMERIC (18, 2) NULL,
    [ProgrammeOutcomeTwoThresholdDays] INT NULL,
    [ProgrammeSelfEmployedOutcomeTwoThreshold] INT NULL,
    [ProgrammeOutcomeThreeThresholdEarnings] NUMERIC (18, 2) NULL,
    [ProgrammeOutcomeThreeThresholdDays] INT NULL,
    [ProgrammeOutcomeOneClaimPeriod] INT NULL,
    [ProgrammeOutcomeTwoClaimPeriod] INT NULL,
    [ProgrammeOutcomeThreeClaimPeriod] INT NULL
)
    WITH (
    DATA_SOURCE = [polybasestaging],
    LOCATION = N'DV_REF_Programme.csv',
    FILE_FORMAT = [CSVFormatStringDelimited],
    REJECT_TYPE = VALUE,
    REJECT_VALUE = 0
    );

