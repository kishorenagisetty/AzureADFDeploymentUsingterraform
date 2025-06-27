﻿CREATE TABLE [ELT].[CTL_MsgLog] (
    [MsgLogID]     INT            IDENTITY (1, 1) NOT NULL,
    [RunID]        INT            NOT NULL,
    [ActivityName] VARCHAR (2000) NULL,
    [DateTime]     DATETIME       NOT NULL,
    [Msg]          VARCHAR (2000) NULL,
    [Type]         VARCHAR (1)    DEFAULT ('I') NULL,
    CONSTRAINT [PK_CTL_MsgLog] PRIMARY KEY NONCLUSTERED ([MsgLogID] ASC) NOT ENFORCED
)
WITH (CLUSTERED COLUMNSTORE INDEX, DISTRIBUTION = ROUND_ROBIN);

