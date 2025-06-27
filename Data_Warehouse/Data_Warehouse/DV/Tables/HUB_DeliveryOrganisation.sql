CREATE TABLE [DV].[HUB_DeliveryOrganisation] (
    [DeliveryOrganisationHash] BINARY (32)    NULL,
    [DeliveryOrganisationKey]  NVARCHAR (100) NULL,
    [RecordSource]             VARCHAR (50)   NULL,
    [ValidFrom]                DATETIME2 (0)  NULL
)
WITH (HEAP, DISTRIBUTION = HASH([DeliveryOrganisationHash]));

