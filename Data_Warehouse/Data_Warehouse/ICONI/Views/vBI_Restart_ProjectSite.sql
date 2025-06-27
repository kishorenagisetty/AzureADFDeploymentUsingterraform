CREATE VIEW [ICONI].[vBIRestart_ProjectSite] AS 
SELECT 
  [project_site_id], 
  [ps_site_id], 
  [ps_site_name], 
  [ps_parent_agency_id], 
  [ps_parent_agency_name], 
  --[Contract_Area], 
  --[Area], 
  [ValidFrom], 
  [ValidTo], 
  CAST(1 AS BIT) AS IsCurrent 
FROM 
  DELTA.ICONI_vBIRestart_ProjectSite;
GO