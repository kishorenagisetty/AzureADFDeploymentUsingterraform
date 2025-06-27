CREATE TABLE [LZ].[AtW_vw_cm_gender_dv] (
    [genderId]     INT          NULL,
    [gender]       VARCHAR (11) NULL,
    [active]       BIT          NULL,
    [Sys_RunID]    INT          NULL,
    [Sys_LoadDate] DATETIME     NULL
)
WITH (HEAP, DISTRIBUTION = ROUND_ROBIN);

