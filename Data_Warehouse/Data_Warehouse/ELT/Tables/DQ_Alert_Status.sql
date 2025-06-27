CREATE TABLE [ELT].[DQ_Alert_Status] (
    [DqAlertStatusID]                        INT          IDENTITY (1, 1) NOT NULL,
    [DqAlertID]                              INT          NULL,
    [AlertDate]                              DATE         NULL,
    [AlertStatus]                            VARCHAR (20) NULL,
    [EmailNotificationonFailureSentDateTime] DATETIME     NULL,
    [EmailNotificationonSuccessSentDateTime] DATETIME     NULL,
    PRIMARY KEY NONCLUSTERED ([DqAlertStatusID] ASC) NOT ENFORCED
)
WITH (CLUSTERED COLUMNSTORE INDEX, DISTRIBUTION = ROUND_ROBIN);



