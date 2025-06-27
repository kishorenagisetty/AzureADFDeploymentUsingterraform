CREATE VIEW [ICONI].[vBIRefugee_Site]
-- ===============================================================
-- Author:	Sagar Kadiyala
-- Create date: 23/01/2024
-- Ticket Ref: #30330
-- Name: [ICONI].[vBIRefugee_Site]
-- Description: Runs the Hub DeliverySite Data
-- Revisions:
-- 30330 - SK - 23/01/2024 - Amended view to bring in Refugee data via Union
-- ===============================================================
AS 
SELECT [site_id], [site_name], [site_type], [site_admin_contact_details_id], [site_agency_id], [site_parent_site_id], [site_group], [site_added_date], [site_last_updated_date], [ValidFrom], [ValidTo], [row_sha2], CAST(1 AS BIT) AS IsCurrent FROM DELTA.ICONI_vBIRefugee_Site;