CREATE TABLE [DV].[SAT_Programme_Iconi_Core] (
    [ProgrammeHash]     BINARY (32)    NULL,
    [ProgrammeKey]      NVARCHAR (100) NULL,
    [ProgrammeName]     VARCHAR (7)    NOT NULL,
    [ProgrammeGroup]    VARCHAR (7)    NOT NULL,
    [ProgrammeCategory] VARCHAR (7)    NOT NULL,
    [ContentHash]       BINARY (32)    NULL,
    [ValidFrom]         DATETIME2 (0)  NULL,
    [ValidTo]           DATETIME2 (0)  NULL,
    [IsCurrent]         BIT            NULL
)
WITH (HEAP, DISTRIBUTION = HASH([ProgrammeHash]));
GO

