CREATE TABLE [DW].[D_Time] (
    [Time_Skey]         INT          NOT NULL,
    [Time]              TIME (7)     NULL,
    [Hour]              VARCHAR (50) NOT NULL,
    [MilitaryHour]      VARCHAR (50) NOT NULL,
    [Minute]            VARCHAR (50) NOT NULL,
    [Second]            VARCHAR (50) NOT NULL,
    [AmPm]              VARCHAR (50) NOT NULL,
    [StandardTime]      VARCHAR (50) NULL,
    [Time_Hour_Quarter] VARCHAR (50) NULL,
    [Sys_LoadDate]      DATETIME     NOT NULL,
    [Sys_ModifiedDate]  DATETIME     NOT NULL,
    CONSTRAINT [PK_Time_skey] PRIMARY KEY NONCLUSTERED ([Time_Skey] ASC) NOT ENFORCED
)
WITH (CLUSTERED COLUMNSTORE INDEX, DISTRIBUTION = REPLICATE);



