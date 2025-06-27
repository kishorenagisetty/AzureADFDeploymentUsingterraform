CREATE VIEW [DV].[Dimension_JobCategory]
AS SELECT
	 [JobCategoryHash]
	,[RecordSource]
	,[JobCategory]
	,[JobCategoryGroupKey]

	FROM (
		SELECT
		 [JobCategoryHash]
		,row_number() OVER (PARTITION BY [JobCategoryHash] ORDER BY [JobCategoryHash]) rn
		,[RecordSource]
		,[JobCategory]
		,[JobCategoryGroupKey]
		FROM [DV].[Base_JobCategory]
		) src
WHERE (rn = 1);