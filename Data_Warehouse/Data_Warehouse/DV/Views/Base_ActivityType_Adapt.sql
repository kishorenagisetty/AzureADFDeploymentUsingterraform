CREATE VIEW [DV].[Base_ActivityType_Adapt] AS SELECT
CONVERT(CHAR(66), CAST(HASHBYTES('SHA2_256',CAST(CAST(R.Code AS BIGINT) AS VARCHAR)) AS BINARY(32)),1) AS 'ActivityTypeHash'
,'ADAPT.PROP_ACTIVITY_GEN' AS RecordSource
,R.[Description] AS ActivityType
,R.Code AS ActivityTypeCode
,'Unknown' AS ActivityRole
,CASE WHEN AC.Category IS NULL THEN 'Unknown' ELSE AC.Category END AS ActivityCategory
FROM DV.Dimension_References R 
LEFT JOIN ELT.ActivityCategories AC ON AC.ActivityType = R.[Description]
WHERE Code IN (
SELECT DISTINCT ActivityType FROM DV.SAT_Activity_Adapt_Core A 
WHERE A.ActivityType IS NOT NULL);
GO
