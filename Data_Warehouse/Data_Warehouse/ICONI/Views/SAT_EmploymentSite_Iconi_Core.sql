CREATE VIEW [ICONI].[SAT_EmploymentSite_Iconi_Core]
AS SELECT 
CONCAT_WS('|','ICONI',O.organisation_id) AS EmployeeSiteKey,
O.org_status AS EmployerStatus,
O.org_source AS EmployerSource,
O.org_sic AS EmployerSIC,
O.org_no_of_employees AS EmployerNumberOfEmployees,
O.org_name AS EmployerName,
O.org_legal_status AS EmployerIncorporationType,
O.ValidFrom,
O.ValidTo,
O.IsCurrent
FROM [ICONI].[vBICommon_Organisation] as O;