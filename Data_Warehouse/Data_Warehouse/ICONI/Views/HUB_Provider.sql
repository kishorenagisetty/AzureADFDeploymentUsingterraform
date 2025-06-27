CREATE VIEW [ICONI].[HUB_Provider]
AS SELECT
CONCAT_WS('|','ICONI',A.agency_id) AS ProviderKey,
'ICONI.Agency' AS RecordSource,
A.ValidFrom,
A.ValidTo,
A.IsCurrent
FROM ICONI.vBICommon_Agency A;