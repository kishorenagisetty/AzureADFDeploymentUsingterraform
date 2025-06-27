CREATE VIEW [ICONI].[vBIRestart_Intervention_Service_Site] AS 
SELECT 
  [intervention_service_site_id], 
  [iscs_intervention_service_id], 
  --[iscs_site_id], 
  [ValidFrom], 
  [ValidTo], 
  CAST(1 AS BIT) AS IsCurrent 
FROM 
  DELTA.ICONI_vBIRestart_Intervention_Service_Site;