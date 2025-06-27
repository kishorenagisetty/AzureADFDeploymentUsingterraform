CREATE TABLE [DV].[SAT_Case_Iconi_Eligibility] (
    [CaseHash]                                  BINARY (32)    NULL,
    [CaseKey]                                   NVARCHAR (100) NULL,
    [CredReceipt]                               NVARCHAR (MAX) NULL,
    [SustainedEarnings]                         NVARCHAR (MAX) NULL,
    [ToWork]                                    NVARCHAR (MAX) NULL,
    [EnglandWales]                              NVARCHAR (MAX) NULL,
    [WorkingAge]                                NVARCHAR (MAX) NULL,
    [DwpEmployment]                             NVARCHAR (MAX) NULL,
    [NotInControlGroupOrPublicSectorComparator] NVARCHAR (MAX) NULL,
    [EmployabilityExoffender]                   NVARCHAR (MAX) NULL,
    [EligibilityConfirmed]                      NVARCHAR (MAX) NULL,
    [EmploymentInterests]                       NVARCHAR (MAX) NULL,
    [ContentHash]                               BINARY (32)    NULL,
    [ValidFrom]                                 DATETIME2 (0)  NULL,
    [ValidTo]                                   DATETIME2 (0)  NULL,
    [IsCurrent]                                 BIT            NULL
)
WITH (HEAP, DISTRIBUTION = HASH([CaseHash]));
GO

