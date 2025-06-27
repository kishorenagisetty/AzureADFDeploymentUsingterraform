CREATE TABLE [DV].[SAT_Case_Adapt_Dates] (
    [CaseHash]           BINARY (32)    NULL,
    [CaseKey]            NVARCHAR (100) NULL,
    [StartDate]          DATE           NULL,
    [StartVerifiedDate]  DATE           NULL,
    [LeaveDate]          DATE           NULL,
    [LeaveVerifiedDate]  DATE           NULL,
    [ProjectedLeaveDate] DATE           NULL,
    [ReportDate]         DATE           NULL,
    [ReferralSLADate]    DATE           NULL,
    [ContentHash]        BINARY (32)    NULL,
    [ValidFrom]          DATETIME2 (0)  NULL,
    [ValidTo]            DATETIME2 (0)  NULL,
    [IsCurrent]          BIT            NULL
)
WITH (HEAP, DISTRIBUTION = HASH([CaseHash]));

