CREATE VIEW [META].[LINK_Forecasts_ForecastType]
AS SELECT 
CONCAT_WS('|','META',[Forecasts_ID])      AS ForecastsKey,
CONCAT_WS('|','META',[ForecastType_ID])   AS ForecastTypeKey,
'ELT.Forecasts'						      AS RecordSource,
[Effective_From]						  AS ValidFrom,
[Effective_To]							  AS ValidTo,
'1'									      AS IsCurrent
   FROM 
	 ELT.Forecasts f JOIN ELT.ForecastType ft ON f.ForecastType = ft.Type;
GO
