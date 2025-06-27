CREATE VIEW [ICONI].[SAT_Referral_Iconi_Refugee]
AS
-- ===============================================================
-- Author:	Sagar Kadiyala
-- Create date: 01/02/2024
-- Ticket Ref: #30330
-- Name: [ICONI].[SAT_Case_Iconi_Dates_Refugee]
-- Description: Runs the Sats Case Data
-- Revisions:
-- 30330 - SK - 31/01/2024 - Added a additional columns to bring in Refugee data
-- ===============================================================
SELECT CONCAT_WS('|', 'ICONI', engagement_id) as ReferralKey
     --C.eng_info_employability_prap_po_no AS PONumber,
     --C.eng_info_employability_prap_admin_info AS PODescription,
     , C.eng_info_refugee_referral_date       AS ReferralDate
     , C.eng_referral_source                  AS ReferralType
     , C.eng_referral_source_other            AS ReferralSourceOther
     --C.eng_info_employability_consider_themselves_disabled AS Disability,
     , C.ValidFrom                            AS ValidFrom
     , C.ValidTo                              AS ValidTo
     , C.IsCurrent                            AS IsCurrent
FROM ICONI.vBIRefugee_Engagement as C;
Go
