CREATE EXTERNAL TABLE [ELT].[WorkFlowEventStage] (
    [WorkFlowStageID] INT NULL,
    [StageCategory] VARCHAR (100) NULL,
    [Programme] VARCHAR (255) NULL,
    [Enquiry] CHAR (1) NULL,
    [Referral] CHAR (1) NULL,
    [PlanActive] CHAR (1) NULL,
    [InWork] CHAR (1) NULL,
    [Closed] CHAR (1) NULL
)
    WITH (
    DATA_SOURCE = [ADLG2_PSA],
    LOCATION = N'WorkflowEvents/WorkFlowEventStage.csv',
    FILE_FORMAT = [CSVFormatStringDelimited],
    REJECT_TYPE = VALUE,
    REJECT_VALUE = 0
    );
GO

