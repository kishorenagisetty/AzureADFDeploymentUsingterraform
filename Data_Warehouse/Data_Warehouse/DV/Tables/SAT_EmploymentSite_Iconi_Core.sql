CREATE TABLE [DV].[SAT_EmploymentSite_Iconi_Core] (
    [EmploymentSiteHash]        BINARY (32)    NULL,
    [EmploymentSiteKey]         NVARCHAR (100) NULL,
    [EmployerStatus]            NVARCHAR (MAX) NULL,
    [EmployerSource]            NVARCHAR (MAX) NULL,
    [EmployerSIC]               NVARCHAR (MAX) NULL,
    [EmployerNumberOfEmployees] NVARCHAR (MAX) NULL,
    [EmployerName]              NVARCHAR (MAX) NULL,
    [EmployerIncorporationType] NVARCHAR (MAX) NULL,
    [ContentHash]               BINARY (32)    NULL,
    [ValidFrom]                 DATETIME2 (0)  NULL,
    [ValidTo]                   DATETIME2 (0)  NULL,
    [IsCurrent]                 BIT            NULL
)
WITH (HEAP, DISTRIBUTION = HASH([EmploymentSiteHash]));

