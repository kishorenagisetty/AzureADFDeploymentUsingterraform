CREATE VIEW [ADAPT].[HUB_Vacancy] AS (
Select 
	CONCAT_WS('|','ADAPT',JOB_ID)				AS VacancyKey,
	'ADAPT.PROP_JOB_GEN'						AS RecordSource,
	ValidFrom									AS ValidFrom,
	ValidTo										AS ValidTo,
	IsCurrent									AS IsCurrent


from 
	ADAPT.PROP_JOB_GEN
	);