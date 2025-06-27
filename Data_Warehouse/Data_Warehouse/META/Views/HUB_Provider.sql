CREATE VIEW [META].[HUB_Provider] AS (
SELECT
	ProviderKey,
	RecordSource,
	ValidFrom,
	ValidTo,
	IsCurrent
FROM (
	SELECT 
	rn = row_number() OVER (PARTITION BY CoreProvider ORDER BY ID),
	CONCAT_WS('|','META',CoreProvider)				      AS ProviderKey,
	'ELT.Provider'										  AS RecordSource,
	CAST(getdate() AS DATE)	  							  AS ValidFrom,
	CAST('9999-12-31' AS DATE)							  AS ValidTo,
	IsActive											  AS IsCurrent
	FROM 
	ELT.LK_RegionZones
	WHERE CoreProvider != ''
) x
WHERE (rn = 1)
);
GO