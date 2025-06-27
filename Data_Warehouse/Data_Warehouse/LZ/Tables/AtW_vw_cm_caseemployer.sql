CREATE TABLE [LZ].[AtW_vw_cm_caseemployer] (
    [caseEmployerId]       INT           NULL,
    [caseId]               INT           NULL,
    [contactMethodId]      INT           NULL,
    [lineManagerName]      VARCHAR (11)  NULL,
    [phoneNumber]          VARCHAR (11)  NULL,
    [email]                VARCHAR (11)  NULL,
    [organisationName]     VARCHAR (255) NULL,
    [organisationSizeId]   INT           NULL,
    [organisationTypeId]   INT           NULL,
    [organisationSectorId] INT           NULL,
    [Sys_RunID]            INT           NULL,
    [Sys_LoadDate]         DATETIME      NULL
)
WITH (HEAP, DISTRIBUTION = ROUND_ROBIN);

