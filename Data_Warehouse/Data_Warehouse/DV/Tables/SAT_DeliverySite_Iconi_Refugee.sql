CREATE TABLE [DV].[SAT_DeliverySite_Iconi_Refugee]
    (
        [DeliverySiteHash]          BINARY(32)    NULL,
        [DeliverySiteKey]           NVARCHAR(100) NULL,
        [DeliverySiteName]          NVARCHAR(MAX) NOT NULL,
        [ProjectSiteName]           NVARCHAR(MAX) NULL,
        [SiteName]                  NVARCHAR(MAX) NULL,
        [SiteType]                  NVARCHAR(MAX) NULL,
        [SiteAdminContactDetailsId] INT           NULL,
        [SiteAddedDate]             DATETIME2(0)  NULL,
        [SiteLastUpdatedDate]       DATETIME2(0)  NULL,
        [ProjectSiteId]             INT           NULL,
        [ParentAgencyName]          NVARCHAR(MAX) NULL,
        [ParentAgencyId]            INT           NULL,
        [ProjectSiteContractArea]   NVARCHAR(MAX) NULL,
        [ProjectSiteArea]           NVARCHAR(MAX) NULL,
        [ContentHash]               BINARY(32)    NULL,
        [ValidFrom]                 DATETIME2(0)  NULL,
        [ValidTo]                   DATETIME2(0)  NULL,
        [IsCurrent]                 BIT           NULL
    )
WITH (HEAP, DISTRIBUTION=HASH([DeliverySiteHash]));


GO


