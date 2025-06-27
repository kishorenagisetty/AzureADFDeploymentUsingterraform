CREATE TABLE [DV].[SAT_Case_Iconi_Core] (
    [CaseHash]                       BINARY (32)    NULL,
    [CaseKey]                        NVARCHAR (100) NULL,
    [CaseID]                         VARCHAR (33)   NULL,
    [CaseStatus]                     NVARCHAR (MAX) NULL,
    [LeaveReason]                    NVARCHAR (MAX) NULL,
    [WorkReadinessStatus]            NVARCHAR (MAX) NULL,
    [AdvisorAcknowledgementRequired] DATETIME2 (0)  NULL,
    [ExitReasonOther]                NVARCHAR (MAX) NULL,
    [OnwardDestination]              NVARCHAR (MAX) NULL,
    [OnwardDestinationOther]         NVARCHAR (MAX) NULL,
    [LeftReason]                     NVARCHAR (MAX) NULL,
    [LeftReasonOther]                NVARCHAR (MAX) NULL,
    [LeftStage]                      NVARCHAR (MAX) NULL,
    [LeftStageOther]                 NVARCHAR (MAX) NULL,
    [DidNotStartReason]              NVARCHAR (MAX) NULL,
    [DidNotStartReasonOther]         NVARCHAR (MAX) NULL,
    [SignedPrivacyNoticeUploaded]    NVARCHAR (MAX) NULL,
    [PrivacyRightsExercised]         NVARCHAR (MAX) NULL,
    [PrivacyRightsDetails]           NVARCHAR (MAX) NULL,
    [DisengagedReason]               NVARCHAR (MAX) NULL,
    [FrequencyOfContact]             NVARCHAR (MAX) NULL,
    [TranOwnerUserId]                INT            NULL,
    [Outcome]                        NVARCHAR (MAX) NULL,
    [PackIssued]                     NVARCHAR (MAX) NULL,
    [ContentHash]                    BINARY (32)    NULL,
    [ValidFrom]                      DATETIME2 (0)  NULL,
    [ValidTo]                        DATETIME2 (0)  NULL,
    [IsCurrent]                      BIT            NULL
)
WITH (HEAP, DISTRIBUTION = HASH([CaseHash]));
GO

