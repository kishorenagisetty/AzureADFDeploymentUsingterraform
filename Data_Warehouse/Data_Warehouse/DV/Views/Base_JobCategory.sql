CREATE VIEW [DV].[Base_JobCategory]
AS (
	SELECT * FROM [DV].[Base_JobCategory_Default]
UNION ALL
	SELECT * FROM [DV].[Base_JobCategory_Adapt]
);
GO

