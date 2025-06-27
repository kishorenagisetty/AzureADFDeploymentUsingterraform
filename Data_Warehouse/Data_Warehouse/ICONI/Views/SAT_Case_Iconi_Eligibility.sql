CREATE VIEW [ICONI].[SAT_Case_Iconi_Eligibility] AS SELECT 
CONCAT_WS('|','ICONI',C.engagement_id) AS CaseKey,
--C.eng_info_employability_universal_cred_receipt AS CredReceipt,
C.eng_info_employability_sustained_earnings AS SustainedEarnings,
C.eng_info_employability_right_to_work AS ToWork,
C.eng_info_employability_reside_in_england_wales AS EnglandWales,
C.eng_info_employability_working_age AS WorkingAge,
C.eng_info_employability_not_taking_dwp_employment AS DwpEmployment,
C.eng_info_employability_not_in_control_group_or_public_sector_comparator AS NotInControlGroupOrPublicSectorComparator,
C.eng_info_employability_exoffender AS EmployabilityExoffender,
C.eng_info_employability_initial_eligibility_confirmed AS EligibilityConfirmed,
C.eng_info_employability_employment_interests AS EmploymentInterests,
C.ValidFrom, C.ValidTo, C.IsCurrent
FROM ICONI.vBIRestart_Engagement C;
