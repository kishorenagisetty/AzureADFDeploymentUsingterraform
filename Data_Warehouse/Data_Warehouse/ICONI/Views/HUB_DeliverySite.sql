CREATE VIEW [ICONI].[HUB_DeliverySite] 
-- ===============================================================
-- Author:	Sagar Kadiyala
-- Create date: 23/01/2024
-- Ticket Ref: #30330
-- Name: [ICONI].[HUB_DeliverySite]
-- Description: Runs the Hub DeliverySite Data
-- Revisions:
-- 30330 - SK - 23/01/2024 - Amended view to bring in Refugee data via Union
-- ===============================================================
AS
SELECT DISTINCT
    CONCAT_WS('|', 'ICONI', site_id) AS DeliverySiteKey
  , 'ICONI.Site_Restart'             AS RecordSource
  , cast(site_added_date as date)    AS ValidFrom
  , '9999-12-31'                     AS ValidTo
  , 1                                AS IsCurrent
FROM ICONI.[vBIRestart_Site]            S
    join ICONI.[vBIRestart_ProjectSite] PS
        on S.Site_id = PS.ps_site_id
UNION
SELECT DISTINCT
    CONCAT_WS('|', 'ICONI', site_id) AS DeliverySiteKey
  , 'ICONI.Site_Refugee'             AS RecordSource
  , cast(site_added_date as date)    AS ValidFrom
  , '9999-12-31'                     AS ValidTo
  , 1                                AS IsCurrent
FROM ICONI.[vBIRefugee_Site]            S
    join ICONI.[vBIRefugee_ProjectSite] PS
        on S.Site_id = PS.ps_site_id;
GO
