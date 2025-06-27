CREATE VIEW [META].[HUB_ForecastsCohort]
AS (
SELECT 
CONCAT_WS('|','META',[ForecastsCohort_ID])   AS ForecastsCohortKey,
'ELT.ForecastsCohort'					     AS RecordSource,
[ForecastDate]								 AS ValidFrom,
CAST('9999-12-31' AS DATE)					 AS ValidTo,
'1'											 AS IsCurrent
FROM 
ELT.ForecastsCohort
);
GO

