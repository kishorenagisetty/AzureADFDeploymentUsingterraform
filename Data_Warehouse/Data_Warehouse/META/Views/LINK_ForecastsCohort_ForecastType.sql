CREATE VIEW [META].[LINK_ForecastsCohort_ForecastType]
AS SELECT 
CONCAT_WS('|','META',[ForecastType_ID])	   AS ForecastTypeKey,
'ELT.ForecastsCohort'					   AS RecordSource,
[Effective_From]						   AS ValidFrom,
[Effective_To]							   AS ValidTo,
'1'									       AS IsCurrent
   FROM 
	 ELT.ForecastType ft ;
GO

