CREATE VIEW [ICONI].[HUB_EmploymentSite]
AS SELECT 
CONCAT_WS('|','ICONI',O.organisation_id) AS EmploymentSiteKey,
'ICONI.Organisation' AS RecordSource,
O.ValidFrom,
O.ValidTo,
O.IsCurrent
FROM [ICONI].[vBICommon_Organisation] as O;