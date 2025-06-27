CREATE VIEW [DV].[Base_References]
AS SELECT
CAST('Unknown' AS NVARCHAR(MAX)) AS ReferenceSource,
CAST(0 AS bigint) AS Code,
CAST('Unknown' AS NVARCHAR(MAX)) AS Category,
CAST('Unknown' AS NVARCHAR(MAX)) AS Description,
CAST('Unknown' AS NVARCHAR(MAX)) AS DetailedDescription
UNION ALL
SELECT
	H.RecordSource AS ReferenceSource,
	S_MD.ID AS Code,
	S_MD.Type AS Category,
	COALESCE(NULLIF(S_MD.Name,''),NULLIF(S_MD.Description,'')) AS Description,
	NULLIF(S_MD.Description,'') AS DetailedDescription
FROM DV.HUB_References H
	LEFT JOIN DV.SAT_References_MDMultiNames S_MD ON S_MD.ReferencesHash = H.ReferencesHash AND S_MD.IsCurrent = 1;