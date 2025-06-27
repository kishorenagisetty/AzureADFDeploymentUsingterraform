CREATE VIEW [ICONI].[HUB_DeliveryOrganisation]
AS SELECT
CONCAT_WS('|','ICONI',A.agency_id) AS DeliveryOrganisationKey,
'ICONI.Agency' AS RecordSource,
A.ValidFrom,
A.ValidTo,
A.IsCurrent
FROM ICONI.vBICommon_Agency A;