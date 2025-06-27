CREATE VIEW [META].[LINK_ForecastsCohort_Programme]
AS SELECT 
CONCAT_WS('|','META',[ForecastsCohort_ID]) AS ForecastsCohortKey,
[ProgrammeKey]							   AS ProgrammeKey,
'ELT.ForecastsCohort fc'				   AS RecordSource,
[ForecastDate]							   AS ValidFrom,
CAST('9999-12-31' AS DATE)				   AS ValidTo,
'1'									       AS IsCurrent
FROM 
	ELT.ForecastsCohort fc LEFT JOIN ADAPT.HUB_Programme p ON fc.Programme = p.ProgrammeKey;
GO

