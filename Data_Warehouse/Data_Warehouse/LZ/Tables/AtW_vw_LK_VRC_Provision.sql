CREATE TABLE [LZ].[AtW_vw_LK_VRC_Provision] (
    [VRC]          NVARCHAR (100) NULL,
    [Provision]    VARCHAR (50)   NULL,
    [Sys_RunID]    INT            NULL,
    [Sys_LoadDate] DATETIME       NULL
)
WITH (HEAP, DISTRIBUTION = ROUND_ROBIN);

