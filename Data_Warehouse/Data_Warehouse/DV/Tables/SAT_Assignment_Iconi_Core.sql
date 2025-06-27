CREATE TABLE [DV].[SAT_Assignment_Iconi_Core] (
    [AssignmentHash]                  BINARY (32)     NULL,
    [AssignmentKey]                   NVARCHAR (100)  NULL,
    [AssignmentID]                    VARCHAR (33)    NULL,
    [AssignmentTitle]                 NVARCHAR (MAX)  NULL,
    [AssignmentStartContractType]     NVARCHAR (MAX)  NULL,
    [AssignmentLeaveDate]             DATETIME2 (0)   NULL,
    [AssignmentType]                  NVARCHAR (MAX)  NULL,
    [AssignmentLeaveReason]           NVARCHAR (MAX)  NULL,
    [AssignmentStatus]                NVARCHAR (MAX)  NULL,
    [AssignmentStartDate]             DATETIME2 (0)   NULL,
    [SelfEmployed]                    NVARCHAR (MAX)  NULL,
    [FailedAssignmentStartDate]       DATETIME2 (0)   NULL,
    [AssignmentOwningEmployee]        INT             NULL,
    [AssignmentStartVerificationDate] DATETIME2 (0)   NULL,
    [TempPerm]                        NVARCHAR (MAX)  NULL,
    [WageCategory]                    NVARCHAR (MAX)  NULL,
    [WeeklyHours]                     DECIMAL (19, 2) NULL,
    [AssignmentFollowUpDate]          DATETIME2 (0)   NULL,
    [AssignmentLeavingReasonOther]    NVARCHAR (MAX)  NULL,
    [AssignmentSource]                NVARCHAR (MAX)  NULL,
    [AssignmentProgressionType]       NVARCHAR (MAX)  NULL,
    [AssignmentAddedDate]             DATETIME2 (0)   NULL,
    [AssignmentAddedBy]               INT             NULL,
    [AssignmentLastUpdatedDate]       DATETIME2 (0)   NULL,
    [AssignmentVerificationStatus]    NVARCHAR (MAX)  NULL,
    [ContentHash]                     BINARY (32)     NULL,
    [ValidFrom]                       DATETIME2 (0)   NULL,
    [ValidTo]                         DATETIME2 (0)   NULL,
    [IsCurrent]                       BIT             NULL
)
WITH (HEAP, DISTRIBUTION = HASH([AssignmentHash]));
GO

