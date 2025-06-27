-- This is for testing by Sarath Koritala
CREATE VIEW [ADAPT].[HUB_EmploymentSite] AS (
SELECT 
	CONCAT_WS('|','ADAPT',REFERENCE)			AS EmploymentSiteKey,
	'ADAPT.PROP_CLIENT_GEN'						AS RecordSource,
	ValidFrom									AS ValidFrom,
	ValidTo										AS ValidTo,
	IsCurrent									AS IsCurrent


FROM 
	ADAPT.PROP_CLIENT_GEN 
	);
GO