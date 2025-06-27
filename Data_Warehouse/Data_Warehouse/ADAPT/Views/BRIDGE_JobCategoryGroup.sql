CREATE VIEW [ADAPT].[BRIDGE_JobCategoryGroup]
AS (
Select 
	CONCAT_WS('|','ADAPT',REFERENCE)			AS JobCategoryKey,
	JC.JOB_CATEGORY								AS JobCategoryGroupKey,
	'ADAPT.PROP_JOB_CAT'						AS RecordSource,
	ValidFrom									AS ValidFrom,
	ValidTo										AS ValidTo,
	IsCurrent									AS IsCurrent


from 
	ADAPT.PROP_JOB_CAT AS JC
	);
