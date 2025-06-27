CREATE TABLE [DV].[SAT_DeliveryOrganisation_Iconi_Core] (
    [DeliveryOrganisationHash] BINARY (32)    NULL,
    [DeliveryOrganisationKey]  NVARCHAR (100) NULL,
    [AgencyContactDetailsId]   INT            NULL,
    [AgencyName]               NVARCHAR (MAX) NULL,
    [AgencyShortName]          NVARCHAR (MAX) NULL,
    [AgencyProvideService]     BIT            NULL,
    [AgencyAddedDate]          DATETIME2 (0)  NULL,
    [AgencyNotes]              NVARCHAR (MAX) NULL,
    [AgencyType]               NVARCHAR (MAX) NULL,
    [AgencyLastUpdatedDate]    DATETIME2 (0)  NULL,
    [ContentHash]              BINARY (32)    NULL,
    [ValidFrom]                DATETIME2 (0)  NULL,
    [ValidTo]                  DATETIME2 (0)  NULL,
    [IsCurrent]                BIT            NULL
)
WITH (HEAP, DISTRIBUTION = HASH([DeliveryOrganisationHash]));

