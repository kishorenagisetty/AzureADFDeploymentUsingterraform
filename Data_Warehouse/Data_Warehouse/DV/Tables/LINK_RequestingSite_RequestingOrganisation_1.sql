CREATE TABLE [DV].[LINK_RequestingSite_RequestingOrganisation] (
    [RequestingSite_RequestingOrganisationHash] BINARY (32)   NULL,
    [RequestingSiteHash]                        BINARY (32)   NULL,
    [RequestingOrganisationHash]                BINARY (32)   NULL,
    [RecordSource]                              VARCHAR (50)  NULL,
    [ValidFrom]                                 DATETIME2 (0) NULL
)
WITH (HEAP, DISTRIBUTION = HASH([RequestingSiteHash]));

