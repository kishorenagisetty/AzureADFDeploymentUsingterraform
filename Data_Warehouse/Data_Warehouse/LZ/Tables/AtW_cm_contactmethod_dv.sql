CREATE TABLE [LZ].[AtW_cm_contactmethod_dv] (
    [contactMethodId] INT           NULL,
    [method]          VARCHAR (255) NULL,
    [active]          BIT           NULL,
    [Sys_RunID]       INT           NULL,
    [Sys_LoadDate]    DATETIME      NULL
)
WITH (HEAP, DISTRIBUTION = ROUND_ROBIN);

