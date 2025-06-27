CREATE TABLE [ELT].[CTL_Email_Log] (
    [EmailLogID]       INT            IDENTITY (1, 1) NOT NULL,
    [Type]             VARCHAR (200)  NULL,
    [DQAlertID]        INT            NULL,
    [DQAlertStatusID]  INT            NULL,
    [Recipients]       VARCHAR (5000) NOT NULL,
    [CcRecipients]     VARCHAR (5000) NULL,
    [BccRecipients]    VARCHAR (5000) NULL,
    [Subject]          VARCHAR (255)  NULL,
    [Body]             VARCHAR (5000) NULL,
    [Importance]       VARCHAR (20)   NULL,
    [RequestCreatedOn] DATETIME       NOT NULL,
    [EmailSentOn]      DATETIME       NULL,
    [IsProcessed]      CHAR (1)       NOT NULL
)
WITH (CLUSTERED COLUMNSTORE INDEX, DISTRIBUTION = ROUND_ROBIN);



