CREATE VIEW [ADAPT].[LINK_Case_Correspondence] AS (
SELECT
CONCAT_WS('|','ADAPT',CAST(wc.[REFERENCE] AS BIGINT))  AS CaseKey,
CONCAT_WS('|','ADAPT',CAST(wc.[BISUNIQUEID] AS INT)) AS CorrespondenceKey,
'ADAPT.PROP_WP_COM'						AS RecordSource,
wc.[ValidFrom], 
wc.[ValidTo], 
wc.IsCurrent 
FROM ADAPT.PROP_WP_COM wc
);
GO