CREATE VIEW [META].[HUB_Metric]
AS (
SELECT 
CONCAT_WS('|','META',[Metric_ID])	  AS MetricKey,
'ELT.Metric'						  AS RecordSource,
CAST('2022-04-01' AS DATE)			  AS ValidFrom,
CAST('9999-12-31' AS DATE)			  AS ValidTo,
'1'									  AS IsCurrent
FROM 
ELT.Metric
);
GO