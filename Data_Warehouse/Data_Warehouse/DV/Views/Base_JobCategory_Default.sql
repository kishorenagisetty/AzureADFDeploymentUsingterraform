CREATE VIEW [DV].[Base_JobCategory_Default]
AS (
SELECT
	CONVERT(CHAR(66),CAST(0x0 AS BINARY(32)),1)			AS JobCategoryHash,
	CAST('Unknown' AS NVARCHAR(MAX))					AS RecordSource,	
	CAST('Unknown' AS NVARCHAR(MAX))					AS JobCategory,
	CAST(0 AS BIGINT)									AS JobCategoryGroupKey
);
GO

