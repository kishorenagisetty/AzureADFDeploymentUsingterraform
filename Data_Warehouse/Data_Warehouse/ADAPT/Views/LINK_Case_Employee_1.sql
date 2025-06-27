CREATE VIEW [ADAPT].[LINK_Case_Employee] 
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
,X.EMPLOYEE
,CASE
	WHEN PRIMARY_YN = 'Y' THEN 'Yes'
	WHEN PRIMARY_YN = 'N' THEN 'No'
	ELSE 'No'
	END AS IsPrimaryOwner
,BISUNIQUEID
,ValidFrom
, ValidTo
, IsCurrent
FROM ADAPT.PROP_X_WP_EMPL X
),cte_latest_programme_owner AS
(
SELECT
X.REFERENCE
,X.EMPLOYEE
,ROW_NUMBER() OVER (PARTITION BY REFERENCE ORDER BY X.IsPrimaryOwner DESC,X.ValidFrom DESC) AS RN -- 23/11/2023 - <SK> - <29906>
,ValidFrom
, ValidTo
, IsCurrent
FROM cte_primary X
)
SELECT 
CONCAT_WS('|','ADAPT', CAST(X.REFERENCE AS INT)) AS CaseKey,
CONCAT_WS('|','ADAPT', CAST(X.EMPLOYEE AS INT)) AS EmployeeKey,
'ADAPT.PROP_X_WP_EMPL' AS RecordSource,
ValidFrom, ValidTo,CASE WHEN RN = '1' THEN 1 ELSE 0 END AS IsCurrent
FROM cte_latest_programme_owner X;
GO
