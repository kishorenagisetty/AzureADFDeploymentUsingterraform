CREATE VIEW [ADAPT].[LINK_EmploymentSite_Vacancy] AS 
-- Author: 
-- Create date: DD/MM/YYY
-- Ticket Reference:  <Dev Ops Ticket Reference>
-- Description: <Description regarding object>
-- Revisions:
-- 28/09/2023 - <PH,SK> - <28498> - <Add Adapt Entity table in the join to get only active sites>
SELECT
	CONCAT_WS('|','ADAPT', CAST(Sites.Site_ID AS INT)) AS EmploymentSiteKey,
	CONCAT_WS('|','ADAPT',CAST(J.JOB_ID AS INT)) AS VacancyKey,
	'ADAPT.PROP_CLIENT_GEN' AS RecordSource,
	J.ValidFrom, 
	J.ValidTo, 
	J.IsCurrent
FROM
	ADAPT.PROP_JOB_GEN			AS J
LEFT OUTER JOIN (SELECT DISTINCT jj.CLIENT, jj.JOB
						FROM ADAPT.PROP_X_CLIENT_JOB jj						
				) SiteLk ON SiteLk.JOB = J.REFERENCE
INNER JOIN (
		SELECT REFERENCE AS Site_ID, NAME AS SiteName 
		FROM ADAPT.PROP_CLIENT_GEN  WITH (NOLOCK)
		WHERE 
		ISNULL(S_ROLE,'') = 'Y' OR ISNULL(BS_ROLE,'') = 'Y' OR ISNULL(CP_ROLE,'') = 'Y'
) Sites ON sites.Site_ID = SiteLk.CLIENT
JOIN  DELTA.ADAPT_ENTITY_TABLE			ent on ent.[ENTITY_ID] = Sites.Site_ID -- 28/09/2023 - <PH,SK> - <28498>
WHERE ent.[STATUS] = 'Y' -- 28/09/2023 - <PH,SK> - <28498>
GO
