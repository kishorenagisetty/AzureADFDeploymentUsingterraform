CREATE VIEW [META].[SAT_Forecasts_Meta_Core]
AS (
SELECT 
CONCAT_WS('|','META',[Forecasts_ID])	  AS ForecastsKey,
[Value]									  AS ForecastValue,
[ForecastDate]							  AS ValidFrom,
'9999-12-31'							  AS ValidTo,
'1'									      AS IsCurrent
FROM 
ELT.Forecasts
);
GO

