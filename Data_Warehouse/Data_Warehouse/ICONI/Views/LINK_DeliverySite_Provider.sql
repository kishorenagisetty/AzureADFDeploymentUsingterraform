CREATE VIEW [ICONI].[LINK_DeliverySite_Provider]
AS SELECT DISTINCT
CONCAT_WS('|','ICONI', DS.eng_info_employability_jcp_office) AS DeliverySiteKey,
CONCAT_WS('|','ICONI',A.agency_id) AS ProviderKey,
'ICONI.Agency' AS RecordSource,
A.ValidFrom, 
A.ValidTo, 
A.IsCurrent
FROM ICONI.vBIRestart_Engagement AS DS
INNER JOIN ICONI.vBICommon_Agency AS A
ON DS.eng_provider_name = A.agency_name
WHERE DS.eng_info_employability_jcp_office IS NOT NULL
AND DS.IsCurrent = 1
AND A.IsCurrent = 1;