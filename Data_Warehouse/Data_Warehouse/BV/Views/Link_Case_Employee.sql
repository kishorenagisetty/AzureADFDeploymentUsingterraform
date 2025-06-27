CREATE VIEW [BV].[LINK_Case_Employee] AS 
SELECT *
FROM
(
	SELECT 
		 ce.CaseHash		AS Case_EmployeeHash
		,ceac.CaseKey		AS Case_EmployeeKey
		,ce.EmployeeHash
		,ceac.EmployeeKey
		,ceac.RecordSource
		,ceac.ContentHash
		,ceac.IsCurrent
		,ROW_NUMBER() OVER (PARTITION BY ce.CaseHash ORDER BY ceac.ValidFrom DESC) AS RN		-- Pick up the latest owner against a case
	FROM DV.LINKSAT_Case_Employee_Adapt_Core ceac
	JOIN DV.LINK_Case_Employee				 ce   ON ce.Case_EmployeeHash = ceac.Case_EmployeeHash
) A
WHERE A.RN = 1;