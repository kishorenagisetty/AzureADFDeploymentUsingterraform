CREATE TABLE [LZ].[AtW_cm_slatype_dv] (
    [slaTypeId]         INT           NULL,
    [previousSLATypeId] INT           NULL,
    [slaType]           VARCHAR (255) NULL,
    [associatedTask]    VARCHAR (255) NULL,
    [day]               INT           NULL,
    [month]             INT           NULL,
    [workdays]          INT           NULL,
    [slaDeadlineTypeId] INT           NULL,
    [isKpi]             BIT           NULL,
    [sortOrder]         INT           NULL,
    [active]            BIT           NULL,
    [Sys_RunID]         INT           NULL,
    [Sys_LoadDate]      DATETIME      NULL
)
WITH (HEAP, DISTRIBUTION = ROUND_ROBIN);

