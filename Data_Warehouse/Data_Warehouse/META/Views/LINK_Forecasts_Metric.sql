CREATE VIEW [META].[LINK_Forecasts_Metric]
AS SELECT 
CONCAT_WS('|','META',[Forecasts_ID])      AS ForecastsKey,
CONCAT_WS('|','META',[Metric_ID])		  AS MetricKey,
'ELT.Forecasts' 						  AS RecordSource,
CAST('2022-04-01' AS DATE)				  AS ValidFrom,
'9999-12-31'							  AS ValidTo,
'1'										  AS IsCurrent
FROM 
ELT.Forecasts f JOIN ELT.Metric m ON f.Metric = m.metricName;
GO

