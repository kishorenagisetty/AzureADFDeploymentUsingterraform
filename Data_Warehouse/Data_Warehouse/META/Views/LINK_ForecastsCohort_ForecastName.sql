CREATE VIEW [META].[LINK_ForecastsCohort_ForecastName]
AS (
SELECT 
CONCAT_WS('|','META',[ForecastsCohort_ID])             AS ForecastsCohortKey,
CONCAT_WS('|','META',[FileName])					   AS ForecastNameKey,
'ELT.ForecastsCohort'								   AS RecordSource,
CAST('2022-04-01' AS DATE)							   AS ValidFrom,
CAST('9999-12-31' AS DATE)							   AS ValidTo,
'1'													   AS IsCurrent
   FROM 
	 ELT.ForecastsCohort
);
GO

