CREATE VIEW [META].[HUB_ForecastType]
AS (
SELECT 
CONCAT_WS('|','META',[ForecastType_ID])   AS ForecastTypeKey,
'ELT.ForecastType'						  AS RecordSource,
[Effective_From]						  AS ValidFrom,
[Effective_To]							  AS ValidTo,
'1'									      AS IsCurrent
FROM 
ELT.ForecastType
);
GO

