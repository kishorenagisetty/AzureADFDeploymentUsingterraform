CREATE VIEW [ICONI].[SAT_RequestingSite_Iconi_Core]
AS SELECT DISTINCT
CONCAT_WS('|','ICONI',CONCAT(RS.eng_info_employability_jcp_office
	,RS.eng_info_employability_jcp_district
	,RS.eng_info_employability_contract_area
	)
) AS RequestingSiteKey,
RS.eng_info_employability_jcp_office AS RequestingSiteName,
RS.eng_info_employability_jcp_district AS RequestingSiteDistrict,
RS.eng_info_employability_contract_area AS RequestingSiteContractAreaName,
RS.ValidFrom AS ValidFrom,
RS.ValidTo AS ValidTo,
1 AS IsCurrent
FROM ICONI.vBIRestart_Engagement as RS;
GO

