CREATE VIEW [DV].[Base_Vacancy]
AS SELECT * FROM [DV].[Base_Vacancy_Default]
UNION ALL
SELECT * FROM [DV].[Base_Vacancy_Adapt]
UNION ALL
SELECT * FROM [DV].[Base_Vacancy_Iconi];
GO

