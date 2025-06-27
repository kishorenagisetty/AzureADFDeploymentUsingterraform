CREATE VIEW [ICONI].[LINK_Vacancy_Assignment]
AS SELECT 
CONCAT_WS('|','ICONI', V.vacancy_id) AS VacancyKey,
CONCAT_WS('|','ICONI', A.outcome_id) AS AssignmentKey,
'ICONI.Vacancy' AS RecordSource,
V.ValidFrom, 
V.ValidTo, 
V.IsCurrent
FROM ICONI.vBIRestart_Vacancy AS V
INNER JOIN ICONI.vBIRestart_Outcome AS A
ON V.vacancy_id = A.out_vacancy_id
AND V.IsCurrent = 1
AND A.IsCurrent = 1;
GO

