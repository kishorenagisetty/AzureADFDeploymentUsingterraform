CREATE VIEW [META].[HUB_Forecasts]
AS (
SELECT 
CONCAT_WS('|','META',[Forecasts_ID]) AS ForecastsKey,
'ELT.Forecasts'					     AS RecordSource,
[ForecastDate]						 AS ValidFrom,
CAST('9999-12-31' AS DATE)			 AS ValidTo,
'1'									 AS IsCurrent
FROM 
ELT.Forecasts
);
GO

