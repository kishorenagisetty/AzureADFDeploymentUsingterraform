CREATE TABLE [DV].[SAT_Case_Iconi_Dates_Refugee]
    (
        [CaseHash]               [binary](32)   NULL,
        [CaseKey]                [varchar](18)  NOT NULL,
        [StartDate]              [date]         NULL,
        [LeaveDate]              [date]         NULL,
        [LeftDate]               [date]         NULL,
        [DidNotStartDate]        [date]         NULL,
        [CaseLoadReviewDate]     [date]         NULL,
        [DisengagedDate]         [date]         NULL,
        [TransactionAddedDate]   [date]         NULL,
        [FollowUpDate]           [date]         NULL,
        [ReferralDate]           [date]         NULL,
        [EligibilityDateOfIssue] [date]         NULL,
        [LastUpdatedDate]        [date]         NULL,
        [DateArrivalInUK]        [date]         NULL,
        [WelcomePackIssueDate]   [date]         NULL,
        [ContentHash]            [binary](32)   NULL,
        [ValidFrom]              [datetime2](0) NULL,
        [ValidTo]                [datetime2](0) NULL,
        [IsCurrent]              [bit]          NULL
    )
WITH (DISTRIBUTION=HASH([CaseHash]), HEAP)
GO
