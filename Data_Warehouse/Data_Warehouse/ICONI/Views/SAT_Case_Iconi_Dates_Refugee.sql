CREATE VIEW [ICONI].[SAT_Case_Iconi_Dates_Refugee]
AS
    -- ===============================================================
    -- Author:	Sagar Kadiyala
    -- Create date: 04/01/2024
    -- Ticket Ref: #30330
    -- Name: [ICONI].[SAT_Case_Iconi_Dates_Refugee]
    -- Description: Runs the Sats Case Data
    -- Revisions:
    -- 30330 - SK - 04/01/2024 - Create a new view to bring in Refugee data
    -- 30330 - SK - 31/01/2024 - Added a additional columns to bring in Refugee data
    -- ===============================================================
    SELECT
        CONCAT_WS('|', 'ICONI', C.engagement_id)                  AS CaseKey,
        CAST(C.eng_start_date AS DATE)                            AS StartDate,
        CAST(C.eng_exit_date AS DATE)                             AS LeaveDate,
        CAST(C.eng_left_date AS DATE)                             AS LeftDate,
        CAST(C.eng_did_not_start_date AS DATE)                    AS DidNotStartDate,
        CAST(C.eng_caseload_review_date AS DATE)                  AS CaseLoadReviewDate,
        CAST(C.eng_disengaged_date AS DATE)                       AS DisengagedDate,
        CAST(C.eng_tran_date AS DATE)                             AS TransactionDate,
        CAST(C.eng_tran_added_date AS DATE)                       AS TransactionAddedDate,
        CAST(C.eng_follow_up_date AS DATE)                        AS FollowUpDate,
        CAST(C.eng_info_refugee_referral_date AS DATE)            AS ReferralDate,
        CAST(C.eng_info_refugee_elig_date_of_issue AS DATE)       AS EligibilityDateOfIssue,
        CAST(C.eng_info_refugee_last_updated_date AS DATE)        AS LastUpdatedDate,
        CAST(C.eng_info_refugee_elig_date_arrival_in_uk AS DATE)  AS DateArrivalInUK,
        CAST(c.eng_info_refugee_welcome_pack_date_issued AS DATE) AS WelcomePackIssueDate,
        /*--Commented all not available in source DB
CAST(NULL AS DATE) --CAST(C.eng_info_employability_prap_acknowledge_date AS DATE) AS EmployabilityPrapAcknowledgeDate,
CAST(NULL AS DATE) --CAST(C.eng_info_employability_prap_start_acknowledge_date AS DATE) AS EmployabilityPrapStartAcknowledgeDate,
CAST(NULL AS DATE) --CAST(C.eng_info_employability_prap_dna_acknowledge_date AS DATE) AS EmployabilityPrapDnaAcknowledgeDate,
CAST(NULL AS DATE) --CAST(C.eng_info_employability_prap_early_leaver_acknowledge_date AS DATE) AS EmployabilityPrapEarlyLeaverAcknowledgeDate,
CAST(NULL AS DATE) --CAST(C.eng_info_employability_prap_job_outcome_paid_date AS DATE) AS AS EmployabilityPrapJobOutcomePaidDate,
CAST(NULL AS DATE) --CAST(C.eng_info_employability_last_updated_date AS DATE) AS EmployabilityLastUpdatedDate,*/
        C.ValidFrom,
        C.ValidTo,
        C.IsCurrent
    FROM
        ICONI.vBIRefugee_Engagement C;
GO
