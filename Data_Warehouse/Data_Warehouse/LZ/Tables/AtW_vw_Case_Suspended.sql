CREATE TABLE [LZ].[AtW_vw_Case_Suspended] (
    [noteid]       INT           NULL,
    [caseId]       INT           NULL,
    [createdDate]  DATETIME      NULL,
    [createdBy]    VARCHAR (255) NULL,
    [active]       BIT           NULL,
    [Sys_RunID]    INT           NULL,
    [Sys_LoadDate] DATETIME      NULL
)
WITH (HEAP, DISTRIBUTION = ROUND_ROBIN);

