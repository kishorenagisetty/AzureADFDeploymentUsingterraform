CREATE VIEW [ICONI].[SAT_Case_Iconi_Core] AS SELECT 
CONCAT_WS('|','ICONI',C.engagement_id) AS CaseKey,
'ENG' + CAST(C.engagement_id AS VARCHAR) AS CaseID,
C.eng_tran_status_1 AS CaseStatus,			-- was cast as an integer in adapt. our data is text in this field.
C.eng_exit_reason AS LeaveReason,
C.eng_job_readiness AS WorkReadinessStatus,
C.eng_advisor_acknowledgement_required AS AdvisorAcknowledgementRequired,
C.eng_exit_reason_other AS ExitReasonOther,
C.eng_onward_destination AS OnwardDestination,
C.eng_onward_destination_other AS OnwardDestinationOther,
C.eng_left_reason AS LeftReason,
C.eng_left_reason_other AS LeftReasonOther,
C.eng_left_stage AS LeftStage,
C.eng_left_stage_other AS LeftStageOther,
C.eng_did_not_start_reason AS DidNotStartReason,
C.eng_did_not_start_reason_other AS DidNotStartReasonOther,
C.eng_signed_privacy_notice_uploaded AS SignedPrivacyNoticeUploaded,
C.eng_privacy_rights_exercised AS PrivacyRightsExercised,
C.eng_privacy_rights_details AS PrivacyRightsDetails,
C.eng_disengaged_reason AS DisengagedReason,
C.eng_frequency_of_contact AS FrequencyOfContact,
C.eng_tran_owner_user_id AS TranOwnerUserId,
C.eng_outcome AS Outcome,
C.eng_info_employability_induction_pack_issued AS PackIssued,
C.ValidFrom, C.ValidTo, C.IsCurrent
FROM ICONI.vBIRestart_Engagement C;
GO

