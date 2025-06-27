CREATE VIEW [ICONI].[SAT_Case_Iconi_Dates] AS SELECT 
CONCAT_WS('|','ICONI',C.engagement_id) AS CaseKey,
CAST(C.eng_start_date AS DATE) AS StartDate,
CAST(C.eng_exit_date AS DATE)  AS LeaveDate,
CAST(C.eng_left_date AS DATE)	AS LeftDate,
CAST(C.eng_did_not_start_date AS DATE) AS DidNotStartDate,
CAST(C.eng_caseload_review_date AS DATE) AS CaseLoadReviewDate,
CAST(C.eng_disengaged_date AS DATE)	AS DisengagedDate,
CAST(C.eng_tran_added_date AS DATE)	AS TransactionAddedDate,
CAST(C.eng_follow_up_date AS DATE) AS FollowUpDate,
CAST(C.eng_info_employability_prap_acknowledge_date AS DATE) AS EmployabilityPrapAcknowledgeDate,
CAST(C.eng_info_employability_prap_start_acknowledge_date AS DATE) AS EmployabilityPrapStartAcknowledgeDate,
CAST(C.eng_info_employability_prap_dna_acknowledge_date AS DATE) AS EmployabilityPrapDnaAcknowledgeDate,
CAST(C.eng_info_employability_prap_early_leaver_acknowledge_date AS DATE) AS EmployabilityPrapEarlyLeaverAcknowledgeDate,
CAST(C.eng_info_employability_prap_job_outcome_paid_date AS DATE) AS EmployabilityPrapJobOutcomePaidDate,
CAST(C.eng_info_employability_last_updated_date AS DATE) AS EmployabilityLastUpdatedDate,
C.ValidFrom, C.ValidTo, C.IsCurrent
FROM ICONI.vBIRestart_Engagement C;
GO

