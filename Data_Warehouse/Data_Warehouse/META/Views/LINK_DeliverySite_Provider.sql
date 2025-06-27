CREATE VIEW [META].[LINK_DeliverySite_Provider] 
AS 
WITH cte_case AS
(
SELECT
	WP.CORE_PROVID AS DeliverySiteKey
	,CG.NAME AS CoreProvider
	,CG.ValidFrom
	,CG.ValidTo
	,CG.IsCurrent
FROM ADAPT.PROP_WP_GEN WP
INNER JOIN ADAPT.PROP_CLIENT_GEN CG ON CG.REFERENCE = WP.CORE_PROVID
)
SELECT
		DeliverySiteKey,
		ProviderKey,
		RecordSource,
		ValidFrom,
		ValidTo,
		IsCurrent
FROM (
	SELECT
		rn = row_number() OVER (PARTITION BY rz.CoreProvider ORDER BY ID),
		CONCAT_WS('|','ADAPT',CAST(c.DeliverySiteKey AS INT))	AS DeliverySiteKey,
		CONCAT_WS('|','META',rz.CoreProvider)					AS ProviderKey,
		'ADAPT.PROP_CLIENT_GEN'									AS RecordSource,
		ValidFrom												AS ValidFrom,
		ValidTo													AS ValidTo,
		IsCurrent												AS IsCurrent
	FROM cte_case c
	INNER JOIN ELT.LK_RegionZones rz ON rz.CoreProvider = c.CoreProvider 
		AND ISNULL(rz.CoreProvider,'') != ''
	) x
WHERE (rn = 1)
;
GO
