CREATE TABLE [ELT].[DQ_Alert] (
    [DqAlertID]                    INT            IDENTITY (1, 1) NOT NULL,
    [DqExceptionTypeID]            INT            NULL,
    [DqExceptionAreaID]            INT            NULL,
    [Importance]                   VARCHAR (10)   NULL,
    [Active]                       CHAR (1)       NULL,
    [AlertName]                    VARCHAR (2000) NULL,
    [AlertDetails]                 VARCHAR (2000) NULL,
    [EmailNotificationonFailure]   CHAR (1)       NULL,
    [EmailFailureMessage]          VARCHAR (2000) NULL,
    [EmailNotificationonFailureOK] CHAR (1)       NULL,
    [EmailFailureOKMessage]        VARCHAR (2000) NULL,
    [EmailNotificationonSuccess]   CHAR (1)       NULL,
    [EmailSuccessMessage]          VARCHAR (2000) NULL,
    [EmailSubject]                 VARCHAR (2000) NULL,
    [RecipientsView]               VARCHAR (2000) NULL,
    [CcRecipientsView]             VARCHAR (2000) NULL,
    [BccRecipientsView]            VARCHAR (2000) NULL,
    [AlertView]                    VARCHAR (2000) NULL,
    PRIMARY KEY NONCLUSTERED ([DqAlertID] ASC) NOT ENFORCED
)
WITH (CLUSTERED COLUMNSTORE INDEX, DISTRIBUTION = ROUND_ROBIN);



