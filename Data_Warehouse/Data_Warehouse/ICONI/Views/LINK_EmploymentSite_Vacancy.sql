CREATE VIEW [ICONI].[LINK_EmploymentSite_Vacancy]
AS SELECT 
CONCAT_WS('|','ICONI', O.organisation_id) AS EmploymentSiteKey,
CONCAT_WS('|','ICONI', V.vacancy_id) AS VacancyKey,
'ICONI.EmploymentSite' AS RecordSource,
O.ValidFrom, 
O.ValidTo, 
O.IsCurrent
FROM [ICONI].[vBICommon_Organisation] AS O
INNER JOIN [ICONI].[vBIRestart_Vacancy] AS V
ON V.vac_organisation_id = O.organisation_id
AND O.IsCurrent = 1
AND V.IsCurrent = 1;
GO

