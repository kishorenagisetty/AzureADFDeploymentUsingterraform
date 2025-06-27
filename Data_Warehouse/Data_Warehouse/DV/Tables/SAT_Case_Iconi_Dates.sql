CREATE TABLE [DV].[SAT_Case_Iconi_Dates] (
    [CaseHash]                                    BINARY (32)    NULL,
    [CaseKey]                                     NVARCHAR (100) NULL,
    [StartDate]                                   DATE           NULL,
    [LeaveDate]                                   DATE           NULL,
    [LeftDate]                                    DATE           NULL,
    [DidNotStartDate]                             DATE           NULL,
    [CaseLoadReviewDate]                          DATE           NULL,
    [DisengagedDate]                              DATE           NULL,
    [TransactionAddedDate]                        DATE           NULL,
    [FollowUpDate]                                DATE           NULL,
    [EmployabilityPrapAcknowledgeDate]            DATE           NULL,
    [EmployabilityPrapStartAcknowledgeDate]       DATE           NULL,
    [EmployabilityPrapDnaAcknowledgeDate]         DATE           NULL,
    [EmployabilityPrapEarlyLeaverAcknowledgeDate] DATE           NULL,
    [EmployabilityPrapJobOutcomePaidDate]         DATE           NULL,
    [EmployabilityLastUpdatedDate]                DATE           NULL,
    [ContentHash]                                 BINARY (32)    NULL,
    [ValidFrom]                                   DATETIME2 (0)  NULL,
    [ValidTo]                                     DATETIME2 (0)  NULL,
    [IsCurrent]                                   BIT            NULL
)
WITH (HEAP, DISTRIBUTION = HASH([CaseHash]));
GO

