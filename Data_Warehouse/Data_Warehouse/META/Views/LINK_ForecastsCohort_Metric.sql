CREATE VIEW [META].[LINK_ForecastsCohort_Metric]
AS SELECT 
CONCAT_WS('|','META',[ForecastsCohort_ID])      AS ForecastsKey,
CONCAT_WS('|','META',[Metric_ID])		  AS MetricKey,
'ELT.ForecastsCohort' 						  AS RecordSource,
CAST('2022-04-01' AS DATE)				  AS ValidFrom,
'9999-12-31'							  AS ValidTo,
'1'										  AS IsCurrent
FROM 
ELT.ForecastsCohort f JOIN ELT.Metric m ON f.Metric = m.metricName;
GO

