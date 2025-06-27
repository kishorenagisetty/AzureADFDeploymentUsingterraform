CREATE TABLE [ELT].[DQ_Exception_Summary] (
    [DqExceptionSummaryID] INT            NOT NULL,
    [DqExceptionID]        INT            NOT NULL,
    [DateTime]             DATETIME       NOT NULL,
    [NumberOfExceptions]   INT            NOT NULL,
    [Msg]                  VARCHAR (2000) NULL,
    CONSTRAINT [PK_CTL_DqExceptionSummary] PRIMARY KEY NONCLUSTERED ([DqExceptionSummaryID] ASC) NOT ENFORCED
)
WITH (CLUSTERED COLUMNSTORE INDEX, DISTRIBUTION = ROUND_ROBIN);

