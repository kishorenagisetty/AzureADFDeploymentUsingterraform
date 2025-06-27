--This is for testing by Sagar Kadiyala
CREATE VIEW [ADAPT].[HUB_JobCategory] AS (
SELECT DISTINCT
	CONCAT_WS('|','ADAPT',REFERENCE)			AS JobCategoryKey,
	'ADAPT.PROP_JOB_CAT'						AS RecordSource,
	ValidFrom									AS ValidFrom,
	ValidTo										AS ValidTo,
	IsCurrent									AS IsCurrent


FROM 
	ADAPT.PROP_JOB_CAT 
	);
GO
