-- This is for testing by Sarath Koritala
CREATE VIEW [ADAPT].[HUB_Activity] AS (
SELECT 
CONCAT_WS('|','ADAPT',CAST([REFERENCE] AS INT)) AS ActivityKey,
'ADAPT.PROP_ACTIVITY_GEN'						AS RecordSource,
[ValidFrom], 
[ValidTo], 
IsCurrent 
FROM 
ADAPT.PROP_ACTIVITY_GEN
);
GO
