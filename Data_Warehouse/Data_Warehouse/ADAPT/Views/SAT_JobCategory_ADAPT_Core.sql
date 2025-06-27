CREATE VIEW [ADAPT].[SAT_JobCategory_ADAPT_Core] AS (
SELECT
	CONCAT_WS('|','ADAPT',REFERENCE)			AS JobCategoryKey,
	'ADAPT.PROP_JOB_GEN'						AS RecordSource,
	JOB_CATEGORY								AS JobCategory,
	REFERENCE									AS REFERENCE,
	ValidFrom									AS ValidFrom,
	ValidTo										AS ValidTo,
	IsCurrent									AS IsCurrent


FROM 
	 ADAPT.PROP_JOB_CAT					AS PJC
WHERE 1 = 0 --Disable (For business to refedine requirement)
	);
GO
