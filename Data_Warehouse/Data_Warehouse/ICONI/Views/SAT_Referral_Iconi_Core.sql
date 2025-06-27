CREATE VIEW [ICONI].[SAT_Referral_Iconi_Core]
AS SELECT 
CONCAT_WS('|','ICONI',engagement_id) as ReferralKey,
C.eng_info_employability_prap_po_no AS PONumber,
C.eng_info_employability_prap_admin_info AS PODescription,
C.eng_tran_date AS ReferralDate,
C.eng_referral_source AS ReferralType,
C.eng_referral_source_other AS ReferralSourceOther,
C.eng_info_employability_consider_themselves_disabled AS Disability,
C.ValidFrom AS ValidFrom,
C.ValidTo AS ValidTo,
C.IsCurrent AS IsCurrent
FROM ICONI.vBIRestart_Engagement as C;
GO