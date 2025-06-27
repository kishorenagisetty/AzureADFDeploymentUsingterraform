CREATE VIEW [REP].[dim_deliverySite] 
-- ===============================================================
-- Author:	Sagar Kadiyala
-- Create date: 31/01/2024
-- Ticket Ref: #30330
-- Name: [REP].[dim_deliverySite] 
-- Description: Dimension Table
-- Revisions:
-- 30330 - SK - 31/01/2024 - Created a Dimension View for delivery Sites
-- ===============================================================
AS
SELECT CONVERT(char(66), hds.DeliverySiteHash, 1)                      as DeliverySiteHash
     , hds.RecordSource                                                AS RecordSource
     , sdr.DeliverySiteKey                                             AS DeliverySiteKey
     , replace(cast(sdr.DeliverySiteKey as varchar(25)), 'ICONI|', '') AS DeliverySiteKeyNumber
     , ProjectSiteName                                                 AS DeliverySiteName
     , ProjectSiteId                                                   AS ProjectSiteId
     , SiteType                                                        AS SiteType
     , ParentAgencyName                                                AS ParentAgencyName
     , ProjectSiteContractArea                                         AS ProjectSiteContractArea
FROM [DV].[HUB_DeliverySite]                   hds
    JOIN [DV].[SAT_DeliverySite_Iconi_Refugee] sdr
        ON hds.DeliverySiteHash = sdr.DeliverySiteHash
WHERE sdr.IsCurrent = 1;
Go
