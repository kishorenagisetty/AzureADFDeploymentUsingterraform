CREATE VIEW [DV].[Base_JobCategory_Adapt]
AS (
SELECT 
	CONVERT(CHAR(66),JC.JobCategoryKey,1)				AS JobCategoryHash,
	CAST('ADAPT.PROP_JOB_CAT' AS NVARCHAR(MAX))			AS RecordSource,
	JCN.[Description]									AS JobCategory,
	JCG.JobCategoryGroup								AS JobCategoryGroupKey
FROM 
	DV.HUB_JobCategory									AS JC
	INNER JOIN
	DV.SAT_JobCategory_Adapt_Core						AS JCC
	ON JCC.JobCategoryKey = JC.JobCategoryKey
	AND JCC.IsCurrent = 1
	LEFT JOIN
	(
		Select 
			a.Reference, 
			MAX(a.JobCategoryGroupID)					AS JobCategoryGroup
		from
		ADAPT.Bridge_JobCategory as a
		Group by 
		a.Reference
	) AS JCG
	ON JCC.Reference = JCG.Reference
	LEFT JOIN
	DV.Dimension_References								AS JCN
	ON JCN.Code = JCC.JobCategory 
	AND JCN.ReferenceSource = 'ADAPT.MD_MULTI_NAMES' 

);
GO

