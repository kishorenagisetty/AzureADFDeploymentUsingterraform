CREATE TABLE [DV].[SAT_RequestingOrganisation_Adapt_Core] (
    [RequestingOrganisationHash] BINARY (32)    NULL,
    [RequestingOrganisationKey]  NVARCHAR (MAX) NULL,
    [RequestingOrganisation]     NVARCHAR (MAX) NULL,
    [AddressLine1]               NVARCHAR (MAX) NULL,
    [AddressLine2]               NVARCHAR (MAX) NULL,
    [Town]                       NVARCHAR (MAX) NULL,
    [County]                     NVARCHAR (MAX) NULL,
    [Country]                    NVARCHAR (MAX) NULL,
    [PostCode]                   NVARCHAR (MAX) NULL,
    [TelephoneNo]                NVARCHAR (MAX) NULL,
    [ContentHash]                BINARY (32)    NULL,
    [ValidFrom]                  DATETIME2 (0)  NULL,
    [ValidTo]                    DATETIME2 (0)  NULL,
    [IsCurrent]                  BIT            NULL
)
WITH (HEAP, DISTRIBUTION = HASH([RequestingOrganisationHash]));

