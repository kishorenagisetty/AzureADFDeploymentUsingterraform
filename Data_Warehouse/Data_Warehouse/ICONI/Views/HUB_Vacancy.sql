CREATE VIEW [ICONI].[HUB_Vacancy]
AS SELECT 
CONCAT_WS('|','ICONI',V.vacancy_id) AS VacancyKey,
'ICONI.Vacancy' AS RecordSource,
V.ValidFrom,
V.ValidTo,
V.IsCurrent
FROM ICONI.vBIRestart_Vacancy V;
GO

