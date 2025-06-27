CREATE VIEW [ADAPT].[HUB_Correspondence]
AS (
SELECT
CONCAT_WS('|','ADAPT',CAST([BISUNIQUEID] AS INT)) AS CorrespondenceKey,
'ADAPT.PROP_WP_COM'						AS RecordSource,
[ValidFrom],
[ValidTo],
IsCurrent
FROM ADAPT.PROP_WP_COM
);
GO
