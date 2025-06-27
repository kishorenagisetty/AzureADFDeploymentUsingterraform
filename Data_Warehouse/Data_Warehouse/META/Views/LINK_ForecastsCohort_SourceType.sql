CREATE VIEW [META].[LINK_ForecastsCohort_SourceType]
AS (
SELECT 
CONCAT_WS('|','META',[ForecastsCohort_ID]) AS ForecastsCohortKey,
CONCAT_WS('|','META',[sourceType_ID])      AS SourceTypeKey,
'ELT.ForecastsCohort' 					   AS RecordSource,
CAST('2022-04-01' AS DATE)				   AS ValidFrom,
'9999-12-31'							   AS ValidTo,
'1'										   AS IsCurrent
FROM 
ELT.ForecastsCohort fc JOIN ELT.SourceType st ON fc.SourceType = st.sourceTypeName
);
GO

