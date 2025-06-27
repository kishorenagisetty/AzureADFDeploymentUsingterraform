CREATE TABLE [LZ].[AtW_LK_Prap_Payments] (
    [PONumber]              VARCHAR (20) NULL,
    [SupportPlan_ClaimDate] DATE         NULL,
    [SixMonth_ClaimDate]    DATE         NULL,
    [NineMonth_ClaimDate]   DATE         NULL,
    [Sys_RunID]             INT          NULL,
    [Sys_LoadDate]          DATETIME     NULL
)
WITH (HEAP, DISTRIBUTION = ROUND_ROBIN);

