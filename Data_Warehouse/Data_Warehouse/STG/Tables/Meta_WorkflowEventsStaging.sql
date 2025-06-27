CREATE TABLE [STG].[Meta_WorkflowEventsStaging] (
    [CaseHashBin]             BINARY (32)   NULL,
    [CaseHash]                CHAR (66)     NULL,
    [ReferralHash]            CHAR (66)     NULL,
    [ProgrammeHash]           CHAR (66)     NULL,
    [StartDate]               DATE          NULL,
    [LeaveDate]               DATE          NULL,
    [ProjectedLeaveDate]      DATE          NULL,
    [ReferralDate]            DATE          NULL,
    [ProgrammeName]           VARCHAR (250) NULL,
    [FirstCorrespondenceDate] DATE          NULL,
    [FirstJobStartDate]       DATE          NULL,
    [BotWelcomePackDate]      DATE          NULL,
    [BotFTADate]              DATE          NULL,
    [InOutWork]               VARCHAR (10)  NOT NULL,
    [RecordSource]            VARCHAR (50)  NULL,
    [LeaveReason]             VARCHAR (250) NULL
)
WITH (CLUSTERED COLUMNSTORE INDEX, DISTRIBUTION = ROUND_ROBIN);



