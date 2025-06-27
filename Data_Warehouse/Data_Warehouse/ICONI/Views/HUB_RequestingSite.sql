CREATE VIEW [ICONI].[HUB_RequestingSite]
AS SELECT DISTINCT
CONCAT_WS('|','ICONI',CONCAT(RS.eng_info_employability_jcp_office
	,RS.eng_info_employability_jcp_district
	,RS.eng_info_employability_contract_area
	)
) AS RequestingSiteKey,
'ICONI.Engagement' AS RecordSource,
'20210601' ValidFrom,
'19000101' as ValidTo,
1 as IsCurrent
FROM ICONI.vBIRestart_Engagement RS
WHERE (RS.eng_info_employability_jcp_office IS NOT NULL
	AND RS.eng_info_employability_jcp_district IS NOT NULL
	AND RS.eng_info_employability_contract_area IS NOT NULL
	);
GO

