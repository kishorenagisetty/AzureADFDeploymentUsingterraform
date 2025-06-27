CREATE TABLE [ELT].[DQ_Exception_Detail] (
    [DqExceptionDetailID]  INT            IDENTITY (1, 1) NOT NULL,
    [DqExceptionSummaryID] INT            NOT NULL,
    [DateTime]             DATETIME       NOT NULL,
    [Msg]                  VARCHAR (2000) NULL,
    CONSTRAINT [PK_CTL_DqExceptionDetail] PRIMARY KEY NONCLUSTERED ([DqExceptionDetailID] ASC) NOT ENFORCED
)
WITH (CLUSTERED COLUMNSTORE INDEX, DISTRIBUTION = ROUND_ROBIN);

