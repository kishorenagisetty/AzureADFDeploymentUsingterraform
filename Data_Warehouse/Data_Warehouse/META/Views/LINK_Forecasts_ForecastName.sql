CREATE VIEW [META].[LINK_Forecasts_ForecastName]
AS (
SELECT 
CONCAT_WS('|','META',[Forecasts_ID])			  AS ForecastsKey,
CONCAT_WS('|','META',[FileName])				  AS ForecastNameKey,
'ELT.Forecasts'								      AS RecordSource,
CAST('2022-04-01' AS DATE)					      AS ValidFrom,
CAST('9999-12-31' AS DATE)						  AS ValidTo,
'1'												  AS IsCurrent
   FROM 
	 ELT.Forecasts
);
GO

