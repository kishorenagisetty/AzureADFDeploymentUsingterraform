CREATE VIEW [ADAPT].[LINKSAT_Case_Employee_Adapt_Core_NotCurrent]
AS
-- ===============================================================
-- Author: Shaz Rehman
-- Create date: 02/08/2023
-- Ticket Reference:  #25904
-- Description: Procedure builds LinksStats
-- Revisions:
--02/08/2023 - SR - #25904 - Various amendments to change the functionality of the procedure to run in bulk or net change.
-- ===============================================================
SELECT 
	    CONCAT(
		CONCAT_WS('|','ADAPT', CAST(X.REFERENCE AS INT)),	-- CaseKey
		CONCAT_WS('|','ADAPT', CAST(X.EMPLOYEE AS INT))		-- EmployeeKey
			) AS Case_EmployeeKey,
	CONCAT_WS('|','ADAPT', CAST(X.REFERENCE AS INT)) AS CaseKey,
	CONCAT_WS('|','ADAPT', CAST(X.EMPLOYEE AS INT)) AS EmployeeKey,
	'ADAPT.PROP_X_WP_EMPL' AS RecordSource,
	X.ValidFrom AS ValidFrom, 
	X.ValidTo AS ValidTo,
	X.IsCurrent AS IsCurrent
	FROM	   ADAPT.PROP_X_WP_EMPL X
	INNER JOIN ADAPT.PROP_EMPLOYEE_GEN E ON X.EMPLOYEE = E.REFERENCE AND E.IsCurrent = 1
	INNER JOIN ADAPT.PROP_X_CAND_WP X2 ON X.REFERENCE = X2.WIZPROG AND X2.IsCurrent = 1
	INNER JOIN ADAPT.PROP_WP_GEN WP ON X2.WIZPROG = WP.REFERENCE AND WP.IsCurrent = 1
	INNER JOIN ADAPT.PROP_PERSON_GEN P ON X2.CANDIDATE = P.REFERENCE AND P.IsCurrent = 1
	INNER JOIN ADAPT.ENTITY_TABLE E1 ON P.REFERENCE = E1.[ENTITY_ID] AND E1.IsCurrent = 1
	WHERE E1.[STATUS] <> 'D' AND   X.IsCurrent = 0;


