CREATE VIEW [ADAPT].[LINKSAT_Case_Employee_Adapt_Core] 
AS 
-- Author: 
-- Create date: DD/MM/YYY
-- Ticket Reference:  <Dev Ops Ticket Reference>
-- Description: <Description regarding object>
-- Revisions:
-- 23/11/2023 - <SK> - <29906> - <Change the Ranging from BISUNIQUEID to ValidFrom>
WITH cte_primary AS 
(
	SELECT
		  X.REFERENCE
		, X.EMPLOYEE
		, CASE
			 WHEN PRIMARY_YN = 'Y' THEN 'Yes'
			 WHEN PRIMARY_YN = 'N' THEN 'No'
			 ELSE 'No'
		  END AS IsPrimaryOwner
		, X.BISUNIQUEID
		, X.ValidFrom
		, X.ValidTo
		, X.IsCurrent
	FROM	   ADAPT.PROP_X_WP_EMPL X
	INNER JOIN ADAPT.PROP_EMPLOYEE_GEN E ON X.EMPLOYEE = E.REFERENCE AND E.IsCurrent = 1
	INNER JOIN ADAPT.PROP_X_CAND_WP X2 ON X.REFERENCE = X2.WIZPROG AND X2.IsCurrent = 1
	INNER JOIN ADAPT.PROP_WP_GEN WP ON X2.WIZPROG = WP.REFERENCE AND WP.IsCurrent = 1
	INNER JOIN ADAPT.PROP_PERSON_GEN P ON X2.CANDIDATE = P.REFERENCE AND P.IsCurrent = 1
	INNER JOIN ADAPT.ENTITY_TABLE E1 ON P.REFERENCE = E1.[ENTITY_ID] AND E1.IsCurrent = 1
	WHERE E1.[STATUS] <> 'D'
	AND   X.IsCurrent = 1
)
, cte_latest_programme_owner AS
(
	SELECT
		  X.REFERENCE
		, X.EMPLOYEE
		, ROW_NUMBER() OVER (PARTITION BY REFERENCE ORDER BY X.IsPrimaryOwner DESC,X.ValidFrom DESC) AS RN -- 23/11/2023 - <SK> - <29906>
		, BISUNIQUEID
		, ValidFrom
		, ValidTo
		, IsCurrent
	FROM cte_primary X
)
SELECT
CONCAT(
		CONCAT_WS('|','ADAPT', CAST(X.REFERENCE AS INT)),	-- CaseKey
		CONCAT_WS('|','ADAPT', CAST(X.EMPLOYEE AS INT))		-- EmployeeKey
		) AS Case_EmployeeKey,
	CONCAT_WS('|','ADAPT', CAST(X.REFERENCE AS INT)) AS CaseKey,
	CONCAT_WS('|','ADAPT', CAST(X.EMPLOYEE AS INT)) AS EmployeeKey,
	'ADAPT.PROP_X_WP_EMPL' AS RecordSource,
	CAST(GETUTCDATE() AS DATE) AS ValidFrom, 
	ValidTo,
	1 AS IsCurrent
FROM cte_latest_programme_owner X
WHERE RN = 1;