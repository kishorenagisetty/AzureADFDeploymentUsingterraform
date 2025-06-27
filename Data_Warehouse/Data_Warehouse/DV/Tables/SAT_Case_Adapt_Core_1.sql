CREATE TABLE [DV].[SAT_Case_Adapt_Core] (
    [CaseHash]              BINARY (32)    NULL,
    [CaseKey]               NVARCHAR (100) NULL,
    [CaseStatus]            BIGINT            NULL,
    [CaseDevelopmentStatus] BIGINT         NULL,
    [CaseModuleStatus]      BIGINT            NULL,
    [PrimaryBenefit]        BIGINT         NULL,
    [LeaveReason]           BIGINT         NULL,
    [WorkRedinessStatus]    BIGINT         NULL,
    [InitStrand]            BIGINT         NULL,
    [ConfStrand]            BIGINT         NULL,
    [ContentHash]           BINARY (32)    NULL,
    [ValidFrom]             DATETIME2 (0)  NULL,
    [ValidTo]               DATETIME2 (0)  NULL,
    [IsCurrent]             BIT            NULL
)
WITH (HEAP, DISTRIBUTION = HASH([CaseHash]));

