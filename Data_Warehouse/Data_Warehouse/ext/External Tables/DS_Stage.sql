CREATE EXTERNAL TABLE [ext].[DS_Stage] (
    [StageGroup] VARCHAR (255) NULL,
    [StageCategory] VARCHAR (255) NULL,
    [Stage] VARCHAR (255) NULL,
    [StageOrder] INT NULL,
    [Enq] CHAR (1) NULL,
    [Ref] CHAR (1) NULL,
    [TeleAssessment] CHAR (1) NULL,
    [InitialSupportPlan] CHAR (1) NULL,
    [PlanActive] CHAR (1) NULL,
    [Closed] CHAR (1) NULL,
    [FromDuration] INT NULL,
    [FromDurationType] VARCHAR (255) NULL,
    [ToDuration] INT NULL,
    [ToDurationType] VARCHAR (255) NULL
)
    WITH (
    DATA_SOURCE = [polybasestaging],
    LOCATION = N'DS_Stages/',
    FILE_FORMAT = [TextFileFormat],
    REJECT_TYPE = VALUE,
    REJECT_VALUE = 0
    );



