CREATE VIEW [ICONI].[vBIRefugee_ProjectSite]
-- ===============================================================
-- Author:	Sagar Kadiyala
-- Create date: 23/01/2024
-- Ticket Ref: #30330
-- Name: [ICONI].[vBIRefugee_ProjectSite]
-- Description: Runs the ProjectSite Data
-- Revisions:
-- 30330 - SK - 23/01/2024 - Amended view to bring in Refugee data via Union
-- ===============================================================
AS SELECT [project_site_id], [ps_site_id], [ps_site_name], [ps_parent_agency_id], [ps_parent_agency_name], [ps_contract_area], [ps_area], [ValidFrom], [ValidTo], [row_sha2], CAST(1 AS BIT) AS IsCurrent FROM DELTA.ICONI_vBIRefugee_ProjectSite;
