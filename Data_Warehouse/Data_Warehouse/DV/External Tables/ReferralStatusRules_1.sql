CREATE EXTERNAL TABLE [DV].[ReferralStatusRules] (
    [RuleID] INT NULL,
    [ReferralStatus] VARCHAR (50) NULL,
    [ProgrammeName] VARCHAR (100) NULL,
    [DocumentName] VARCHAR (100) NULL,
    [DocumentStatus] VARCHAR (50) NULL,
    [StartDate] VARCHAR (10) NULL,
    [LeaveDate] VARCHAR (10) NULL,
    [LeaveReason] VARCHAR (50) NULL,
    [NotLeaveReason] VARCHAR (50) NULL,
    [RuleRankHits] INT NULL,
    [RuleRank] INT NULL
)
    WITH (
    DATA_SOURCE = [ADLG2_PSA],
    LOCATION = N'metadata/ReferralStatusRules.csv',
    FILE_FORMAT = [CSVFormat],
    REJECT_TYPE = VALUE,
    REJECT_VALUE = 0
    );

