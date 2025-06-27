CREATE VIEW [META].[SAT_Metric_Meta_Core]
AS (
SELECT 
CONCAT_WS('|','META',[Metric_ID])	  AS Metric_Key,
[metricName],
CAST('2022-04-01' AS DATE)			  AS ValidFrom,
'9999-12-31'						  AS ValidTo,
'1'									  AS IsCurrent
FROM 
ELT.Metric
);
GO

