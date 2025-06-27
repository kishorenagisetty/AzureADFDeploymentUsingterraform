CREATE TABLE [ELT].[DQ_Exception] (
    [DqExceptionID]     INT            IDENTITY (1, 1) NOT NULL,
    [DqExceptionTypeID] INT            DEFAULT ((1)) NULL,
    [DqExceptionAreaID] INT            DEFAULT ((1)) NULL,
    [Impact]            CHAR (10)      DEFAULT ('Low') NULL,
    [AdHoc]             CHAR (1)       DEFAULT ('N') NOT NULL,
    [Active]            CHAR (1)       DEFAULT ('Y') NOT NULL,
    [Exception_Name]    VARCHAR (2000) NULL,
    [Exception_Details] VARCHAR (2000) NULL,
    CONSTRAINT [PK_CTL_DqException] PRIMARY KEY NONCLUSTERED ([DqExceptionID] ASC) NOT ENFORCED
)
WITH (CLUSTERED COLUMNSTORE INDEX, DISTRIBUTION = ROUND_ROBIN);

