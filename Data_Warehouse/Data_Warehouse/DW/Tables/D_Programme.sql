CREATE TABLE [DW].[D_Programme] (
    [Programme_Skey]     INT           NOT NULL,
    [ProgrammeBusKey]    INT           NOT NULL,
    [Programme]          VARCHAR (255) NOT NULL,
    [ProgrammeGroup]     VARCHAR (255) NULL,
    [ProgrammeCategory]  VARCHAR (255) NULL,
    [ProgrammeStartDate] DATE          NULL,
    [ProgrammeEndDate]   DATE          NOT NULL,
    [IsActive]           BIT           NULL,
    [Sys_LoadDate]       DATETIME      NOT NULL,
    [Sys_ModifiedDate]   DATETIME      NOT NULL,
    [Sys_RunID]          INT           NOT NULL
)
WITH (CLUSTERED COLUMNSTORE INDEX, DISTRIBUTION = REPLICATE);



