CREATE TABLE [DV].[HUB_EmploymentSite] (
    [EmploymentSiteHash] BINARY (32)    NULL,
    [EmploymentSiteKey]  NVARCHAR (100) NULL,
    [RecordSource]       VARCHAR (50)   NULL,
    [ValidFrom]          DATETIME2 (0)  NULL
)
WITH (HEAP, DISTRIBUTION = HASH([EmploymentSiteHash]));

