CREATE TABLE [DV].[HUB_RequestingOrganisation] (
    [RequestingOrganisationHash] BINARY (32)    NULL,
    [RequestingOrganisationKey]  NVARCHAR (100) NULL,
    [RecordSource]               VARCHAR (50)   NULL,
    [ValidFrom]                  DATETIME2 (0)  NULL
)
WITH (HEAP, DISTRIBUTION = HASH([RequestingOrganisationHash]));

