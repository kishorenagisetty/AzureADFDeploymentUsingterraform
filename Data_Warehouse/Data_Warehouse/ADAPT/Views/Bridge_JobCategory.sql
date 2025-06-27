CREATE VIEW [ADAPT].[Bridge_JobCategory] AS WITH JobCategory AS (

	SELECT DISTINCT
		ROW_NUMBER() OVER(PARTITION BY 'JobCategory' ORDER BY A.JobCategory) AS JobCategoryID, 
		A.JobCategory,
		B.[Description] AS JobCategoryName
	FROM
		[ADAPT].[SAT_JobCategory_ADAPT_Core]	AS A
		LEFT JOIN DV.Dimension_References		AS B 
		ON B.Code = A.JobCategory
		AND B.REFERENCESource = 'ADAPT.MD_MULTI_NAMES' 
		AND B.Category = 'Code'
	GROUP BY 
		A.JobCategory,
		B.[Description]
	)

	,JobCategoryGroup 
	AS (
		SELECT 
			REFERENCE														AS REFERENCE, 
			JobCategory														AS JobCategory, 
			DENSE_RANK() OVER(PARTITION BY 'REFERENCE' ORDER BY REFERENCE)	AS JobCategoryGroupID
		FROM 
			[ADAPT].[SAT_JobCategory_ADAPT_Core]
		)

SELECT 
	REFERENCE, 
	JobCategory, 
	JobCategoryGroupID

FROM 
	JobCategoryGroup;
GO
