CREATE VIEW [ICONI].[LINK_Referral_RequestingSite] AS SELECT DISTINCT
CONCAT_WS('|','ICONI', RS.engagement_id) AS ReferralKey,
CONCAT_WS('|','ICONI', CONCAT(RS.eng_info_employability_jcp_office
	,RS.eng_info_employability_jcp_district
	,RS.eng_info_employability_contract_area
	)
) AS RequestingSiteKey,
'ICONI.Engagement' AS RecordSource,
RS.ValidFrom, 
RS.ValidTo, 
RS.IsCurrent
FROM ICONI.vBIRestart_Engagement AS RS
WHERE RS.IsCurrent = 1;