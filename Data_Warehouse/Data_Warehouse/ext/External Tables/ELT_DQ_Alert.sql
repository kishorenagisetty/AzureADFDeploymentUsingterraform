CREATE EXTERNAL TABLE [ext].[ELT_DQ_Alert] (
    [DqAlertID] INT NULL,
    [DqExceptionTypeID] INT NULL,
    [DqExceptionAreaID] INT NULL,
    [Importance] VARCHAR (10) NULL,
    [Active] CHAR (1) NULL,
    [AlertName] VARCHAR (2000) NULL,
    [AlertDetails] VARCHAR (2000) NULL,
    [EmailNotificationonFailure] CHAR (1) NULL,
    [EmailFailureMessage] VARCHAR (2000) NULL,
    [EmailNotificationonFailureOK] CHAR (1) NULL,
    [EmailFailureOKMessage] VARCHAR (2000) NULL,
    [EmailNotificationonSuccess] CHAR (1) NULL,
    [EmailSuccessMessage] VARCHAR (2000) NULL,
    [EmailSubject] VARCHAR (2000) NULL,
    [RecipientsView] VARCHAR (2000) NULL,
    [CcRecipientsView] VARCHAR (2000) NULL,
    [BccRecipientsView] VARCHAR (2000) NULL,
    [AlertView] VARCHAR (2000) NULL
)
    WITH (
    DATA_SOURCE = [polybasestaging],
    LOCATION = N'ELT_MetaData/Data_Quality/DQ_Alert',
    FILE_FORMAT = [PipeFileFormat],
    REJECT_TYPE = VALUE,
    REJECT_VALUE = 0
    );

