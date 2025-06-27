CREATE VIEW [META].[LINK_Forecasts_Programme]
AS SELECT 
CONCAT_WS('|','META',[Forecasts_ID])	  AS ForecastsKey,
[ProgrammeKey]							  AS ProgrammeKey,
'ELT.Forecasts'							  AS RecordSource,
[ForecastDate]							  AS ValidFrom,
CAST('9999-12-31' AS DATE)				  AS ValidTo,
'1'									      AS IsCurrent
FROM 
	ELT.Forecasts f LEFT JOIN ADAPT.HUB_Programme p ON f.Programme = p.ProgrammeKey;
GO

