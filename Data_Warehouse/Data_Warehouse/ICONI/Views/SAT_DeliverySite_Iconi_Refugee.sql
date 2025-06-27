CREATE VIEW [ICONI].[SAT_DeliverySite_Iconi_Refugee] 
-- ===============================================================
-- Author:	Sagar Kadiyala
-- Create date: 23/01/2024
-- Ticket Ref: #30330
-- Name: [ICONI].[SAT_DeliverySite_Iconi_Refugee] 
-- Description: Runs the SAT DeliverySite Data
-- Revisions:
-- 30330 - SK - 23/01/2024 - Created a new view to bring in Refugee data via Union
-- ===============================================================
AS 
SELECT DISTINCT
    CONCAT_WS('|', 'ICONI', site_id)                       AS DeliverySiteKey
  , CONCAT_WS('|', PS.ps_parent_agency_name, ps_site_name) AS DeliverySiteName
  , ps.ps_site_name                                        AS ProjectSiteName
  , s.site_name                                            AS SiteName
  , s.site_type                                            AS SiteType
  , s.site_admin_contact_details_id                        AS SiteAdminContactDetailsId
  , CAST(s.site_added_date AS DATETIME)                    AS SiteAddedDate
  , CAST(s.site_last_updated_date AS DATETIME)             AS SiteLastUpdatedDate
  , PS.Project_Site_id                                     AS ProjectSiteId
  , PS.ps_parent_agency_name                               AS ParentAgencyName
  , PS.ps_parent_agency_id                                 AS ParentAgencyId
  , PS.ps_contract_area                                    AS ProjectSiteContractArea
  , PS.ps_area                                             AS ProjectSiteArea
  , cast(site_added_date as date)                          AS ValidFrom
  , '9999-12-31'                                           AS ValidTo
  , 1                                                      AS IsCurrent
FROM ICONI.[vBIRefugee_Site]            S
    JOIN ICONI.[vBIRefugee_ProjectSite] PS
        ON S.Site_id = PS.ps_site_id
GO