CREATE VIEW DV.Dimension_WorkReadiness

AS 
SELECT DISTINCT 
	 CASE WHEN Code = -1 THEN CONVERT(CHAR(66),CAST(0x0 AS BINARY(32)),1) 
			ELSE CONVERT(CHAR(66),CAST(HASHBYTES('SHA2_256',CAST(CAST(Code AS BIGINT) AS VARCHAR)) AS BINARY(32)),1)
	 END AS WorkReadinessStatusHash
    ,[Description] AS WorkReadinessDescription
FROM DV.Dimension_References
WHERE Category = 'CODE' AND ReferenceSource = 'ADAPT.MD_MULTI_NAMES'
UNION ALL 
SELECT 
	 CONVERT(CHAR(66),CAST(0x0 AS BINARY(32)),1) AS WorkReadinessStatusHash
	,'Unknown' AS WorkReadinessDescription;
GO