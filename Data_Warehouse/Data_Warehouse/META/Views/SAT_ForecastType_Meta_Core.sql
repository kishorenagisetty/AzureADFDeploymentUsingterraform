CREATE VIEW [META].[SAT_ForecastType_Meta_Core]
AS (
SELECT 
CONCAT_WS('|','META',[ForecastType_ID])  AS ForecastTypeKey,
[Type],
[Longname],
[Effective_From]						  AS ValidFrom, 
[Effective_To]							  AS ValidTo,
'1'										  AS IsCurrent
FROM 
ELT.ForecastType
);
GO

