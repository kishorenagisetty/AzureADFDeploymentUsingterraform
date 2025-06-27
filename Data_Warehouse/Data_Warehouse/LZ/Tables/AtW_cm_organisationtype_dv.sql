CREATE TABLE [LZ].[AtW_cm_organisationtype_dv] (
    [organisationTypeId] INT           NULL,
    [type]               VARCHAR (255) NULL,
    [active]             BIT           NULL,
    [Sys_RunID]          INT           NULL,
    [Sys_LoadDate]       DATETIME      NULL
)
WITH (HEAP, DISTRIBUTION = ROUND_ROBIN);

