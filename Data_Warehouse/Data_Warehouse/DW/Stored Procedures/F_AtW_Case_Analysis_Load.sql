CREATE PROC [DW].[F_AtW_Case_Analysis_Load] AS

-- -------------------------------------------------------------------
-- Script:         DW.AtW_Case_Analysis Load
-- Target:         Azure Synapse Data Warehouse
-- -------------------------------------------------------------------

-- Delete temporary tables if present.

if object_id ('stg.DW_F_AtW_Case_Analysis_TEMP','U') is not null drop table stg.DW_F_AtW_Case_Analysis_TEMP;

------ -------------------------------------------------------------------
------ Create new table
------ -------------------------------------------------------------------

------ Get dataset from Landing Zone
CREATE TABLE stg.DW_F_AtW_Case_Analysis_TEMP
        WITH (clustered columnstore index, distribution = hash(Case_Skey)) 
AS

WITH LNK_Stages AS
(
SELECT [Case_Analysis_Skey]
	
	-- WorkFlow <Stage> Start Date --
	, MIN(CASE WHEN Stage = 'Enquiry'				THEN WorkFlowStartDate_Skey END)				AS WorkFlowEnquiryStartDate_Skey
	, MIN(CASE WHEN Stage = 'Referral'				THEN WorkFlowStartDate_Skey END)				AS WorkFlowReferralStartDate_Skey
	, MIN(CASE WHEN Stage = 'Telephone Assessment'	THEN WorkFlowStartDate_Skey END)				AS WorkFlowTelephoneAssessmentStartDate_Skey
	, MIN(CASE WHEN Stage = 'Initial Support Plan'	THEN WorkFlowStartDate_Skey END)				AS WorkFlowInitialSupportPlanStartDate_Skey
	, MIN(CASE WHEN Stage = 'Month 1'				THEN WorkFlowStartDate_Skey END)				AS WorkFlowMonth1StartDate_Skey
	, MIN(CASE WHEN Stage = 'Month 2'				THEN WorkFlowStartDate_Skey END)				AS WorkFlowMonth2StartDate_Skey
	, MIN(CASE WHEN Stage = 'Month 3'				THEN WorkFlowStartDate_Skey END)				AS WorkFlowMonth3StartDate_Skey
	, MIN(CASE WHEN Stage = 'Month 4'				THEN WorkFlowStartDate_Skey END)				AS WorkFlowMonth4StartDate_Skey
	, MIN(CASE WHEN Stage = 'Month 5'				THEN WorkFlowStartDate_Skey END)				AS WorkFlowMonth5StartDate_Skey
	, MIN(CASE WHEN Stage = '6 Month Report'		THEN WorkFlowStartDate_Skey END)				AS WorkFlow6MonthReportStartDate_Skey
	, MIN(CASE WHEN Stage = 'Month 7'				THEN WorkFlowStartDate_Skey END)				AS WorkFlowMonth7StartDate_Skey
	, MIN(CASE WHEN Stage = 'Month 8'				THEN WorkFlowStartDate_Skey END)				AS WorkFlowMonth8StartDate_Skey
	, MIN(CASE WHEN Stage = '9 Month Report'		THEN WorkFlowStartDate_Skey END)				AS WorkFlow9MonthReportStartDate_Skey
	, MIN(CASE WHEN Stage = 'After Month 9'			THEN WorkFlowStartDate_Skey END)				AS WorkFlowAfterMonth9StartDate_Skey

	-- Work Flow <Stage> Start Time --
	, MIN(CASE WHEN Stage = 'Enquiry'				THEN WorkFlowStartTime_Skey END)				AS WorkFlowEnquiryStartTime_Skey
	, MIN(CASE WHEN Stage = 'Referral'				THEN WorkFlowStartTime_Skey END)				AS WorkFlowReferralStartTime_Skey
	, MIN(CASE WHEN Stage = 'Telephone Assessment'	THEN WorkFlowStartTime_Skey END)				AS WorkFlowTelephoneAssessmentStartTime_Skey
	, MIN(CASE WHEN Stage = 'Initial Support Plan'	THEN WorkFlowStartTime_Skey END)				AS WorkFlowInitialSupportPlanStartTime_Skey
	, MIN(CASE WHEN Stage = 'Month 1'				THEN WorkFlowStartTime_Skey END)				AS WorkFlowMonth1StartTime_Skey
	, MIN(CASE WHEN Stage = 'Month 2'				THEN WorkFlowStartTime_Skey END)				AS WorkFlowMonth2StartTime_Skey
	, MIN(CASE WHEN Stage = 'Month 3'				THEN WorkFlowStartTime_Skey END)				AS WorkFlowMonth3StartTime_Skey
	, MIN(CASE WHEN Stage = 'Month 4'				THEN WorkFlowStartTime_Skey END)				AS WorkFlowMonth4StartTime_Skey
	, MIN(CASE WHEN Stage = 'Month 5'				THEN WorkFlowStartTime_Skey END)				AS WorkFlowMonth5StartTime_Skey
	, MIN(CASE WHEN Stage = '6 Month Report'		THEN WorkFlowStartTime_Skey END)				AS WorkFlow6MonthReportStartTime_Skey
	, MIN(CASE WHEN Stage = 'Month 7'				THEN WorkFlowStartTime_Skey END)				AS WorkFlowMonth7StartTime_Skey
	, MIN(CASE WHEN Stage = 'Month 8'				THEN WorkFlowStartTime_Skey END)				AS WorkFlowMonth8StartTime_Skey
	, MIN(CASE WHEN Stage = '9 Month Report'		THEN WorkFlowStartTime_Skey END)				AS WorkFlow9MonthReportStartTime_Skey
	, MIN(CASE WHEN Stage = 'After Month 9'			THEN WorkFlowStartTime_Skey END)				AS WorkFlowAfterMonth9StartTime_Skey

	-- Work Flow <Stage> End Date --
	, MIN(CASE WHEN Stage = 'Enquiry'				THEN WorkFlowEndDate_Skey END)					AS WorkFlowEnquiryEndDate_Skey
	, MIN(CASE WHEN Stage = 'Referral'				THEN WorkFlowEndDate_Skey END)					AS WorkFlowReferralEndDate_Skey
	, MIN(CASE WHEN Stage = 'Telephone Assessment'	THEN WorkFlowEndDate_Skey END)					AS WorkFlowTelephoneAssessmentEndDate_Skey
	, MIN(CASE WHEN Stage = 'Initial Support Plan'	THEN WorkFlowEndDate_Skey END)					AS WorkFlowInitialSupportPlanEndDate_Skey
	, MIN(CASE WHEN Stage = 'Month 1'				THEN WorkFlowEndDate_Skey END)					AS WorkFlowMonth1EndDate_Skey
	, MIN(CASE WHEN Stage = 'Month 2'				THEN WorkFlowEndDate_Skey END)					AS WorkFlowMonth2EndDate_Skey
	, MIN(CASE WHEN Stage = 'Month 3'				THEN WorkFlowEndDate_Skey END)					AS WorkFlowMonth3EndDate_Skey
	, MIN(CASE WHEN Stage = 'Month 4'				THEN WorkFlowEndDate_Skey END)					AS WorkFlowMonth4EndDate_Skey
	, MIN(CASE WHEN Stage = 'Month 5'				THEN WorkFlowEndDate_Skey END)					AS WorkFlowMonth5EndDate_Skey
	, MIN(CASE WHEN Stage = '6 Month Report'		THEN WorkFlowEndDate_Skey END)					AS WorkFlow6MonthReportEndDate_Skey
	, MIN(CASE WHEN Stage = 'Month 7'				THEN WorkFlowEndDate_Skey END)					AS WorkFlowMonth7EndDate_Skey
	, MIN(CASE WHEN Stage = 'Month 8'				THEN WorkFlowEndDate_Skey END)					AS WorkFlowMonth8EndDate_Skey
	, MIN(CASE WHEN Stage = '9 Month Report'		THEN WorkFlowEndDate_Skey END)					AS WorkFlow9MonthReportEndDate_Skey
	, MIN(CASE WHEN Stage = 'After Month 9'			THEN WorkFlowEndDate_Skey END)					AS WorkFlowAfterMonth9EndDate_Skey

	-- Work Flow <Stage> End Time --
	, MIN(CASE WHEN Stage = 'Enquiry'				THEN WorkFlowEndTime_Skey END)					AS WorkFlowEnquiryEndTime_Skey
	, MIN(CASE WHEN Stage = 'Referral'				THEN WorkFlowEndTime_Skey END)					AS WorkFlowReferralEndTime_Skey
	, MIN(CASE WHEN Stage = 'Telephone Assessment'	THEN WorkFlowEndTime_Skey END)					AS WorkFlowTelephoneAssessmentEndTime_Skey
	, MIN(CASE WHEN Stage = 'Initial Support Plan'	THEN WorkFlowEndTime_Skey END)					AS WorkFlowInitialSupportPlanEndTime_Skey
	, MIN(CASE WHEN Stage = 'Month 1'				THEN WorkFlowEndTime_Skey END)					AS WorkFlowMonth1EndTime_Skey
	, MIN(CASE WHEN Stage = 'Month 2'				THEN WorkFlowEndTime_Skey END)					AS WorkFlowMonth2EndTime_Skey
	, MIN(CASE WHEN Stage = 'Month 3'				THEN WorkFlowEndTime_Skey END)					AS WorkFlowMonth3EndTime_Skey
	, MIN(CASE WHEN Stage = 'Month 4'				THEN WorkFlowEndTime_Skey END)					AS WorkFlowMonth4EndTime_Skey
	, MIN(CASE WHEN Stage = 'Month 5'				THEN WorkFlowEndTime_Skey END)					AS WorkFlowMonth5EndTime_Skey
	, MIN(CASE WHEN Stage = '6 Month Report'		THEN WorkFlowEndTime_Skey END)					AS WorkFlow6MonthReportEndTime_Skey
	, MIN(CASE WHEN Stage = 'Month 7'				THEN WorkFlowEndTime_Skey END)					AS WorkFlowMonth7EndTime_Skey
	, MIN(CASE WHEN Stage = 'Month 8'				THEN WorkFlowEndTime_Skey END)					AS WorkFlowMonth8EndTime_Skey
	, MIN(CASE WHEN Stage = '9 Month Report'		THEN WorkFlowEndTime_Skey END)					AS WorkFlow9MonthReportEndTime_Skey
	, MIN(CASE WHEN Stage = 'After Month 9'			THEN WorkFlowEndTime_Skey END)					AS WorkFlowAfterMonth9EndTime_Skey

FROM 
	DW.LNK_Work_Flow_Stages dw_l_wfs
		INNER JOIN DW.D_Stage dw_d_stg
			ON dw_l_wfs.Stage_Skey = dw_d_stg.Stage_Skey
GROUP BY Case_Analysis_Skey
),
 
 AtW_Events AS
 (
 SELECT
        [Case_Analysis_Skey]
	  --, MIN([Candidate_Skey])																		AS [Candidate_Skey]
	  --,	MIN([Case_Skey])																			AS [Case_Skey]
	  --, MIN([Source_Skey])																			AS [Source_Skey]
	  --, MIN([Case_Status_Skey])																		AS [Case_Status_Skey]
	  --, MIN([Programme_Skey])																		AS [Programme_Skey]
	  --, MIN([CaseCreatedDate_Skey])																	AS [CaseCreatedDate_Skey]
	  --, MIN([CaseCreatedTime_Skey])																	AS [CaseCreatedTime_Skey]
	  --, MIN([CaseReceivedDate_Skey])																AS [CaseReceivedDate_Skey]
	  --, MIN([CaseReceivedTime_Skey])																AS [CaseReceivedTime_Skey]
	  --, MIN([PredictedEndDate_Skey])																AS [PredictedEndDate_Skey]
	  --, MIN([PredictedEndTime_Skey])																AS [PredictedEndTime_Skey]
	  --, MIN([ApprovedDate_Skey])																	AS [ApprovedDate_Skey]
	  --, MIN([ApprovedTime_Skey])																	AS [ApprovedTime_Skey]
	  --, MIN([CaseClosedDate_Skey])																	AS [CaseClosedDate_Skey]
	  --, MIN([CaseClosedTime_Skey])																	AS [CaseClosedTime_Skey]
	  --, MIN([CasePlanActiveDate_Skey])																AS [CasePlanActiveDate_Skey]
	  --, MIN([CasePlanActiveTime_Skey])																AS [CasePlanActiveTime_Skey]
	  --, MIN([Employer_Contact_Skey])																AS [Employer_Contact_Skey]
	  --, MIN([Employer_Skey])																		AS [Employer_Skey]
	  --, MIN([Attrition_Reason_Skey])																AS [Attrition_Reason_Skey]
	  --, MIN([CaseOwnerEmp_Skey])																	AS [CaseOwnerEmp_Skey]
	  --, MIN([CaseOwnerEmpHist_Skey])																AS [CaseOwnerEmpHist_Skey]
	  --, MIN([CurrentStage_Skey])																	AS [CurrentStage_Skey]
	  --, MIN([AttritionStage_Skey])																	AS [AttritionStage_Skey]
	  --, MIN([AttritionDate_Skey])																	AS [AttritionDate_Skey]
	  --, MIN([AttritionTime_Skey])																	AS [AttritionTime_Skey]

	  ---- <Event> Counts
	  , SUM(DISTINCT [NewEnquiry])																	AS [NewEnquiry]
	  , SUM(DISTINCT [ReferralCallrequired])														AS [ReferralCallRequired]
	  , SUM(DISTINCT [ReferralCallBackAttempt1])													AS [ReferralCallBackAttempt1]
	  , SUM(DISTINCT [ReferralCallBackAttempt2])													AS [ReferralCallBackAttempt2]
	  , SUM(DISTINCT [ReferralCallBackAttempt3])													AS [ReferralCallBackAttempt3]
	  , SUM(DISTINCT [LiveEnquiry])																	AS [LiveEnquiry]
	  , SUM(DISTINCT [UnsuccessfulEnquiry])															AS [UnsuccessfulEnquiry]
	  , SUM(DISTINCT [SuccessfulEnquiry])															AS [SuccessfulEnquiry]
	  , SUM(DISTINCT [AwaitingReferral])															AS [AwaitingReferral]
	  , SUM(DISTINCT [ReferralReceived])															AS [ReferralReceived]
	  , SUM(DISTINCT [EmailreferraltoDWP])															AS [EmailreferraltoDWP]
	  , SUM(DISTINCT [ReferralApproved])															AS [ReferralApproved]
	  , SUM(DISTINCT [ReferralUnsuccessful])														AS [ReferralUnsuccessful]
	  , SUM(DISTINCT [InitialContact])																AS [InitialContact]
	  , SUM(DISTINCT [AwaitingTelephoneAssessmentMeetingSchedule])									AS [AwaitingTelephoneAssessmentMeetingSchedule]
	  , SUM(DISTINCT [TelephoneAssessmentscheduled])												AS [TelephoneAssessmentscheduled]
	  , SUM(DISTINCT [AwaitingSupportPlanmeetingscheduled])											AS [AwaitingSupportPlanmeetingscheduled]
	  , SUM(DISTINCT [TelephoneAssessmentCompleted])												AS [TelephoneAssessmentCompleted]
	  , SUM(DISTINCT [Supportplanmeetingscheduled])													AS [Supportplanmeetingscheduled]
	  , SUM(DISTINCT [Supportplanmeetingcompleted])													AS [Supportplanmeetingcompleted]
	  , SUM(DISTINCT [Supportplansignedbycustomer])													AS [Supportplansignedbycustomer]
	  , SUM(DISTINCT [SupportplanUploaded])															AS [SupportplanUploaded]
	  , SUM(DISTINCT [SupportplancompletedbutnotsubmittedtoDWP])									AS [SupportplancompletedbutnotsubmittedtoDWP]
	  , SUM(DISTINCT [SupportplansubmittedtoDWP])													AS [SupportplansubmittedtoDWP]
	  , SUM(DISTINCT [SupportPlanNotApprovedbyDWP])													AS [SupportPlanNotApprovedbyDWP]
	  , SUM(DISTINCT [AwaitingSupportPlanReSubmission])												AS [AwaitingSupportPlanReSubmission]
	  , SUM(DISTINCT [SupportPlanReSubmitted])														AS [SupportPlanReSubmitted]
	  , SUM(DISTINCT [SupportplanapprovedbyDWP])													AS [SupportplanapprovedbyDWP]
	  , SUM(DISTINCT [SupportplanpaidbyDWP])														AS [SupportplanpaidbyDWP]
	  , SUM(DISTINCT [Month1updateoutstanding])														AS [Month1updateoutstanding]
	  , SUM(DISTINCT [Month1updatecompleted])														AS [Month1updatecompleted]
	  , SUM(DISTINCT [Month1BOTUpdateCompleted])													AS [Month1BOTUpdateCompleted]
	  , SUM(DISTINCT [Month1updatesubmittedtoDWP])													AS [Month1updatesubmittedtoDWP]
	  , SUM(DISTINCT [Month2updateoutstanding])														AS [Month2updateoutstanding]
	  , SUM(DISTINCT [Month2updatecompleted])														AS [Month2updatecompleted]
	  , SUM(DISTINCT [Month2BOTUpdateCompleted])													AS [Month2BOTUpdateCompleted]
	  , SUM(DISTINCT [Month2updatesubmittedtoDWP])													AS [Month2updatesubmittedtoDWP]
	  , SUM(DISTINCT [Month3updateoutstanding])														AS [Month3updateoutstanding]
	  , SUM(DISTINCT [Month3updatecompleted])														AS [Month3updatecompleted]
	  , SUM(DISTINCT [Month3BOTUpdateCompleted])													AS [Month3BOTUpdateCompleted]
	  , SUM(DISTINCT [Month3updatesubmittedtoDWP])													AS [Month3updatesubmittedtoDWP]
	  , SUM(DISTINCT [Month4updateoutstanding])														AS [Month4updateoutstanding]
	  , SUM(DISTINCT [Month4updatecompleted])														AS [Month4updatecompleted]
	  , SUM(DISTINCT [Month4BOTUpdateCompleted])													AS [Month4BOTUpdateCompleted]
	  , SUM(DISTINCT [Month4updatesubmittedtoDWP])													AS [Month4updatesubmittedtoDWP]
	  , SUM(DISTINCT [Month5updateoutstanding])														AS [Month5updateoutstanding]
	  , SUM(DISTINCT [Month5updatecompleted])														AS [Month5updatecompleted]
	  , SUM(DISTINCT [Month5BOTUpdateCompleted])													AS [Month5BOTUpdateCompleted]
	  , SUM(DISTINCT [Month5updatesubmittedtoDWP])													AS [Month5updatesubmittedtoDWP]
	  , SUM(DISTINCT [Awaiting6MonthSupportPlanmeetingscheduled])									AS [Awaiting6MonthSupportPlanmeetingscheduled]
	  , SUM(DISTINCT [Month6Supportplanmeetingscheduled])											AS [Month6Supportplanmeetingscheduled]
	  , SUM(DISTINCT [Month6Supportplanmeetingcompleted])											AS [Month6Supportplanmeetingcompleted]
	  , SUM(DISTINCT [Month6Supportplansignedbycustomer])											AS [Month6Supportplansignedbycustomer]
	  , SUM(DISTINCT [Month6SupportplanUploaded])													AS [Month6SupportplanUploaded]
	  , SUM(DISTINCT [Month6SupportplancompletedbutnotsubmittedtoDWP])								AS [Month6SupportplancompletedbutnotsubmittedtoDWP]
	  , SUM(DISTINCT [Month6SupportplansubmittedtoDWP])												AS [Month6SupportplansubmittedtoDWP]
	  , SUM(DISTINCT [Month6SupportPlanNotApprovedbyDWP])											AS [Month6SupportPlanNotApprovedbyDWP]
	  , SUM(DISTINCT [AwaitingMonth6SupportPlanReSubmission])										AS [AwaitingMonth6SupportPlanReSubmission]
	  , SUM(DISTINCT [Month6SupportPlanReSubmitted])												AS [Month6SupportPlanReSubmitted]
	  , SUM(DISTINCT [Month6SupportplanapprovedbyDWP])												AS [Month6SupportplanapprovedbyDWP]
	  , SUM(DISTINCT [Month6SupportplanpaidbyDWP])													AS [Month6SupportplanpaidbyDWP]
	  , SUM(DISTINCT [AwaitingTransferToBSC])														AS [AwaitingTransferToBSC]
	  , SUM(DISTINCT [TransferredToBSC])															AS [TransferredToBSC]
	  , SUM(DISTINCT [LightTouchEmailSentUnsuccessful])												AS [LightTouchEmailSentUnsuccessful]
	  , SUM(DISTINCT [LightTouchEmailSentSuccessful])												AS [LightTouchEmailSentSuccessful]
	  , SUM(DISTINCT [AwaitingMonth7Contact])														AS [AwaitingMonth7Contact]
	  , SUM(DISTINCT [Month7ContactSuccessful])														AS [Month7ContactSuccessful]
	  , SUM(DISTINCT [Month7ContactUnsuccessful])													AS [Month7ContactUnsuccessful]
	  , SUM(DISTINCT [AwaitingMonth8Contact])														AS [AwaitingMonth8Contact]
	  , SUM(DISTINCT [Month8ContactSuccessful])														AS [Month8ContactSuccessful]
	  , SUM(DISTINCT [Month8ContactUnsuccessful])													AS [Month8ContactUnsuccessful]
	  , SUM(DISTINCT [Awaiting9MonthReportmeetingscheduled])										AS [Awaiting9MonthReportmeetingscheduled]
	  , SUM(DISTINCT [NineMonthReportmeetingscheduled])												AS [NineMonthReportmeetingscheduled]
	  , SUM(DISTINCT [NineMonthReportmeetingcompleted])												AS [NineMonthReportmeetingcompleted]
	  , SUM(DISTINCT [NineMonthReportsignedbycustomer])												AS [NineMonthReportsignedbycustomer]
	  , SUM(DISTINCT [NineMonthReportUploaded])														AS [NineMonthReportUploaded]
	  , SUM(DISTINCT [NineMonthReportcompletedbutnotsubmittedtoDWP])								AS [NineMonthReportcompletedbutnotsubmittedtoDWP]
	  , SUM(DISTINCT [NineMonthReportsubmittedtoDWP])												AS [NineMonthReportsubmittedtoDWP]
	  , SUM(DISTINCT [NineMonthReportNotApprovedbyDWP])												AS [NineMonthReportNotApprovedbyDWP]
	  , SUM(DISTINCT [Awaiting9MonthReportReSubmission])											AS [Awaiting9MonthReportReSubmission]
	  , SUM(DISTINCT [NineMonthReportReSubmitted])													AS [NineMonthReportReSubmitted]
	  , SUM(DISTINCT [NineMonthReportApprovedbyDWP])												AS [NineMonthReportApprovedbyDWP]
	  , SUM(DISTINCT [NineMonthReportpaidbyDWP])													AS [NineMonthReportpaidbyDWP]
	  , SUM(DISTINCT [Rejected])																	AS [Rejected]
	  , SUM(DISTINCT [MarketingCampaignAttempted])													AS [MarketingCampaignAttempted]
	  , SUM(DISTINCT [Month7ContactAttempted])														AS [Month7ContactAttempted]
	  , SUM(DISTINCT [Month8ContactAttempted])														AS [Month8ContactAttempted]
	  , SUM(DISTINCT [Month1UpdateSuccessful])														AS [Month1UpdateSuccessful]
	  , SUM(DISTINCT [Month2UpdateSuccessful])														AS [Month2UpdateSuccessful]
	  , SUM(DISTINCT [Month3UpdateSuccessful])														AS [Month3UpdateSuccessful]
	  , SUM(DISTINCT [Month4UpdateSuccessful])														AS [Month4UpdateSuccessful]
	  , SUM(DISTINCT [Month5UpdateSuccessful])														AS [Month5UpdateSuccessful]

	  -- <Event> Date
	  ,	MIN(CASE WHEN WorkFlowEventType = 'New Enquiry'												THEN WorkFlowEventDate_Skey END) AS NewEnquiryDate_Skey
	  ,	MIN(CASE WHEN WorkFlowEventType = 'Referral call required'									THEN WorkFlowEventDate_Skey END) AS ReferralCallRequiredDate_Skey
	  ,	MIN(CASE WHEN WorkFlowEventType = 'Referral call back - Attempt 1'							THEN WorkFlowEventDate_Skey END) AS ReferralCallBackAttempt1Date_Skey
	  ,	MIN(CASE WHEN WorkFlowEventType = 'Referral call back - Attempt 2'							THEN WorkFlowEventDate_Skey END) AS ReferralCallBackAttempt2Date_Skey
	  ,	MIN(CASE WHEN WorkFlowEventType = 'Referral call back - Attempt 3'							THEN WorkFlowEventDate_Skey END) AS ReferralCallBackAttempt3Date_Skey
	  ,	MIN(CASE WHEN WorkFlowEventType = 'Live Enquiry'											THEN WorkFlowEventDate_Skey END) AS LiveEnquiryDate_Skey
	  ,	MIN(CASE WHEN WorkFlowEventType = 'Unsuccessful Enquiry'									THEN WorkFlowEventDate_Skey END) AS UnsuccessfulEnquiryDate_Skey
	  ,	MIN(CASE WHEN WorkFlowEventType = 'Successful Enquiry'										THEN WorkFlowEventDate_Skey END) AS SuccessfulEnquiryDate_Skey
	  ,	MIN(CASE WHEN WorkFlowEventType = 'Awaiting Referral'										THEN WorkFlowEventDate_Skey END) AS AwaitingReferralDate_Skey
	  ,	MIN(CASE WHEN WorkFlowEventType = 'Referral Received'										THEN WorkFlowEventDate_Skey END) AS ReferralReceivedDate_Skey
	  ,	MIN(CASE WHEN WorkFlowEventType = 'Email referral to DWP'									THEN WorkFlowEventDate_Skey END) AS EmailreferraltoDWPDate_Skey
	  ,	MIN(CASE WHEN WorkFlowEventType = 'Referral Approved'										THEN WorkFlowEventDate_Skey END) AS ReferralApprovedDate_Skey
	  ,	MIN(CASE WHEN WorkFlowEventType = 'Referral Unsuccessful'									THEN WorkFlowEventDate_Skey END) AS ReferralUnsuccessfulDate_Skey
	  ,	MIN(CASE WHEN WorkFlowEventType = 'Initial Contact'											THEN WorkFlowEventDate_Skey END) AS InitialContactDate_Skey
	  ,	MIN(CASE WHEN WorkFlowEventType = 'Awaiting Telephone Assessment Meeting Schedule'			THEN WorkFlowEventDate_Skey END) AS AwaitingTelephoneAssessmentMeetingScheduleDate_Skey
	  ,	MIN(CASE WHEN WorkFlowEventType = 'Telephone Assessment scheduled'							THEN WorkFlowEventDate_Skey END) AS TelephoneAssessmentscheduledDate_Skey
	  ,	MIN(CASE WHEN WorkFlowEventType = 'Telephone Assessment Completed'							THEN WorkFlowEventDate_Skey END) AS TelephoneAssessmentCompletedDate_Skey
	  ,	MIN(CASE WHEN WorkFlowEventType = 'Awaiting Support Plan meeting scheduled'					THEN WorkFlowEventDate_Skey END) AS AwaitingSupportPlanmeetingscheduledDate_Skey
	  ,	MIN(CASE WHEN WorkFlowEventType = 'Support plan meeting scheduled'							THEN WorkFlowEventDate_Skey END) AS SupportplanmeetingscheduledDate_Skey
	  ,	MIN(CASE WHEN WorkFlowEventType = 'Support plan meeting completed'							THEN WorkFlowEventDate_Skey END) AS SupportplanmeetingcompletedDate_Skey
	  ,	MIN(CASE WHEN WorkFlowEventType = 'Support plan signed by customer'							THEN WorkFlowEventDate_Skey END) AS SupportplansignedbycustomerDate_Skey
	  ,	MIN(CASE WHEN WorkFlowEventType = 'Support plan Uploaded'									THEN WorkFlowEventDate_Skey END) AS SupportplanUploadedDate_Skey
	  ,	MIN(CASE WHEN WorkFlowEventType = 'Support plan completed but not submitted to DWP'			THEN WorkFlowEventDate_Skey END) AS SupportplancompletedbutnotsubmittedtoDWPDate_Skey
	  ,	MIN(CASE WHEN WorkFlowEventType = 'Support plan submitted to DWP'							THEN WorkFlowEventDate_Skey END) AS SupportplansubmittedtoDWPDate_Skey
	  ,	MIN(CASE WHEN WorkFlowEventType = 'Support Plan Not Approved by DWP'						THEN WorkFlowEventDate_Skey END) AS SupportPlanNotApprovedbyDWPDate_Skey
	  ,	MIN(CASE WHEN WorkFlowEventType = 'Awaiting Support Plan Re-Submission'						THEN WorkFlowEventDate_Skey END) AS AwaitingSupportPlanReSubmissionDate_Skey
	  ,	MIN(CASE WHEN WorkFlowEventType = 'Support Plan Re-Submitted'								THEN WorkFlowEventDate_Skey END) AS SupportPlanReSubmittedDate_Skey
	  ,	MIN(CASE WHEN WorkFlowEventType = 'Support plan approved by DWP'							THEN WorkFlowEventDate_Skey END) AS SupportplanapprovedbyDWPDate_Skey
	  ,	MIN(CASE WHEN WorkFlowEventType = 'Support plan paid by DWP'								THEN WorkFlowEventDate_Skey END) AS SupportplanpaidbyDWPDate_Skey
	  ,	MIN(CASE WHEN WorkFlowEventType = 'Month 1 update outstanding'								THEN WorkFlowEventDate_Skey END) AS Month1updateoutstandingDate_Skey
	  ,	MIN(CASE WHEN WorkFlowEventType = 'Month 1 update completed'								THEN WorkFlowEventDate_Skey END) AS Month1updatecompletedDate_Skey
	  ,	MIN(CASE WHEN WorkFlowEventType = 'Month 1 BOT Update Completed'							THEN WorkFlowEventDate_Skey END) AS Month1BOTUpdateCompletedDate_Skey
	  ,	MIN(CASE WHEN WorkFlowEventType = 'Month 1 update submitted to DWP'							THEN WorkFlowEventDate_Skey END) AS Month1updatesubmittedtoDWPDate_Skey
	  ,	MIN(CASE WHEN WorkFlowEventType = 'Month 2 update outstanding'								THEN WorkFlowEventDate_Skey END) AS Month2updateoutstandingDate_Skey
	  ,	MIN(CASE WHEN WorkFlowEventType = 'Month 2 update completed'								THEN WorkFlowEventDate_Skey END) AS Month2updatecompletedDate_Skey
	  ,	MIN(CASE WHEN WorkFlowEventType = 'Month 2 BOT Update Completed'							THEN WorkFlowEventDate_Skey END) AS Month2BOTUpdateCompletedDate_Skey
	  ,	MIN(CASE WHEN WorkFlowEventType = 'Month 2 update submitted to DWP'							THEN WorkFlowEventDate_Skey END) AS Month2updatesubmittedtoDWPDate_Skey
	  ,	MIN(CASE WHEN WorkFlowEventType = 'Month 3 update outstanding'								THEN WorkFlowEventDate_Skey END) AS Month3updateoutstandingDate_Skey
	  ,	MIN(CASE WHEN WorkFlowEventType = 'Month 3 update completed'								THEN WorkFlowEventDate_Skey END) AS Month3updatecompletedDate_Skey
	  ,	MIN(CASE WHEN WorkFlowEventType = 'Month 3 BOT Update Completed'							THEN WorkFlowEventDate_Skey END) AS Month3BOTUpdateCompletedDate_Skey
	  ,	MIN(CASE WHEN WorkFlowEventType = 'Month 3 update submitted to DWP'							THEN WorkFlowEventDate_Skey END) AS Month3updatesubmittedtoDWPDate_Skey
	  ,	MIN(CASE WHEN WorkFlowEventType = 'Month 4 update outstanding'								THEN WorkFlowEventDate_Skey END) AS Month4updateoutstandingDate_Skey
	  ,	MIN(CASE WHEN WorkFlowEventType = 'Month 4 update completed'								THEN WorkFlowEventDate_Skey END) AS Month4updatecompletedDate_Skey
	  ,	MIN(CASE WHEN WorkFlowEventType = 'Month 4 BOT Update Completed'							THEN WorkFlowEventDate_Skey END) AS Month4BOTUpdateCompletedDate_Skey
	  ,	MIN(CASE WHEN WorkFlowEventType = 'Month 4 update submitted to DWP'							THEN WorkFlowEventDate_Skey END) AS Month4updatesubmittedtoDWPDate_Skey
	  ,	MIN(CASE WHEN WorkFlowEventType = 'Month 5 update outstanding'								THEN WorkFlowEventDate_Skey END) AS Month5updateoutstandingDate_Skey
	  ,	MIN(CASE WHEN WorkFlowEventType = 'Month 5 update completed'								THEN WorkFlowEventDate_Skey END) AS Month5updatecompletedDate_Skey
	  ,	MIN(CASE WHEN WorkFlowEventType = 'Month 5 BOT Update Completed'							THEN WorkFlowEventDate_Skey END) AS Month5BOTUpdateCompletedDate_Skey
	  ,	MIN(CASE WHEN WorkFlowEventType = 'Month 5 update submitted to DWP'							THEN WorkFlowEventDate_Skey END) AS Month5updatesubmittedtoDWPDate_Skey
	  ,	MIN(CASE WHEN WorkFlowEventType = 'Awaiting 6 Month Support Plan meeting scheduled'			THEN WorkFlowEventDate_Skey END) AS Awaiting6MonthSupportPlanmeetingscheduledDate_Skey
	  ,	MIN(CASE WHEN WorkFlowEventType = 'Month 6 Support plan meeting scheduled'					THEN WorkFlowEventDate_Skey END) AS Month6SupportplanmeetingscheduledDate_Skey
	  ,	MIN(CASE WHEN WorkFlowEventType = 'Month 6 Support plan meeting completed'					THEN WorkFlowEventDate_Skey END) AS Month6SupportplanmeetingcompletedDate_Skey
	  ,	MIN(CASE WHEN WorkFlowEventType = 'Month 6 Support plan signed by customer'					THEN WorkFlowEventDate_Skey END) AS Month6SupportplansignedbycustomerDate_Skey
	  ,	MIN(CASE WHEN WorkFlowEventType = 'Month 6 Support plan Uploaded'							THEN WorkFlowEventDate_Skey END) AS Month6SupportplanUploadedDate_Skey
	  ,	MIN(CASE WHEN WorkFlowEventType = 'Month 6 Support plan completed but not submitted to DWP' THEN WorkFlowEventDate_Skey END) AS Month6SupportplancompletedbutnotsubmittedtoDWPDate_Skey
	  ,	MIN(CASE WHEN WorkFlowEventType = 'Month 6 Support plan submitted to DWP'					THEN WorkFlowEventDate_Skey END) AS Month6SupportplansubmittedtoDWPDate_Skey
	  ,	MIN(CASE WHEN WorkFlowEventType = 'Month 6 Support Plan Not Approved by DWP'				THEN WorkFlowEventDate_Skey END) AS Month6SupportPlanNotApprovedbyDWPDate_Skey
	  ,	MIN(CASE WHEN WorkFlowEventType = 'Awaiting Month 6 Support Plan Re-Submission'				THEN WorkFlowEventDate_Skey END) AS AwaitingMonth6SupportPlanReSubmissionDate_Skey
	  ,	MIN(CASE WHEN WorkFlowEventType = 'Month 6 Support Plan Re-Submitted'						THEN WorkFlowEventDate_Skey END) AS Month6SupportPlanReSubmittedDate_Skey
	  ,	MIN(CASE WHEN WorkFlowEventType = 'Month 6 Support plan approved by DWP'					THEN WorkFlowEventDate_Skey END) AS Month6SupportplanapprovedbyDWPDate_Skey
	  ,	MIN(CASE WHEN WorkFlowEventType = 'Month 6 Support plan paid by DWP'						THEN WorkFlowEventDate_Skey END) AS Month6SupportplanpaidbyDWPDate_Skey
	  ,	MIN(CASE WHEN WorkFlowEventType = 'Awaiting Transfer To BSC'								THEN WorkFlowEventDate_Skey END) AS AwaitingTransferToBSCDate_Skey
	  ,	MIN(CASE WHEN WorkFlowEventType = 'Transferred To BSC'										THEN WorkFlowEventDate_Skey END) AS TransferredToBSCDate_Skey
	  ,	MIN(CASE WHEN WorkFlowEventType = 'Light Touch Email Sent - Unsuccessful'					THEN WorkFlowEventDate_Skey END) AS LightTouchEmailSentUnsuccessfulDate_Skey
	  ,	MIN(CASE WHEN WorkFlowEventType = 'Light Touch Email Sent - Successful'						THEN WorkFlowEventDate_Skey END) AS LightTouchEmailSentSuccessfulDate_Skey
	  ,	MIN(CASE WHEN WorkFlowEventType = 'Awaiting Month 7 Contact'								THEN WorkFlowEventDate_Skey END) AS AwaitingMonth7ContactDate_Skey
	  ,	MIN(CASE WHEN WorkFlowEventType = 'Month 7 Contact Successful'								THEN WorkFlowEventDate_Skey END) AS Month7ContactSuccessfulDate_Skey
	  ,	MIN(CASE WHEN WorkFlowEventType = 'Month 7 Contact Unsuccessful'							THEN WorkFlowEventDate_Skey END) AS Month7ContactUnsuccessfulDate_Skey
	  ,	MIN(CASE WHEN WorkFlowEventType = 'Awaiting Month 8 Contact'								THEN WorkFlowEventDate_Skey END) AS AwaitingMonth8ContactDate_Skey
	  ,	MIN(CASE WHEN WorkFlowEventType = 'Month 8 Contact Successful'								THEN WorkFlowEventDate_Skey END) AS Month8ContactSuccessfulDate_Skey
	  ,	MIN(CASE WHEN WorkFlowEventType = 'Month 8 Contact Unsuccessful'							THEN WorkFlowEventDate_Skey END) AS Month8ContactUnsuccessfulDate_Skey
	  ,	MIN(CASE WHEN WorkFlowEventType = 'Awaiting 9 Month Report meeting scheduled'				THEN WorkFlowEventDate_Skey END) AS Awaiting9MonthReportmeetingscheduledDate_Skey
	  ,	MIN(CASE WHEN WorkFlowEventType = '9 Month Report meeting scheduled'						THEN WorkFlowEventDate_Skey END) AS NineMonthReportmeetingscheduledDate_Skey
	  ,	MIN(CASE WHEN WorkFlowEventType = '9 Month Report meeting completed'						THEN WorkFlowEventDate_Skey END) AS NineMonthReportmeetingcompletedDate_Skey
	  ,	MIN(CASE WHEN WorkFlowEventType = '9 Month Report signed by customer'						THEN WorkFlowEventDate_Skey END) AS NineMonthReportsignedbycustomerDate_Skey
	  ,	MIN(CASE WHEN WorkFlowEventType = '9 Month Report Uploaded'									THEN WorkFlowEventDate_Skey END) AS NineMonthReportUploadedDate_Skey
	  ,	MIN(CASE WHEN WorkFlowEventType = '9 Month Report completed but not submitted to DWP'		THEN WorkFlowEventDate_Skey END) AS NineMonthReportcompletedbutnotsubmittedtoDWPDate_Skey
	  ,	MIN(CASE WHEN WorkFlowEventType = '9 Month Report submitted to DWP'							THEN WorkFlowEventDate_Skey END) AS NineMonthReportsubmittedtoDWPDate_Skey
	  ,	MIN(CASE WHEN WorkFlowEventType = '9 Month Report Not Approved by DWP'						THEN WorkFlowEventDate_Skey END) AS NineMonthReportNotApprovedbyDWPDate_Skey
	  ,	MIN(CASE WHEN WorkFlowEventType = 'Awaiting 9 Month Report Re-Submission'					THEN WorkFlowEventDate_Skey END) AS Awaiting9MonthReportReSubmissionDate_Skey
	  ,	MIN(CASE WHEN WorkFlowEventType = '9 Month Report Re-Submitted'								THEN WorkFlowEventDate_Skey END) AS NineMonthReportReSubmittedDate_Skey
	  ,	MIN(CASE WHEN WorkFlowEventType = '9 Month Report approved by DWP'							THEN WorkFlowEventDate_Skey END) AS NineMonthReportapprovedbyDWPDate_Skey
	  ,	MIN(CASE WHEN WorkFlowEventType = '9 Month Report paid by DWP'								THEN WorkFlowEventDate_Skey END) AS NineMonthReportpaidbyDWPDate_Skey
	  ,	MIN(CASE WHEN WorkFlowEventType = 'Rejected'												THEN WorkFlowEventDate_Skey END) AS RejectedDate_Skey
	  , MIN(CASE WHEN (WorkFlowEventType = 'Light Touch Email Sent - Unsuccessful' AND WorkFlowEventDate_Skey <> -1) OR (WorkFlowEventType = 'Light Touch Email Sent - Successful' AND WorkFlowEventDate_Skey <> -1)	THEN WorkFlowEventDate_Skey END) AS MarketingCampaignAttemptedDate_Skey
	  , MIN(CASE WHEN (WorkFlowEventType = 'Month 7 Contact Unsuccessful' AND WorkFlowEventDate_Skey <> -1) OR (WorkFlowEventType = 'Month 7 Contact Successful' AND WorkFlowEventDate_Skey <> -1)						THEN WorkFlowEventDate_Skey END) AS Month7ContactAttemptedDate_Skey
	  , MIN(CASE WHEN (WorkFlowEventType = 'Month 8 Contact Unsuccessful' AND WorkFlowEventDate_Skey <> -1) OR (WorkFlowEventType = 'Month 8 Contact Successful' AND WorkFlowEventDate_Skey <> -1)						THEN WorkFlowEventDate_Skey END) AS Month8ContactAttemptedDate_Skey
	  , MIN(CASE WHEN (WorkFlowEventType = 'Month 1 update completed' AND WorkFlowEventDate_Skey <> -1) OR (WorkFlowEventType = 'Month 1 BOT Update Completed' AND WorkFlowEventDate_Skey <> -1)						THEN WorkFlowEventDate_Skey END) AS Month1UpdateSuccessfulDate_Skey
	  , MIN(CASE WHEN (WorkFlowEventType = 'Month 2 update completed' AND WorkFlowEventDate_Skey <> -1) OR (WorkFlowEventType = 'Month 2 BOT Update Completed' AND WorkFlowEventDate_Skey <> -1)						THEN WorkFlowEventDate_Skey END) AS Month2UpdateSuccessfulDate_Skey
	  , MIN(CASE WHEN (WorkFlowEventType = 'Month 3 update completed' AND WorkFlowEventDate_Skey <> -1) OR (WorkFlowEventType = 'Month 3 BOT Update Completed' AND WorkFlowEventDate_Skey <> -1)						THEN WorkFlowEventDate_Skey END) AS Month3UpdateSuccessfulDate_Skey
	  , MIN(CASE WHEN (WorkFlowEventType = 'Month 4 update completed' AND WorkFlowEventDate_Skey <> -1) OR (WorkFlowEventType = 'Month 4 BOT Update Completed' AND WorkFlowEventDate_Skey <> -1)						THEN WorkFlowEventDate_Skey END) AS Month4UpdateSuccessfulDate_Skey
	  , MIN(CASE WHEN (WorkFlowEventType = 'Month 5 update completed' AND WorkFlowEventDate_Skey <> -1) OR (WorkFlowEventType = 'Month 5 BOT Update Completed' AND WorkFlowEventDate_Skey <> -1)						THEN WorkFlowEventDate_Skey END) AS Month5UpdateSuccessfulDate_Skey

	  --<Event> Estimated Start Date
	  , MIN(CASE WHEN WorkFlowEventType = 'New Enquiry'												THEN WorkFlowEstimatedStartDate_Skey END) AS NewEnquiryEstimatedStartDate_Skey
	  ,	MIN(CASE WHEN WorkFlowEventType = 'Referral call required'									THEN WorkFlowEstimatedStartDate_Skey END) AS ReferralCallRequiredEstimatedStartDate_Skey
	  ,	MIN(CASE WHEN WorkFlowEventType = 'Referral call back - Attempt 1'							THEN WorkFlowEstimatedStartDate_Skey END) AS ReferralCallBackAttempt1EstimatedStartDate_Skey
	  ,	MIN(CASE WHEN WorkFlowEventType = 'Referral call back - Attempt 2'							THEN WorkFlowEstimatedStartDate_Skey END) AS ReferralCallBackAttempt2EstimatedStartDate_Skey
	  ,	MIN(CASE WHEN WorkFlowEventType = 'Referral call back - Attempt 3'							THEN WorkFlowEstimatedStartDate_Skey END) AS ReferralCallBackAttempt3EstimatedStartDate_Skey
	  ,	MIN(CASE WHEN WorkFlowEventType = 'Live Enquiry'											THEN WorkFlowEstimatedStartDate_Skey END) AS LiveEnquiryEstimatedStartDate_Skey
	  , MIN(CASE WHEN WorkFlowEventType = 'Unsuccessful Enquiry'									THEN WorkFlowEstimatedStartDate_Skey END) AS UnsuccessfulEnquiryEstimatedStartDate_Skey
	  , MIN(CASE WHEN WorkFlowEventType = 'Successful Enquiry'										THEN WorkFlowEstimatedStartDate_Skey END) AS SuccessfulEnquiryEstimatedStartDate_Skey
	  , MIN(CASE WHEN WorkFlowEventType = 'Awaiting Referral'										THEN WorkFlowEstimatedStartDate_Skey END) AS AwaitingReferralEstimatedStartDate_Skey
	  , MIN(CASE WHEN WorkFlowEventType = 'Referral Received'										THEN WorkFlowEstimatedStartDate_Skey END) AS ReferralReceivedEstimatedStartDate_Skey
	  , MIN(CASE WHEN WorkFlowEventType = 'Email referral to DWP'									THEN WorkFlowEstimatedStartDate_Skey END) AS EmailreferraltoDWPEstimatedStartDate_Skey
	  , MIN(CASE WHEN WorkFlowEventType = 'Referral Approved'										THEN WorkFlowEstimatedStartDate_Skey END) AS ReferralApprovedEstimatedStartDate_Skey
	  , MIN(CASE WHEN WorkFlowEventType = 'Referral Unsuccessful'									THEN WorkFlowEstimatedStartDate_Skey END) AS ReferralUnsuccessfulEstimatedStartDate_Skey
	  , MIN(CASE WHEN WorkFlowEventType = 'Initial Contact'											THEN WorkFlowEstimatedStartDate_Skey END) AS InitialContactEstimatedStartDate_Skey
	  , MIN(CASE WHEN WorkFlowEventType = 'Awaiting Telephone Assessment Meeting Schedule'			THEN WorkFlowEstimatedStartDate_Skey END) AS AwaitingTelephoneAssessmentMeetingScheduleEstimatedStartDate_Skey
	  , MIN(CASE WHEN WorkFlowEventType = 'Telephone Assessment scheduled'							THEN WorkFlowEstimatedStartDate_Skey END) AS TelephoneAssessmentscheduledEstimatedStartDate_Skey
	  , MIN(CASE WHEN WorkFlowEventType = 'Telephone Assessment Completed'							THEN WorkFlowEstimatedStartDate_Skey END) AS TelephoneAssessmentCompletedEstimatedStartDate_Skey
	  , MIN(CASE WHEN WorkFlowEventType = 'Awaiting Support Plan meeting scheduled'					THEN WorkFlowEstimatedStartDate_Skey END) AS AwaitingSupportPlanmeetingscheduledEstimatedStartDate_Skey
	  , MIN(CASE WHEN WorkFlowEventType = 'Support plan meeting scheduled'							THEN WorkFlowEstimatedStartDate_Skey END) AS SupportplanmeetingscheduledEstimatedStartDate_Skey
	  , MIN(CASE WHEN WorkFlowEventType = 'Support plan meeting completed'							THEN WorkFlowEstimatedStartDate_Skey END) AS SupportplanmeetingcompletedEstimatedStartDate_Skey
	  , MIN(CASE WHEN WorkFlowEventType = 'Support plan signed by customer'							THEN WorkFlowEstimatedStartDate_Skey END) AS SupportplansignedbycustomerEstimatedStartDate_Skey
	  , MIN(CASE WHEN WorkFlowEventType = 'Support plan Uploaded'									THEN WorkFlowEstimatedStartDate_Skey END) AS SupportplanUploadedEstimatedStartDate_Skey
	  , MIN(CASE WHEN WorkFlowEventType = 'Support plan completed but not submitted to DWP'			THEN WorkFlowEstimatedStartDate_Skey END) AS SupportplancompletedbutnotsubmittedtoDWPEstimatedStartDate_Skey
	  , MIN(CASE WHEN WorkFlowEventType = 'Support plan submitted to DWP'							THEN WorkFlowEstimatedStartDate_Skey END) AS SupportplansubmittedtoDWPEstimatedStartDate_Skey
	  , MIN(CASE WHEN WorkFlowEventType = 'Support Plan Not Approved by DWP'						THEN WorkFlowEstimatedStartDate_Skey END) AS SupportPlanNotApprovedbyDWPEstimatedStartDate_Skey
	  , MIN(CASE WHEN WorkFlowEventType = 'Awaiting Support Plan Re-Submission'						THEN WorkFlowEstimatedStartDate_Skey END) AS AwaitingSupportPlanReSubmissionEstimatedStartDate_Skey
	  , MIN(CASE WHEN WorkFlowEventType = 'Support Plan Re-Submitted'								THEN WorkFlowEstimatedStartDate_Skey END) AS SupportPlanReSubmittedEstimatedStartDate_Skey
	  , MIN(CASE WHEN WorkFlowEventType = 'Support plan approved by DWP'							THEN WorkFlowEstimatedStartDate_Skey END) AS SupportplanapprovedbyDWPEstimatedStartDate_Skey
	  , MIN(CASE WHEN WorkFlowEventType = 'Support plan paid by DWP'								THEN WorkFlowEstimatedStartDate_Skey END) AS SupportplanpaidbyDWPEstimatedStartDate_Skey
	  , MIN(CASE WHEN WorkFlowEventType = 'Month 1 update outstanding'								THEN WorkFlowEstimatedStartDate_Skey END) AS Month1updateoutstandingEstimatedStartDate_Skey
	  , MIN(CASE WHEN WorkFlowEventType = 'Month 1 update completed'								THEN WorkFlowEstimatedStartDate_Skey END) AS Month1updatecompletedEstimatedStartDate_Skey
	  , MIN(CASE WHEN WorkFlowEventType = 'Month 1 BOT Update Completed'							THEN WorkFlowEstimatedStartDate_Skey END) AS Month1BOTUpdateCompletedEstimatedStartDate_Skey
	  , MIN(CASE WHEN WorkFlowEventType = 'Month 1 update submitted to DWP'							THEN WorkFlowEstimatedStartDate_Skey END) AS Month1updatesubmittedtoDWPEstimatedStartDate_Skey
	  , MIN(CASE WHEN WorkFlowEventType = 'Month 2 update outstanding'								THEN WorkFlowEstimatedStartDate_Skey END) AS Month2updateoutstandingEstimatedStartDate_Skey
	  , MIN(CASE WHEN WorkFlowEventType = 'Month 2 update completed'								THEN WorkFlowEstimatedStartDate_Skey END) AS Month2updatecompletedEstimatedStartDate_Skey
	  , MIN(CASE WHEN WorkFlowEventType = 'Month 2 BOT Update Completed'							THEN WorkFlowEstimatedStartDate_Skey END) AS Month2BOTUpdateCompletedEstimatedStartDate_Skey
	  , MIN(CASE WHEN WorkFlowEventType = 'Month 2 update submitted to DWP'							THEN WorkFlowEstimatedStartDate_Skey END) AS Month2updatesubmittedtoDWPEstimatedStartDate_Skey
	  , MIN(CASE WHEN WorkFlowEventType = 'Month 3 update outstanding'								THEN WorkFlowEstimatedStartDate_Skey END) AS Month3updateoutstandingEstimatedStartDate_Skey
	  , MIN(CASE WHEN WorkFlowEventType = 'Month 3 update completed'								THEN WorkFlowEstimatedStartDate_Skey END) AS Month3updatecompletedEstimatedStartDate_Skey
	  , MIN(CASE WHEN WorkFlowEventType = 'Month 3 BOT Update Completed'							THEN WorkFlowEstimatedStartDate_Skey END) AS Month3BOTUpdateCompletedEstimatedStartDate_Skey
	  , MIN(CASE WHEN WorkFlowEventType = 'Month 3 update submitted to DWP'							THEN WorkFlowEstimatedStartDate_Skey END) AS Month3updatesubmittedtoDWPEstimatedStartDate_Skey
	  , MIN(CASE WHEN WorkFlowEventType = 'Month 4 update outstanding'								THEN WorkFlowEstimatedStartDate_Skey END) AS Month4updateoutstandingEstimatedStartDate_Skey
	  , MIN(CASE WHEN WorkFlowEventType = 'Month 4 update completed'								THEN WorkFlowEstimatedStartDate_Skey END) AS Month4updatecompletedEstimatedStartDate_Skey
	  , MIN(CASE WHEN WorkFlowEventType = 'Month 4 BOT Update Completed'							THEN WorkFlowEstimatedStartDate_Skey END) AS Month4BOTUpdateCompletedEstimatedStartDate_Skey
	  , MIN(CASE WHEN WorkFlowEventType = 'Month 4 update submitted to DWP'							THEN WorkFlowEstimatedStartDate_Skey END) AS Month4updatesubmittedtoDWPEstimatedStartDate_Skey
	  , MIN(CASE WHEN WorkFlowEventType = 'Month 5 update outstanding'								THEN WorkFlowEstimatedStartDate_Skey END) AS Month5updateoutstandingEstimatedStartDate_Skey
	  , MIN(CASE WHEN WorkFlowEventType = 'Month 5 update completed'								THEN WorkFlowEstimatedStartDate_Skey END) AS Month5updatecompletedEstimatedStartDate_Skey
	  , MIN(CASE WHEN WorkFlowEventType = 'Month 5 BOT Update Completed'							THEN WorkFlowEstimatedStartDate_Skey END) AS Month5BOTUpdateCompletedEstimatedStartDate_Skey
	  , MIN(CASE WHEN WorkFlowEventType = 'Month 5 update submitted to DWP'							THEN WorkFlowEstimatedStartDate_Skey END) AS Month5updatesubmittedtoDWPEstimatedStartDate_Skey
	  , MIN(CASE WHEN WorkFlowEventType = 'Awaiting 6 Month Support Plan meeting scheduled'			THEN WorkFlowEstimatedStartDate_Skey END) AS Awaiting6MonthSupportPlanmeetingscheduledEstimatedStartDate_Skey
	  , MIN(CASE WHEN WorkFlowEventType = 'Month 6 Support plan meeting scheduled'					THEN WorkFlowEstimatedStartDate_Skey END) AS Month6SupportplanmeetingscheduledEstimatedStartDate_Skey
	  , MIN(CASE WHEN WorkFlowEventType = 'Month 6 Support plan meeting completed'					THEN WorkFlowEstimatedStartDate_Skey END) AS Month6SupportplanmeetingcompletedEstimatedStartDate_Skey
	  , MIN(CASE WHEN WorkFlowEventType = 'Month 6 Support plan signed by customer'					THEN WorkFlowEstimatedStartDate_Skey END) AS Month6SupportplansignedbycustomerEstimatedStartDate_Skey
	  , MIN(CASE WHEN WorkFlowEventType = 'Month 6 Support plan Uploaded'							THEN WorkFlowEstimatedStartDate_Skey END) AS Month6SupportplanUploadedEstimatedStartDate_Skey
	  , MIN(CASE WHEN WorkFlowEventType = 'Month 6 Support plan completed but not submitted to DWP' THEN WorkFlowEstimatedStartDate_Skey END) AS Month6SupportplancompletedbutnotsubmittedtoDWPEstimatedStartDate_Skey
	  , MIN(CASE WHEN WorkFlowEventType = 'Month 6 Support plan submitted to DWP'					THEN WorkFlowEstimatedStartDate_Skey END) AS Month6SupportplansubmittedtoDWPEstimatedStartDate_Skey	  
	  , MIN(CASE WHEN WorkFlowEventType = 'Month 6 Support Plan Not Approved by DWP'				THEN WorkFlowEstimatedStartDate_Skey END) AS Month6SupportPlanNotApprovedbyDWPEstimatedStartDate_Skey
	  , MIN(CASE WHEN WorkFlowEventType = 'Awaiting Month 6 Support Plan Re-Submission'				THEN WorkFlowEstimatedStartDate_Skey END) AS AwaitingMonth6SupportPlanReSubmissionEstimatedStartDate_Skey
	  , MIN(CASE WHEN WorkFlowEventType = 'Month 6 Support Plan Re-Submitted'						THEN WorkFlowEstimatedStartDate_Skey END) AS Month6SupportPlanReSubmittedEstimatedStartDate_Skey
	  , MIN(CASE WHEN WorkFlowEventType = 'Month 6 Support plan approved by DWP'					THEN WorkFlowEstimatedStartDate_Skey END) AS Month6SupportplanapprovedbyDWPEstimatedStartDate_Skey
	  , MIN(CASE WHEN WorkFlowEventType = 'Month 6 Support plan paid by DWP'						THEN WorkFlowEstimatedStartDate_Skey END) AS Month6SupportplanpaidbyDWPEstimatedStartDate_Skey
	  , MIN(CASE WHEN WorkFlowEventType = 'Awaiting Transfer To BSC'								THEN WorkFlowEstimatedStartDate_Skey END) AS AwaitingTransferToBSCEstimatedStartDate_Skey
	  , MIN(CASE WHEN WorkFlowEventType = 'Transferred To BSC'										THEN WorkFlowEstimatedStartDate_Skey END) AS TransferredToBSCEstimatedStartDate_Skey
	  , MIN(CASE WHEN WorkFlowEventType = 'Light Touch Email Sent - Unsuccessful'					THEN WorkFlowEstimatedStartDate_Skey END) AS LightTouchEmailSentUnsuccessfulEstimatedStartDate_Skey
	  , MIN(CASE WHEN WorkFlowEventType = 'Light Touch Email Sent - Successful'						THEN WorkFlowEstimatedStartDate_Skey END) AS LightTouchEmailSentSuccessfulEstimatedStartDate_Skey
	  , MIN(CASE WHEN WorkFlowEventType = 'Awaiting Month 7 Contact'								THEN WorkFlowEstimatedStartDate_Skey END) AS AwaitingMonth7ContactEstimatedStartDate_Skey
	  , MIN(CASE WHEN WorkFlowEventType = 'Month 7 Contact Successful'								THEN WorkFlowEstimatedStartDate_Skey END) AS Month7ContactSuccessfulEstimatedStartDate_Skey
	  , MIN(CASE WHEN WorkFlowEventType = 'Month 7 Contact Unsuccessful'							THEN WorkFlowEstimatedStartDate_Skey END) AS Month7ContactUnsuccessfulEstimatedStartDate_Skey
	  , MIN(CASE WHEN WorkFlowEventType = 'Awaiting Month 8 Contact'								THEN WorkFlowEstimatedStartDate_Skey END) AS AwaitingMonth8ContactEstimatedStartDate_Skey
	  , MIN(CASE WHEN WorkFlowEventType = 'Month 8 Contact Successful'								THEN WorkFlowEstimatedStartDate_Skey END) AS Month8ContactSuccessfulEstimatedStartDate_Skey
	  , MIN(CASE WHEN WorkFlowEventType = 'Month 8 Contact Unsuccessful'							THEN WorkFlowEstimatedStartDate_Skey END) AS Month8ContactUnsuccessfulEstimatedStartDate_Skey
	  , MIN(CASE WHEN WorkFlowEventType = 'Awaiting 9 Month Report meeting scheduled'				THEN WorkFlowEstimatedStartDate_Skey END) AS Awaiting9MonthReportmeetingscheduledEstimatedStartDate_Skey
	  , MIN(CASE WHEN WorkFlowEventType = '9 Month Report meeting scheduled'						THEN WorkFlowEstimatedStartDate_Skey END) AS NineMonthReportmeetingscheduledEstimatedStartDate_Skey
	  , MIN(CASE WHEN WorkFlowEventType = '9 Month Report meeting completed'						THEN WorkFlowEstimatedStartDate_Skey END) AS NineMonthReportmeetingcompletedEstimatedStartDate_Skey
	  , MIN(CASE WHEN WorkFlowEventType = '9 Month Report signed by customer'						THEN WorkFlowEstimatedStartDate_Skey END) AS NineMonthReportsignedbycustomerEstimatedStartDate_Skey
	  , MIN(CASE WHEN WorkFlowEventType = '9 Month Report Uploaded'									THEN WorkFlowEstimatedStartDate_Skey END) AS NineMonthReportUploadedEstimatedStartDate_Skey
	  , MIN(CASE WHEN WorkFlowEventType = '9 Month Report completed but not submitted to DWP'		THEN WorkFlowEstimatedStartDate_Skey END) AS NineMonthReportcompletedbutnotsubmittedtoDWPEstimatedStartDate_Skey
	  , MIN(CASE WHEN WorkFlowEventType = '9 Month Report submitted to DWP'							THEN WorkFlowEstimatedStartDate_Skey END) AS NineMonthReportsubmittedtoDWPEstimatedStartDate_Skey	  
	  , MIN(CASE WHEN WorkFlowEventType = '9 Month Report Not Approved by DWP'						THEN WorkFlowEstimatedStartDate_Skey END) AS NineMonthReportNotApprovedbyDWPEstimatedStartDate_Skey
	  , MIN(CASE WHEN WorkFlowEventType = 'Awaiting 9 Month Report Re-Submission'					THEN WorkFlowEstimatedStartDate_Skey END) AS Awaiting9MonthReportReSubmissionEstimatedStartDate_Skey
	  , MIN(CASE WHEN WorkFlowEventType = '9 Month Report Re-Submitted'								THEN WorkFlowEstimatedStartDate_Skey END) AS NineMonthReportReSubmittedEstimatedStartDate_Skey
	  , MIN(CASE WHEN WorkFlowEventType = '9 Month Report approved by DWP'							THEN WorkFlowEstimatedStartDate_Skey END) AS NineMonthReportapprovedbyDWPEstimatedStartDate_Skey
	  , MIN(CASE WHEN WorkFlowEventType = '9 Month Report paid by DWP'								THEN WorkFlowEstimatedStartDate_Skey END) AS NineMonthReportpaidbyDWPEstimatedStartDate_Skey
	  , MIN(CASE WHEN WorkFlowEventType = 'Rejected'												THEN WorkFlowEstimatedStartDate_Skey END) AS RejectedEstimatedStartDate_Skey

	  , MIN(CASE WHEN (WorkFlowEventType = 'Light Touch Email Sent - Unsuccessful' AND WorkFlowEstimatedStartDate_Skey <> -1) OR (WorkFlowEventType = 'Light Touch Email Sent - Successful' AND WorkFlowEstimatedStartDate_Skey <> -1)					THEN WorkFlowEstimatedStartDate_Skey END) AS MarketingCampaignAttemptedEstimatedStartDate_Skey
	  , MIN(CASE WHEN (WorkFlowEventType = 'Month 7 Contact Unsuccessful' AND WorkFlowEstimatedStartDate_Skey <> -1) OR (WorkFlowEventType = 'Month 7 Contact Successful'	  AND WorkFlowEstimatedStartDate_Skey <> -1)								THEN WorkFlowEstimatedStartDate_Skey END) AS Month7ContactAttemptedEstimatedStartDate_Skey
	  , MIN(CASE WHEN (WorkFlowEventType = 'Month 8 Contact Unsuccessful' AND WorkFlowEstimatedStartDate_Skey <> -1) OR (WorkFlowEventType = 'Month 8 Contact Successful'	  AND WorkFlowEstimatedStartDate_Skey <> -1)								THEN WorkFlowEstimatedStartDate_Skey END) AS Month8ContactAttemptedEstimatedStartDate_Skey
	  , MIN(CASE WHEN (WorkFlowEventType = 'Month 1 update completed'     AND WorkFlowEstimatedStartDate_Skey <> -1) OR (WorkFlowEventType = 'Month 1 BOT Update Completed'   AND WorkFlowEstimatedStartDate_Skey <> -1)								THEN WorkFlowEstimatedStartDate_Skey END) AS Month1UpdateSuccessfulEstimatedStartDate_Skey
	  , MIN(CASE WHEN (WorkFlowEventType = 'Month 2 update completed'     AND WorkFlowEstimatedStartDate_Skey <> -1) OR (WorkFlowEventType = 'Month 2 BOT Update Completed'   AND WorkFlowEstimatedStartDate_Skey <> -1)								THEN WorkFlowEstimatedStartDate_Skey END) AS Month2UpdateSuccessfulEstimatedStartDate_Skey
	  , MIN(CASE WHEN (WorkFlowEventType = 'Month 3 update completed'     AND WorkFlowEstimatedStartDate_Skey <> -1) OR (WorkFlowEventType = 'Month 3 BOT Update Completed'   AND WorkFlowEstimatedStartDate_Skey <> -1)								THEN WorkFlowEstimatedStartDate_Skey END) AS Month3UpdateSuccessfulEstimatedStartDate_Skey
	  , MIN(CASE WHEN (WorkFlowEventType = 'Month 4 update completed'     AND WorkFlowEstimatedStartDate_Skey <> -1) OR (WorkFlowEventType = 'Month 4 BOT Update Completed'   AND WorkFlowEstimatedStartDate_Skey <> -1)								THEN WorkFlowEstimatedStartDate_Skey END) AS Month4UpdateSuccessfulEstimatedStartDate_Skey
	  , MIN(CASE WHEN (WorkFlowEventType = 'Month 5 update completed'     AND WorkFlowEstimatedStartDate_Skey <> -1) OR (WorkFlowEventType = 'Month 5 BOT Update Completed'   AND WorkFlowEstimatedStartDate_Skey <> -1)								THEN WorkFlowEstimatedStartDate_Skey END) AS Month5UpdateSuccessfulEstimatedStartDate_Skey

	  --<Event> Estimated End Date
	  , MIN(CASE WHEN WorkFlowEventType = 'New Enquiry'												THEN WorkFlowEstimatedEndDate_Skey END) AS NewEnquiryEstimatedEndDate_Skey
	  ,	MIN(CASE WHEN WorkFlowEventType = 'Referral call required'									THEN WorkFlowEstimatedEndDate_Skey END) AS ReferralCallRequiredEstimatedEndDate_Skey
	  ,	MIN(CASE WHEN WorkFlowEventType = 'Referral call back - Attempt 1'							THEN WorkFlowEstimatedEndDate_Skey END) AS ReferralCallBackAttempt1EstimatedEndDate_Skey
	  ,	MIN(CASE WHEN WorkFlowEventType = 'Referral call back - Attempt 2'							THEN WorkFlowEstimatedEndDate_Skey END) AS ReferralCallBackAttempt2EstimatedEndDate_Skey
	  ,	MIN(CASE WHEN WorkFlowEventType = 'Referral call back - Attempt 3'							THEN WorkFlowEstimatedEndDate_Skey END) AS ReferralCallBackAttempt3EstimatedEndDate_Skey
	  ,	MIN(CASE WHEN WorkFlowEventType = 'Live Enquiry'											THEN WorkFlowEstimatedEndDate_Skey END) AS LiveEnquiryEstimatedEndDate_Skey
	  , MIN(CASE WHEN WorkFlowEventType = 'Unsuccessful Enquiry'									THEN WorkFlowEstimatedEndDate_Skey END) AS UnsuccessfulEnquiryEstimatedEndDate_Skey
	  , MIN(CASE WHEN WorkFlowEventType = 'Successful Enquiry'										THEN WorkFlowEstimatedEndDate_Skey END) AS SuccessfulEnquiryEstimatedEndDate_Skey
	  , MIN(CASE WHEN WorkFlowEventType = 'Awaiting Referral'										THEN WorkFlowEstimatedEndDate_Skey END) AS AwaitingReferralEstimatedEndDate_Skey
	  , MIN(CASE WHEN WorkFlowEventType = 'Referral Received'										THEN WorkFlowEstimatedEndDate_Skey END) AS ReferralReceivedEstimatedEndDate_Skey
	  , MIN(CASE WHEN WorkFlowEventType = 'Email referral to DWP'									THEN WorkFlowEstimatedEndDate_Skey END) AS EmailreferraltoDWPEstimatedEndDate_Skey
	  , MIN(CASE WHEN WorkFlowEventType = 'Referral Approved'										THEN WorkFlowEstimatedEndDate_Skey END) AS ReferralApprovedEstimatedEndDate_Skey
	  , MIN(CASE WHEN WorkFlowEventType = 'Referral Unsuccessful'									THEN WorkFlowEstimatedEndDate_Skey END) AS ReferralUnsuccessfulEstimatedEndDate_Skey
	  , MIN(CASE WHEN WorkFlowEventType = 'Initial Contact'											THEN WorkFlowEstimatedEndDate_Skey END) AS InitialContactEstimatedEndDate_Skey
	  , MIN(CASE WHEN WorkFlowEventType = 'Awaiting Telephone Assessment Meeting Schedule'			THEN WorkFlowEstimatedEndDate_Skey END) AS AwaitingTelephoneAssessmentMeetingScheduleEstimatedEndDate_Skey
	  , MIN(CASE WHEN WorkFlowEventType = 'Telephone Assessment scheduled'							THEN WorkFlowEstimatedEndDate_Skey END) AS TelephoneAssessmentscheduledEstimatedEndDate_Skey
	  , MIN(CASE WHEN WorkFlowEventType = 'Telephone Assessment Completed'							THEN WorkFlowEstimatedEndDate_Skey END) AS TelephoneAssessmentCompletedEstimatedEndDate_Skey
	  , MIN(CASE WHEN WorkFlowEventType = 'Awaiting Support Plan meeting scheduled'					THEN WorkFlowEstimatedEndDate_Skey END) AS AwaitingSupportPlanmeetingscheduledEstimatedEndDate_Skey
	  , MIN(CASE WHEN WorkFlowEventType = 'Support plan meeting scheduled'							THEN WorkFlowEstimatedEndDate_Skey END) AS SupportplanmeetingscheduledEstimatedEndDate_Skey
	  , MIN(CASE WHEN WorkFlowEventType = 'Support plan meeting completed'							THEN WorkFlowEstimatedEndDate_Skey END) AS SupportplanmeetingcompletedEstimatedEndDate_Skey
	  , MIN(CASE WHEN WorkFlowEventType = 'Support plan signed by customer'							THEN WorkFlowEstimatedEndDate_Skey END) AS SupportplansignedbycustomerEstimatedEndDate_Skey
	  , MIN(CASE WHEN WorkFlowEventType = 'Support plan Uploaded'									THEN WorkFlowEstimatedEndDate_Skey END) AS SupportplanUploadedEstimatedEndDate_Skey
	  , MIN(CASE WHEN WorkFlowEventType = 'Support plan completed but not submitted to DWP'			THEN WorkFlowEstimatedEndDate_Skey END) AS SupportplancompletedbutnotsubmittedtoDWPEstimatedEndDate_Skey
	  , MIN(CASE WHEN WorkFlowEventType = 'Support plan submitted to DWP'							THEN WorkFlowEstimatedEndDate_Skey END) AS SupportplansubmittedtoDWPEstimatedEndDate_Skey
	  , MIN(CASE WHEN WorkFlowEventType = 'Support Plan Not Approved by DWP'						THEN WorkFlowEstimatedEndDate_Skey END) AS SupportPlanNotApprovedbyDWPEstimatedEndDate_Skey
	  , MIN(CASE WHEN WorkFlowEventType = 'Awaiting Support Plan Re-Submission'						THEN WorkFlowEstimatedEndDate_Skey END) AS AwaitingSupportPlanReSubmissionEstimatedEndDate_Skey
	  , MIN(CASE WHEN WorkFlowEventType = 'Support Plan Re-Submitted'								THEN WorkFlowEstimatedEndDate_Skey END) AS SupportPlanReSubmittedEstimatedEndDate_Skey  
	  , MIN(CASE WHEN WorkFlowEventType = 'Support plan approved by DWP'							THEN WorkFlowEstimatedEndDate_Skey END) AS SupportplanapprovedbyDWPEstimatedEndDate_Skey
	  , MIN(CASE WHEN WorkFlowEventType = 'Support plan paid by DWP'								THEN WorkFlowEstimatedEndDate_Skey END) AS SupportplanpaidbyDWPEstimatedEndDate_Skey
	  , MIN(CASE WHEN WorkFlowEventType = 'Month 1 update outstanding'								THEN WorkFlowEstimatedEndDate_Skey END) AS Month1updateoutstandingEstimatedEndDate_Skey
	  , MIN(CASE WHEN WorkFlowEventType = 'Month 1 update completed'								THEN WorkFlowEstimatedEndDate_Skey END) AS Month1updatecompletedEstimatedEndDate_Skey
	  , MIN(CASE WHEN WorkFlowEventType = 'Month 1 BOT Update Completed'							THEN WorkFlowEstimatedEndDate_Skey END) AS Month1BOTUpdateCompletedEstimatedEndDate_Skey
	  , MIN(CASE WHEN WorkFlowEventType = 'Month 1 update submitted to DWP'							THEN WorkFlowEstimatedEndDate_Skey END) AS Month1updatesubmittedtoDWPEstimatedEndDate_Skey
	  , MIN(CASE WHEN WorkFlowEventType = 'Month 2 update outstanding'								THEN WorkFlowEstimatedEndDate_Skey END) AS Month2updateoutstandingEstimatedEndDate_Skey
	  , MIN(CASE WHEN WorkFlowEventType = 'Month 2 update completed'								THEN WorkFlowEstimatedEndDate_Skey END) AS Month2updatecompletedEstimatedEndDate_Skey
	  , MIN(CASE WHEN WorkFlowEventType = 'Month 2 BOT Update Completed'							THEN WorkFlowEstimatedEndDate_Skey END) AS Month2BOTUpdateCompletedEstimatedEndDate_Skey
	  , MIN(CASE WHEN WorkFlowEventType = 'Month 2 update submitted to DWP'							THEN WorkFlowEstimatedEndDate_Skey END) AS Month2updatesubmittedtoDWPEstimatedEndDate_Skey
	  , MIN(CASE WHEN WorkFlowEventType = 'Month 3 update outstanding'								THEN WorkFlowEstimatedEndDate_Skey END) AS Month3updateoutstandingEstimatedEndDate_Skey
	  , MIN(CASE WHEN WorkFlowEventType = 'Month 3 update completed'								THEN WorkFlowEstimatedEndDate_Skey END) AS Month3updatecompletedEstimatedEndDate_Skey
	  , MIN(CASE WHEN WorkFlowEventType = 'Month 3 BOT Update Completed'							THEN WorkFlowEstimatedEndDate_Skey END) AS Month3BOTUpdateCompletedEstimatedEndDate_Skey
	  , MIN(CASE WHEN WorkFlowEventType = 'Month 3 update submitted to DWP'							THEN WorkFlowEstimatedEndDate_Skey END) AS Month3updatesubmittedtoDWPEstimatedEndDate_Skey
	  , MIN(CASE WHEN WorkFlowEventType = 'Month 4 update outstanding'								THEN WorkFlowEstimatedEndDate_Skey END) AS Month4updateoutstandingEstimatedEndDate_Skey
	  , MIN(CASE WHEN WorkFlowEventType = 'Month 4 update completed'								THEN WorkFlowEstimatedEndDate_Skey END) AS Month4updatecompletedEstimatedEndDate_Skey
	  , MIN(CASE WHEN WorkFlowEventType = 'Month 4 BOT Update Completed'							THEN WorkFlowEstimatedEndDate_Skey END) AS Month4BOTUpdateCompletedEstimatedEndDate_Skey
	  , MIN(CASE WHEN WorkFlowEventType = 'Month 4 update submitted to DWP'							THEN WorkFlowEstimatedEndDate_Skey END) AS Month4updatesubmittedtoDWPEstimatedEndDate_Skey
	  , MIN(CASE WHEN WorkFlowEventType = 'Month 5 update outstanding'								THEN WorkFlowEstimatedEndDate_Skey END) AS Month5updateoutstandingEstimatedEndDate_Skey
	  , MIN(CASE WHEN WorkFlowEventType = 'Month 5 update completed'								THEN WorkFlowEstimatedEndDate_Skey END) AS Month5updatecompletedEstimatedEndDate_Skey
	  , MIN(CASE WHEN WorkFlowEventType = 'Month 5 BOT Update Completed'							THEN WorkFlowEstimatedEndDate_Skey END) AS Month5BOTUpdateCompletedEstimatedEndDate_Skey
	  , MIN(CASE WHEN WorkFlowEventType = 'Month 5 update submitted to DWP'							THEN WorkFlowEstimatedEndDate_Skey END) AS Month5updatesubmittedtoDWPEstimatedEndDate_Skey
	  , MIN(CASE WHEN WorkFlowEventType = 'Awaiting 6 Month Support Plan meeting scheduled'			THEN WorkFlowEstimatedEndDate_Skey END) AS Awaiting6MonthSupportPlanmeetingscheduledEstimatedEndDate_Skey
	  , MIN(CASE WHEN WorkFlowEventType = 'Month 6 Support plan meeting scheduled'					THEN WorkFlowEstimatedEndDate_Skey END) AS Month6SupportplanmeetingscheduledEstimatedEndDate_Skey
	  , MIN(CASE WHEN WorkFlowEventType = 'Month 6 Support plan meeting completed'					THEN WorkFlowEstimatedEndDate_Skey END) AS Month6SupportplanmeetingcompletedEstimatedEndDate_Skey
	  , MIN(CASE WHEN WorkFlowEventType = 'Month 6 Support plan signed by customer'					THEN WorkFlowEstimatedEndDate_Skey END) AS Month6SupportplansignedbycustomerEstimatedEndDate_Skey
	  , MIN(CASE WHEN WorkFlowEventType = 'Month 6 Support plan Uploaded'							THEN WorkFlowEstimatedEndDate_Skey END) AS Month6SupportplanUploadedEstimatedEndDate_Skey
	  , MIN(CASE WHEN WorkFlowEventType = 'Month 6 Support plan completed but not submitted to DWP' THEN WorkFlowEstimatedEndDate_Skey END) AS Month6SupportplancompletedbutnotsubmittedtoDWPEstimatedEndDate_Skey
	  , MIN(CASE WHEN WorkFlowEventType = 'Month 6 Support plan submitted to DWP'					THEN WorkFlowEstimatedEndDate_Skey END) AS Month6SupportplansubmittedtoDWPEstimatedEndDate_Skey
	  , MIN(CASE WHEN WorkFlowEventType = 'Month 6 Support Plan Not Approved by DWP'				THEN WorkFlowEstimatedEndDate_Skey END) AS Month6SupportPlanNotApprovedbyDWPEstimatedEndDate_Skey
	  , MIN(CASE WHEN WorkFlowEventType = 'Awaiting Month 6 Support Plan Re-Submission'				THEN WorkFlowEstimatedEndDate_Skey END) AS AwaitingMonth6SupportPlanReSubmissionEstimatedEndDate_Skey
	  , MIN(CASE WHEN WorkFlowEventType = 'Month 6 Support Plan Re-Submitted'						THEN WorkFlowEstimatedEndDate_Skey END) AS Month6SupportPlanReSubmittedEstimatedEndDate_Skey
	  , MIN(CASE WHEN WorkFlowEventType = 'Month 6 Support plan approved by DWP'					THEN WorkFlowEstimatedEndDate_Skey END) AS Month6SupportplanapprovedbyDWPEstimatedEndDate_Skey
	  , MIN(CASE WHEN WorkFlowEventType = 'Month 6 Support plan paid by DWP'						THEN WorkFlowEstimatedEndDate_Skey END) AS Month6SupportplanpaidbyDWPEstimatedEndDate_Skey
	  , MIN(CASE WHEN WorkFlowEventType = 'Awaiting Transfer To BSC'								THEN WorkFlowEstimatedEndDate_Skey END) AS AwaitingTransferToBSCEstimatedEndDate_Skey
	  , MIN(CASE WHEN WorkFlowEventType = 'Transferred To BSC'										THEN WorkFlowEstimatedEndDate_Skey END) AS TransferredToBSCEstimatedEndDate_Skey
	  , MIN(CASE WHEN WorkFlowEventType = 'Light Touch Email Sent - Unsuccessful'					THEN WorkFlowEstimatedEndDate_Skey END) AS LightTouchEmailSentUnsuccessfulEstimatedEndDate_Skey
	  , MIN(CASE WHEN WorkFlowEventType = 'Light Touch Email Sent - Successful'						THEN WorkFlowEstimatedEndDate_Skey END) AS LightTouchEmailSentSuccessfulEstimatedEndDate_Skey
	  , MIN(CASE WHEN WorkFlowEventType = 'Awaiting Month 7 Contact'								THEN WorkFlowEstimatedEndDate_Skey END) AS AwaitingMonth7ContactEstimatedEndDate_Skey
	  , MIN(CASE WHEN WorkFlowEventType = 'Month 7 Contact Successful'								THEN WorkFlowEstimatedEndDate_Skey END) AS Month7ContactSuccessfulEstimatedEndDate_Skey
	  , MIN(CASE WHEN WorkFlowEventType = 'Month 7 Contact Unsuccessful'							THEN WorkFlowEstimatedEndDate_Skey END) AS Month7ContactUnsuccessfulEstimatedEndDate_Skey
	  , MIN(CASE WHEN WorkFlowEventType = 'Awaiting Month 8 Contact'								THEN WorkFlowEstimatedEndDate_Skey END) AS AwaitingMonth8ContactEstimatedEndDate_Skey
	  , MIN(CASE WHEN WorkFlowEventType = 'Month 8 Contact Successful'								THEN WorkFlowEstimatedEndDate_Skey END) AS Month8ContactSuccessfulEstimatedEndDate_Skey
	  , MIN(CASE WHEN WorkFlowEventType = 'Month 8 Contact Unsuccessful'							THEN WorkFlowEstimatedEndDate_Skey END) AS Month8ContactUnsuccessfulEstimatedEndDate_Skey
	  , MIN(CASE WHEN WorkFlowEventType = 'Awaiting 9 Month Report meeting scheduled'				THEN WorkFlowEstimatedEndDate_Skey END) AS Awaiting9MonthReportmeetingscheduledEstimatedEndDate_Skey
	  , MIN(CASE WHEN WorkFlowEventType = '9 Month Report meeting scheduled'						THEN WorkFlowEstimatedEndDate_Skey END) AS NineMonthReportmeetingscheduledEstimatedEndDate_Skey
	  , MIN(CASE WHEN WorkFlowEventType = '9 Month Report meeting completed'						THEN WorkFlowEstimatedEndDate_Skey END) AS NineMonthReportmeetingcompletedEstimatedEndDate_Skey
	  , MIN(CASE WHEN WorkFlowEventType = '9 Month Report signed by customer'						THEN WorkFlowEstimatedEndDate_Skey END) AS NineMonthReportsignedbycustomerEstimatedEndDate_Skey
	  , MIN(CASE WHEN WorkFlowEventType = '9 Month Report Uploaded'									THEN WorkFlowEstimatedEndDate_Skey END) AS NineMonthReportUploadedEstimatedEndDate_Skey
	  , MIN(CASE WHEN WorkFlowEventType = '9 Month Report completed but not submitted to DWP'		THEN WorkFlowEstimatedEndDate_Skey END) AS NineMonthReportcompletedbutnotsubmittedtoDWPEstimatedEndDate_Skey
	  , MIN(CASE WHEN WorkFlowEventType = '9 Month Report submitted to DWP'							THEN WorkFlowEstimatedEndDate_Skey END) AS NineMonthReportsubmittedtoDWPEstimatedEndDate_Skey
	  , MIN(CASE WHEN WorkFlowEventType = '9 Month Report Not Approved by DWP'						THEN WorkFlowEstimatedEndDate_Skey END) AS NineMonthReportNotApprovedbyDWPEstimatedEndDate_Skey
	  , MIN(CASE WHEN WorkFlowEventType = 'Awaiting 9 Month Report Re-Submission'					THEN WorkFlowEstimatedEndDate_Skey END) AS Awaiting9MonthReportReSubmissionEstimatedEndDate_Skey
	  , MIN(CASE WHEN WorkFlowEventType = '9 Month Report Re-Submitted'								THEN WorkFlowEstimatedEndDate_Skey END) AS NineMonthReportReSubmittedEstimatedEndDate_Skey
	  , MIN(CASE WHEN WorkFlowEventType = '9 Month Report approved by DWP'							THEN WorkFlowEstimatedEndDate_Skey END) AS NineMonthReportapprovedbyDWPEstimatedEndDate_Skey
	  , MIN(CASE WHEN WorkFlowEventType = '9 Month Report paid by DWP'								THEN WorkFlowEstimatedEndDate_Skey END) AS NineMonthReportpaidbyDWPEstimatedEndDate_Skey
	  , MIN(CASE WHEN WorkFlowEventType = 'Rejected'												THEN WorkFlowEstimatedEndDate_Skey END) AS RejectedEstimatedEndDate_Skey

	  , MIN(CASE WHEN (WorkFlowEventType = 'Light Touch Email Sent - Unsuccessful' AND WorkFlowEstimatedEndDate_Skey <> -1) OR (WorkFlowEventType = 'Light Touch Email Sent - Successful' AND WorkFlowEstimatedEndDate_Skey <> -1)					THEN WorkFlowEstimatedEndDate_Skey END) AS MarketingCampaignAttemptedEstimatedEndDate_Skey
	  , MIN(CASE WHEN (WorkFlowEventType = 'Month 7 Contact Unsuccessful' AND WorkFlowEstimatedEndDate_Skey <> -1) OR (WorkFlowEventType = 'Month 7 Contact Successful'	    AND WorkFlowEstimatedEndDate_Skey <> -1)								THEN WorkFlowEstimatedEndDate_Skey END) AS Month7ContactAttemptedEstimatedEndDate_Skey
	  , MIN(CASE WHEN (WorkFlowEventType = 'Month 8 Contact Unsuccessful' AND WorkFlowEstimatedEndDate_Skey <> -1) OR (WorkFlowEventType = 'Month 8 Contact Successful'	    AND WorkFlowEstimatedEndDate_Skey <> -1)								THEN WorkFlowEstimatedEndDate_Skey END) AS Month8ContactAttemptedEstimatedEndDate_Skey
	  , MIN(CASE WHEN (WorkFlowEventType = 'Month 1 update completed'     AND WorkFlowEstimatedEndDate_Skey <> -1) OR (WorkFlowEventType = 'Month 1 BOT Update Completed'   AND WorkFlowEstimatedEndDate_Skey <> -1)								THEN WorkFlowEstimatedEndDate_Skey END) AS Month1UpdateSuccessfulEstimatedEndDate_Skey
	  , MIN(CASE WHEN (WorkFlowEventType = 'Month 2 update completed'     AND WorkFlowEstimatedEndDate_Skey <> -1) OR (WorkFlowEventType = 'Month 2 BOT Update Completed'   AND WorkFlowEstimatedEndDate_Skey <> -1)								THEN WorkFlowEstimatedEndDate_Skey END) AS Month2UpdateSuccessfulEstimatedEndDate_Skey
	  , MIN(CASE WHEN (WorkFlowEventType = 'Month 3 update completed'     AND WorkFlowEstimatedEndDate_Skey <> -1) OR (WorkFlowEventType = 'Month 3 BOT Update Completed'   AND WorkFlowEstimatedEndDate_Skey <> -1)								THEN WorkFlowEstimatedEndDate_Skey END) AS Month3UpdateSuccessfulEstimatedEndDate_Skey
	  , MIN(CASE WHEN (WorkFlowEventType = 'Month 4 update completed'     AND WorkFlowEstimatedEndDate_Skey <> -1) OR (WorkFlowEventType = 'Month 4 BOT Update Completed'   AND WorkFlowEstimatedEndDate_Skey <> -1)								THEN WorkFlowEstimatedEndDate_Skey END) AS Month4UpdateSuccessfulEstimatedEndDate_Skey
	  , MIN(CASE WHEN (WorkFlowEventType = 'Month 5 update completed'     AND WorkFlowEstimatedEndDate_Skey <> -1) OR (WorkFlowEventType = 'Month 5 BOT Update Completed'   AND WorkFlowEstimatedEndDate_Skey <> -1)								THEN WorkFlowEstimatedEndDate_Skey END) AS Month5UpdateSuccessfulEstimatedEndDate_Skey

	  , MIN(CASE WHEN WorkFlowEventType = 'Support plan Uploaded'									THEN WorkFlowEventEmployee_Skey END) AS SupportplanUploadedEmployee_Skey
	  , MIN(CASE WHEN WorkFlowEventType = 'Month 6 Support plan Uploaded'							THEN WorkFlowEventEmployee_Skey END) AS Month6SupportPlanUploadedEmployee_Skey
	  , MIN(CASE WHEN WorkFlowEventType = '9 Month Report Uploaded'									THEN WorkFlowEventEmployee_Skey END) AS NineMonthReportUploadedEmployee_Skey

  FROM [DW].[F_AtW_Work_Flow_Event_Analysis] f_atw_wfea
		INNER JOIN dw.d_Work_Flow_Event_Type d_wfet
			ON f_atw_wfea.[WorkFlowEventType_Skey] = d_wfet.[Work_Flow_Event_Type_Skey]

  GROUP BY
      [Case_Analysis_Skey]
)

SELECT 
	    lnk_s.[WorkFlowEnquiryStartDate_Skey]
      , lnk_s.[WorkFlowEnquiryStartTime_Skey]
      , lnk_s.[WorkFlowEnquiryEndDate_Skey]
      , lnk_s.[WorkFlowEnquiryEndTime_Skey]
      , lnk_s.[WorkFlowReferralStartDate_Skey]
      , lnk_s.[WorkFlowReferralStartTime_Skey]
      , lnk_s.[WorkFlowReferralEndDate_Skey]
      , lnk_s.[WorkFlowReferralEndTime_Skey]
      , lnk_s.[WorkFlowTelephoneAssessmentStartDate_Skey]
      , lnk_s.[WorkFlowTelephoneAssessmentStartTime_Skey]
      , lnk_s.[WorkFlowTelephoneAssessmentEndDate_Skey]
      , lnk_s.[WorkFlowTelephoneAssessmentEndTime_Skey]
      , lnk_s.[WorkFlowInitialSupportPlanStartDate_Skey]
      , lnk_s.[WorkFlowInitialSupportPlanStartTime_Skey]
      , lnk_s.[WorkFlowInitialSupportPlanEndDate_Skey]
      , lnk_s.[WorkFlowInitialSupportPlanEndTime_Skey]
      , lnk_s.[WorkFlowMonth1StartDate_Skey]
      , lnk_s.[WorkFlowMonth1StartTime_Skey]
      , lnk_s.[WorkFlowMonth1EndDate_Skey]
      , lnk_s.[WorkFlowMonth1EndTime_Skey]
      , lnk_s.[WorkFlowMonth2StartDate_Skey]
      , lnk_s.[WorkFlowMonth2StartTime_Skey]
      , lnk_s.[WorkFlowMonth2EndDate_Skey]
      , lnk_s.[WorkFlowMonth2EndTime_Skey]
      , lnk_s.[WorkFlowMonth3StartDate_Skey]
      , lnk_s.[WorkFlowMonth3StartTime_Skey]
      , lnk_s.[WorkFlowMonth3EndDate_Skey]
      , lnk_s.[WorkFlowMonth3EndTime_Skey]
      , lnk_s.[WorkFlowMonth4StartDate_Skey]
      , lnk_s.[WorkFlowMonth4StartTime_Skey]
      , lnk_s.[WorkFlowMonth4EndDate_Skey]
      , lnk_s.[WorkFlowMonth4EndTime_Skey]
      , lnk_s.[WorkFlowMonth5StartDate_Skey]
      , lnk_s.[WorkFlowMonth5StartTime_Skey]
      , lnk_s.[WorkFlowMonth5EndDate_Skey]
      , lnk_s.[WorkFlowMonth5EndTime_Skey]
      , lnk_s.[WorkFlow6MonthReportStartDate_Skey]
      , lnk_s.[WorkFlow6MonthReportStartTime_Skey]
      , lnk_s.[WorkFlow6MonthReportEndDate_Skey]
      , lnk_s.[WorkFlow6MonthReportEndTime_Skey]
      , lnk_s.[WorkFlowMonth7StartDate_Skey]
      , lnk_s.[WorkFlowMonth7StartTime_Skey]
      , lnk_s.[WorkFlowMonth7EndDate_Skey]
      , lnk_s.[WorkFlowMonth7EndTime_Skey]
      , lnk_s.[WorkFlowMonth8StartDate_Skey]
      , lnk_s.[WorkFlowMonth8StartTime_Skey]
      , lnk_s.[WorkFlowMonth8EndDate_Skey]
      , lnk_s.[WorkFlowMonth8EndTime_Skey]
      , lnk_s.[WorkFlow9MonthReportStartDate_Skey]
      , lnk_s.[WorkFlow9MonthReportStartTime_Skey]
      , lnk_s.[WorkFlow9MonthReportEndDate_Skey]
      , lnk_s.[WorkFlow9MonthReportEndTime_Skey]
      , lnk_s.[WorkFlowAfterMonth9StartDate_Skey]
      , lnk_s.[WorkFlowAfterMonth9StartTime_Skey]
      , lnk_s.[WorkFlowAfterMonth9EndDate_Skey]
      , lnk_s.[WorkFlowAfterMonth9EndTime_Skey]
	    
      , f_ca.[Candidate_Skey]
      , f_ca.[Case_Skey]
      , f_ca.[Source_Skey]
      , f_ca.[Case_Status_Skey]
      , f_ca.[Programme_Skey]
      , f_ca.[CaseCreatedDate_Skey]
      , f_ca.[CaseCreatedTime_Skey]
      , f_ca.[CaseReceivedDate_Skey]
      , f_ca.[CaseReceivedTime_Skey]
      , f_ca.[PredictedEndDate_Skey]
      , f_ca.[PredictedEndTime_Skey]
      , f_ca.[ApprovedDate_Skey]
      , f_ca.[ApprovedTime_Skey]
      , f_ca.[CaseClosedDate_Skey]
      , f_ca.[CaseClosedTime_Skey]
      , f_ca.[CasePlanActiveDate_Skey]
      , f_ca.[CasePlanActiveTime_Skey]
	  , f_ca.[Employer_Contact_Skey]
	  , f_ca.[Employer_Skey]
      , f_ca.[Attrition_Reason_Skey]
      , f_ca.[CaseOwnerEmp_Skey]
      , f_ca.[CaseOwnerEmpHist_Skey]
	  , f_ca.[CaseCount]
      , f_ca.[CurrentStage_Skey]
      , f_ca.[AttritionStage_Skey]
      , f_ca.[AttritionDate_Skey]
      , f_ca.[AttritionTime_Skey]
	  , f_ca.[AttritionCount]
	  , f_ca.[AttritionHistoryCount]
	  , f_ca.[AttritionDisengagedCount]
	  , f_ca.[AttritionDisengagedHistoryCount]
	  , f_ca.[AttritionLeftJobCount]
	  , f_ca.[AttritionLeftJobHistoryCount]
	  , f_ca.[AttritionCovidCount]
	  , f_ca.[AttritionCovidHistoryCount]
	  , f_ca.[SuspendedCount]
	  , f_ca.[ActiveCount]

      , AtW_e.[NewEnquiry]
	  , AtW_e.[ReferralCallRequired]
	  , AtW_e.[ReferralCallBackAttempt1]
	  , AtW_e.[ReferralCallBackAttempt2]
	  , AtW_e.[ReferralCallBackAttempt3]
	  , AtW_e.[LiveEnquiry]
      , AtW_e.[UnsuccessfulEnquiry]
      , AtW_e.[SuccessfulEnquiry]
      , AtW_e.[AwaitingReferral]
      , AtW_e.[ReferralReceived]
      , AtW_e.[InitialContact]
      , AtW_e.[ReferralApproved]
      , AtW_e.[ReferralUnsuccessful]
      , AtW_e.[AwaitingTelephoneAssessmentMeetingSchedule]
      , AtW_e.[TelephoneAssessmentScheduled]
      , AtW_e.[TelephoneAssessmentCompleted]
      , AtW_e.[AwaitingSupportPlanMeetingScheduled]
      , AtW_e.[SupportPlanMeetingScheduled]
      , AtW_e.[SupportPlanMeetingCompleted]
      , AtW_e.[SupportPlanSignedByCustomer]
      , AtW_e.[SupportPlanUploaded]
      , AtW_e.[SupportPlanCompletedButNotSubmittedToDwp]
      , AtW_e.[SupportPlanSubmittedToDwp]      
	  , AtW_e.[SupportPlanNotApprovedByDwp]
	  , AtW_e.[AwaitingSupportPlanReSubmission]
	  , AtW_e.[SupportPlanReSubmitted]
	  , AtW_e.[SupportPlanApprovedByDwp]
      , AtW_e.[SupportPlanPaidByDwp]
      , AtW_e.[Month1UpdateOutstanding]
      , AtW_e.[Month1UpdateCompleted]
	  , AtW_e.[Month1BOTUpdateCompleted]
      , AtW_e.[Month1UpdateSubmittedToDwp]
      , AtW_e.[Month2UpdateOutstanding]
      , AtW_e.[Month2UpdateCompleted]
      , AtW_e.[Month2BOTUpdateCompleted]
	  , AtW_e.[Month2UpdateSubmittedToDwp]
      , AtW_e.[Month3UpdateOutstanding]
      , AtW_e.[Month3UpdateCompleted]
	  , AtW_e.[Month3BOTUpdateCompleted]
      , AtW_e.[Month3UpdateSubmittedToDwp]
      , AtW_e.[Month4UpdateOutstanding]
      , AtW_e.[Month4UpdateCompleted]
	  , AtW_e.[Month4BOTUpdateCompleted]
      , AtW_e.[Month4UpdateSubmittedToDwp]
      , AtW_e.[Month5UpdateOutstanding]
      , AtW_e.[Month5UpdateCompleted]
	  , AtW_e.[Month5BOTUpdateCompleted]
      , AtW_e.[Month5UpdateSubmittedToDwp]
      , AtW_e.[Awaiting6MonthSupportPlanMeetingScheduled]
      , AtW_e.[Month6SupportPlanMeetingScheduled]
      , AtW_e.[Month6SupportPlanMeetingCompleted]
      , AtW_e.[Month6SupportPlanSignedByCustomer]
      , AtW_e.[Month6SupportPlanUploaded]
      , AtW_e.[Month6SupportPlanCompletedButNotSubmittedToDwp]
      , AtW_e.[Month6SupportPlanSubmittedToDwp]
	  , AtW_e.[Month6SupportPlanNotApprovedByDwp]
	  , AtW_e.[AwaitingMonth6SupportPlanReSubmission]
	  , AtW_e.[Month6SupportPlanReSubmitted]
      , AtW_e.[Month6SupportPlanApprovedByDwp]
      , AtW_e.[Month6SupportPlanPaidByDwp]
      , AtW_e.[AwaitingTransferToBsc]
      , AtW_e.[TransferredToBsc]
      , AtW_e.[LightTouchEmailSentUnsuccessful]
      , AtW_e.[LightTouchEmailSentSuccessful]
      , AtW_e.[AwaitingMonth7Contact]
      , AtW_e.[Month7ContactSuccessful]
      , AtW_e.[Month7ContactUnsuccessful]
      , AtW_e.[AwaitingMonth8Contact]
      , AtW_e.[Month8ContactSuccessful]
      , AtW_e.[Month8ContactUnsuccessful]
      , AtW_e.[Awaiting9MonthReportMeetingScheduled]
      , AtW_e.[NineMonthReportMeetingScheduled]
      , AtW_e.[NineMonthReportMeetingCompleted]
      , AtW_e.[NineMonthReportSignedByCustomer]
      , AtW_e.[NineMonthReportUploaded]
      , AtW_e.[NineMonthReportCompletedButNotSubmittedToDwp]
      , AtW_e.[NineMonthReportSubmittedToDwp]      
	  , AtW_e.[NineMonthReportNotApprovedByDWP]
	  , AtW_e.[Awaiting9MonthReportReSubmission]
	  , AtW_e.[NineMonthReportReSubmitted]
	  , AtW_e.[NineMonthReportApprovedByDwp]
      , AtW_e.[NineMonthReportPaidByDwp]
	  , AtW_e.[Rejected]
	  , COALESCE(AtW_e.[MarketingCampaignAttempted],-1) AS [MarketingCampaignAttempted]
	  , COALESCE(AtW_e.[Month7ContactAttempted]	   ,-1) AS [Month7ContactAttempted]	   
	  , COALESCE(AtW_e.[Month8ContactAttempted]	   ,-1) AS [Month8ContactAttempted]	   
	  , COALESCE(AtW_e.[Month1UpdateSuccessful]	   ,-1) AS [Month1UpdateSuccessful]	   
	  , COALESCE(AtW_e.[Month2UpdateSuccessful]	   ,-1) AS [Month2UpdateSuccessful]	   
	  , COALESCE(AtW_e.[Month3UpdateSuccessful]	   ,-1) AS [Month3UpdateSuccessful]	   
	  , COALESCE(AtW_e.[Month4UpdateSuccessful]	   ,-1) AS [Month4UpdateSuccessful]	   
	  , COALESCE(AtW_e.[Month5UpdateSuccessful]	   ,-1) AS [Month5UpdateSuccessful]	   

      , AtW_e.[NewEnquiryDate_Skey]
	  , AtW_e.[ReferralCallRequiredDate_Skey]
	  , AtW_e.[ReferralCallBackAttempt1Date_Skey]
	  , AtW_e.[ReferralCallBackAttempt2Date_Skey]
	  , AtW_e.[ReferralCallBackAttempt3Date_Skey]
      , AtW_e.[LiveEnquiryDate_Skey]
      , AtW_e.[UnsuccessfulEnquiryDate_Skey]
      , AtW_e.[SuccessfulEnquiryDate_Skey]
      , AtW_e.[AwaitingReferralDate_Skey]
      , AtW_e.[ReferralReceivedDate_Skey]
      , AtW_e.[InitialContactDate_Skey]
      , AtW_e.[ReferralApprovedDate_Skey]
      , AtW_e.[ReferralUnsuccessfulDate_Skey]
      , AtW_e.[AwaitingTelephoneAssessmentMeetingScheduleDate_Skey]
      , AtW_e.[TelephoneAssessmentScheduledDate_Skey]
      , AtW_e.[TelephoneAssessmentCompletedDate_Skey]
      , AtW_e.[AwaitingSupportPlanMeetingScheduledDate_Skey]
      , AtW_e.[SupportPlanMeetingScheduledDate_Skey]
      , AtW_e.[SupportPlanMeetingCompletedDate_Skey]
      , AtW_e.[SupportPlanSignedByCustomerDate_Skey]
      , AtW_e.[SupportPlanUploadedDate_Skey]
      , AtW_e.[SupportPlanCompletedButNotSubmittedToDwpDate_Skey]
      , AtW_e.[SupportPlanSubmittedToDwpDate_Skey]
	  , AtW_e.[SupportPlanNotApprovedbyDWPDate_Skey]
	  , AtW_e.[AwaitingSupportPlanReSubmissionDate_Skey]
	  , AtW_e.[SupportPlanReSubmittedDate_Skey]
      , AtW_e.[SupportPlanApprovedByDwpDate_Skey]
      , AtW_e.[SupportPlanPaidByDwpDate_Skey]
      , AtW_e.[Month1UpdateOutstandingDate_Skey]
      , AtW_e.[Month1UpdateCompletedDate_Skey]
	  , AtW_e.[Month1BOTUpdateCompletedDate_Skey]
      , AtW_e.[Month1UpdateSubmittedToDwpDate_Skey]
      , AtW_e.[Month2UpdateOutstandingDate_Skey]
      , AtW_e.[Month2UpdateCompletedDate_Skey]
      , AtW_e.[Month2BOTUpdateCompletedDate_Skey]
	  , AtW_e.[Month2UpdateSubmittedToDwpDate_Skey]
      , AtW_e.[Month3UpdateOutstandingDate_Skey]
      , AtW_e.[Month3UpdateCompletedDate_Skey]
      , AtW_e.[Month3BOTUpdateCompletedDate_Skey]
	  , AtW_e.[Month3UpdateSubmittedToDwpDate_Skey]
      , AtW_e.[Month4UpdateOutstandingDate_Skey]
      , AtW_e.[Month4UpdateCompletedDate_Skey]
	  , AtW_e.[Month4BOTUpdateCompletedDate_Skey]
      , AtW_e.[Month4UpdateSubmittedToDwpDate_Skey]
      , AtW_e.[Month5UpdateOutstandingDate_Skey]
      , AtW_e.[Month5UpdateCompletedDate_Skey]
	  , AtW_e.[Month5BOTUpdateCompletedDate_Skey]
      , AtW_e.[Month5UpdateSubmittedToDwpDate_Skey]
      , AtW_e.[Awaiting6MonthSupportPlanMeetingScheduledDate_Skey]
      , AtW_e.[Month6SupportPlanMeetingScheduledDate_Skey]
      , AtW_e.[Month6SupportPlanMeetingCompletedDate_Skey]
      , AtW_e.[Month6SupportPlanSignedByCustomerDate_Skey]
      , AtW_e.[Month6SupportPlanUploadedDate_Skey]
      , AtW_e.[Month6SupportPlanCompletedButNotSubmittedToDwpDate_Skey]
      , AtW_e.[Month6SupportPlanSubmittedToDwpDate_Skey]
	  , AtW_e.[Month6SupportPlanNotApprovedByDwpDate_Skey]
	  , AtW_e.[AwaitingMonth6SupportPlanReSubmissionDate_Skey]
	  , AtW_e.[Month6SupportPlanReSubmittedDate_Skey]
      , AtW_e.[Month6SupportPlanApprovedByDwpDate_Skey]
      , AtW_e.[Month6SupportPlanPaidByDwpDate_Skey]
      , AtW_e.[AwaitingTransferToBscDate_Skey]
      , AtW_e.[TransferredToBscDate_Skey]
      , AtW_e.[LightTouchEmailSentUnsuccessfulDate_Skey]
      , AtW_e.[LightTouchEmailSentSuccessfulDate_Skey]
      , AtW_e.[AwaitingMonth7ContactDate_Skey]
      , AtW_e.[Month7ContactSuccessfulDate_Skey]
      , AtW_e.[Month7ContactUnsuccessfulDate_Skey]
      , AtW_e.[AwaitingMonth8ContactDate_Skey]
      , AtW_e.[Month8ContactSuccessfulDate_Skey]
      , AtW_e.[Month8ContactUnsuccessfulDate_Skey]
      , AtW_e.[Awaiting9MonthReportMeetingScheduledDate_Skey]
      , AtW_e.[NineMonthReportMeetingScheduledDate_Skey]
      , AtW_e.[NineMonthReportMeetingCompletedDate_Skey]
      , AtW_e.[NineMonthReportSignedByCustomerDate_Skey]
      , AtW_e.[NineMonthReportUploadedDate_Skey]
      , AtW_e.[NineMonthReportCompletedButNotSubmittedToDwpDate_Skey]
      , AtW_e.[NineMonthReportSubmittedToDwpDate_Skey]
	  , AtW_e.[NineMonthReportNotApprovedByDWPDate_Skey]
	  , AtW_e.[Awaiting9MonthReportReSubmissionDate_Skey]
	  , AtW_e.[NineMonthReportReSubmittedDate_Skey]
      , AtW_e.[NineMonthReportApprovedByDwpDate_Skey]
      , AtW_e.[NineMonthReportPaidByDwpDate_Skey]
	  , AtW_e.[RejectedDate_Skey]
	  , COALESCE(AtW_e.[MarketingCampaignAttemptedDate_Skey],-1) AS [MarketingCampaignAttemptedDate_Skey]
	  , COALESCE(AtW_e.[Month7ContactAttemptedDate_Skey]	,-1) AS [Month7ContactAttemptedDate_Skey]
	  , COALESCE(AtW_e.[Month8ContactAttemptedDate_Skey]	,-1) AS [Month8ContactAttemptedDate_Skey]
	  , COALESCE(AtW_e.[Month1UpdateSuccessfulDate_Skey]	,-1) AS [Month1UpdateSuccessfulDate_Skey]
	  , COALESCE(AtW_e.[Month2UpdateSuccessfulDate_Skey]	,-1) AS [Month2UpdateSuccessfulDate_Skey]
	  , COALESCE(AtW_e.[Month3UpdateSuccessfulDate_Skey]	,-1) AS [Month3UpdateSuccessfulDate_Skey]
	  , COALESCE(AtW_e.[Month4UpdateSuccessfulDate_Skey]	,-1) AS [Month4UpdateSuccessfulDate_Skey]
	  , COALESCE(AtW_e.[Month5UpdateSuccessfulDate_Skey]	,-1) AS [Month5UpdateSuccessfulDate_Skey]

      , AtW_e.[NewEnquiryEstimatedStartDate_Skey]
	  , AtW_e.[ReferralCallRequiredEstimatedStartDate_Skey]
	  , AtW_e.[ReferralCallBackAttempt1EstimatedStartDate_Skey]
	  , AtW_e.[ReferralCallBackAttempt2EstimatedStartDate_Skey]
	  , AtW_e.[ReferralCallBackAttempt3EstimatedStartDate_Skey]
	  , AtW_e.[LiveEnquiryEstimatedStartDate_Skey]
      , AtW_e.[UnsuccessfulEnquiryEstimatedStartDate_Skey]
      , AtW_e.[SuccessfulEnquiryEstimatedStartDate_Skey]
      , AtW_e.[AwaitingReferralEstimatedStartDate_Skey]
      , AtW_e.[ReferralReceivedEstimatedStartDate_Skey]
      , AtW_e.[InitialContactEstimatedStartDate_Skey]
      , AtW_e.[ReferralApprovedEstimatedStartDate_Skey]
      , AtW_e.[ReferralUnsuccessfulEstimatedStartDate_Skey]
      , AtW_e.[AwaitingTelephoneAssessmentMeetingScheduleEstimatedStartDate_Skey]
      , AtW_e.[TelephoneAssessmentScheduledEstimatedStartDate_Skey]
      , AtW_e.[TelephoneAssessmentCompletedEstimatedStartDate_Skey]
      , AtW_e.[AwaitingSupportPlanMeetingScheduledEstimatedStartDate_Skey]
      , AtW_e.[SupportPlanMeetingScheduledEstimatedStartDate_Skey]
      , AtW_e.[SupportPlanMeetingCompletedEstimatedStartDate_Skey]
      , AtW_e.[SupportPlanSignedByCustomerEstimatedStartDate_Skey]
      , AtW_e.[SupportPlanUploadedEstimatedStartDate_Skey]
      , AtW_e.[SupportPlanCompletedButNotSubmittedToDwpEstimatedStartDate_Skey]
      , AtW_e.[SupportPlanSubmittedToDwpEstimatedStartDate_Skey]
	  , AtW_e.[SupportPlanNotApprovedbyDWPEstimatedStartDate_Skey]
	  , AtW_e.[AwaitingSupportPlanReSubmissionEstimatedStartDate_Skey]
	  , AtW_e.[SupportPlanReSubmittedEstimatedStartDate_Skey]
      , AtW_e.[SupportPlanApprovedByDwpEstimatedStartDate_Skey]
      , AtW_e.[SupportPlanPaidByDwpEstimatedStartDate_Skey]
      , AtW_e.[Month1UpdateOutstandingEstimatedStartDate_Skey]
      , AtW_e.[Month1UpdateCompletedEstimatedStartDate_Skey]
	  , AtW_e.[Month1BOTUpdateCompletedEstimatedStartDate_Skey]
      , AtW_e.[Month1UpdateSubmittedToDwpEstimatedStartDate_Skey]
      , AtW_e.[Month2UpdateOutstandingEstimatedStartDate_Skey]
      , AtW_e.[Month2UpdateCompletedEstimatedStartDate_Skey]
      , AtW_e.[Month2BOTUpdateCompletedEstimatedStartDate_Skey]
	  , AtW_e.[Month2UpdateSubmittedToDwpEstimatedStartDate_Skey]
      , AtW_e.[Month3UpdateOutstandingEstimatedStartDate_Skey]
      , AtW_e.[Month3UpdateCompletedEstimatedStartDate_Skey]
      , AtW_e.[Month3BOTUpdateCompletedEstimatedStartDate_Skey]
	  , AtW_e.[Month3UpdateSubmittedToDwpEstimatedStartDate_Skey]
      , AtW_e.[Month4UpdateOutstandingEstimatedStartDate_Skey]
      , AtW_e.[Month4UpdateCompletedEstimatedStartDate_Skey]
      , AtW_e.[Month4BOTUpdateCompletedEstimatedStartDate_Skey]
	  , AtW_e.[Month4UpdateSubmittedToDwpEstimatedStartDate_Skey]
      , AtW_e.[Month5UpdateOutstandingEstimatedStartDate_Skey]
      , AtW_e.[Month5UpdateCompletedEstimatedStartDate_Skey]
      , AtW_e.[Month5BOTUpdateCompletedEstimatedStartDate_Skey]
	  , AtW_e.[Month5UpdateSubmittedToDwpEstimatedStartDate_Skey]
      , AtW_e.[Awaiting6MonthSupportPlanMeetingScheduledEstimatedStartDate_Skey]
      , AtW_e.[Month6SupportPlanMeetingScheduledEstimatedStartDate_Skey]
      , AtW_e.[Month6SupportPlanMeetingCompletedEstimatedStartDate_Skey]
      , AtW_e.[Month6SupportPlanSignedByCustomerEstimatedStartDate_Skey]
      , AtW_e.[Month6SupportPlanUploadedEstimatedStartDate_Skey]
      , AtW_e.[Month6SupportPlanCompletedButNotSubmittedToDwpEstimatedStartDate_Skey]
      , AtW_e.[Month6SupportPlanSubmittedToDwpEstimatedStartDate_Skey]
	  , AtW_e.[Month6SupportPlanNotApprovedByDwpEstimatedStartDate_Skey]
	  , AtW_e.[AwaitingMonth6SupportPlanReSubmissionEstimatedStartDate_Skey]
	  , AtW_e.[Month6SupportPlanReSubmittedEstimatedStartDate_Skey]
      , AtW_e.[Month6SupportPlanApprovedByDwpEstimatedStartDate_Skey]
      , AtW_e.[Month6SupportPlanPaidByDwpEstimatedStartDate_Skey]
      , AtW_e.[AwaitingTransferToBscEstimatedStartDate_Skey]
      , AtW_e.[TransferredToBscEstimatedStartDate_Skey]
      , AtW_e.[LightTouchEmailSentUnsuccessfulEstimatedStartDate_Skey]
      , AtW_e.[LightTouchEmailSentSuccessfulEstimatedStartDate_Skey]
      , AtW_e.[AwaitingMonth7ContactEstimatedStartDate_Skey]
      , AtW_e.[Month7ContactSuccessfulEstimatedStartDate_Skey]
      , AtW_e.[Month7ContactUnsuccessfulEstimatedStartDate_Skey]
      , AtW_e.[AwaitingMonth8ContactEstimatedStartDate_Skey]
      , AtW_e.[Month8ContactSuccessfulEstimatedStartDate_Skey]
      , AtW_e.[Month8ContactUnsuccessfulEstimatedStartDate_Skey]
      , AtW_e.[Awaiting9MonthReportMeetingScheduledEstimatedStartDate_Skey]
      , AtW_e.[NineMonthReportMeetingScheduledEstimatedStartDate_Skey]
      , AtW_e.[NineMonthReportMeetingCompletedEstimatedStartDate_Skey]
      , AtW_e.[NineMonthReportSignedByCustomerEstimatedStartDate_Skey]
      , AtW_e.[NineMonthReportUploadedEstimatedStartDate_Skey]
      , AtW_e.[NineMonthReportCompletedButNotSubmittedToDwpEstimatedStartDate_Skey]
      , AtW_e.[NineMonthReportSubmittedToDwpEstimatedStartDate_Skey]
	  , AtW_e.[NineMonthReportNotApprovedByDWPEstimatedStartDate_Skey]
	  , AtW_e.[Awaiting9MonthReportReSubmissionEstimatedStartDate_Skey]
	  , AtW_e.[NineMonthReportReSubmittedEstimatedStartDate_Skey]
      , AtW_e.[NineMonthReportApprovedByDwpEstimatedStartDate_Skey]
      , AtW_e.[NineMonthReportPaidByDwpEstimatedStartDate_Skey]
	  , AtW_e.[RejectedEstimatedStartDate_Skey]
	  , COALESCE(AtW_e.[MarketingCampaignAttemptedEstimatedStartDate_Skey],-1) AS [MarketingCampaignAttemptedEstimatedStartDate_Skey]
	  , COALESCE(AtW_e.[Month7ContactAttemptedEstimatedStartDate_Skey]	  ,-1) AS [Month7ContactAttemptedEstimatedStartDate_Skey]
	  , COALESCE(AtW_e.[Month8ContactAttemptedEstimatedStartDate_Skey]	  ,-1) AS [Month8ContactAttemptedEstimatedStartDate_Skey]
	  , COALESCE(AtW_e.[Month1UpdateSuccessfulEstimatedStartDate_Skey]	  ,-1) AS [Month1UpdateSuccessfulEstimatedStartDate_Skey]
	  , COALESCE(AtW_e.[Month2UpdateSuccessfulEstimatedStartDate_Skey]	  ,-1) AS [Month2UpdateSuccessfulEstimatedStartDate_Skey]
	  , COALESCE(AtW_e.[Month3UpdateSuccessfulEstimatedStartDate_Skey]	  ,-1) AS [Month3UpdateSuccessfulEstimatedStartDate_Skey]
	  , COALESCE(AtW_e.[Month4UpdateSuccessfulEstimatedStartDate_Skey]	  ,-1) AS [Month4UpdateSuccessfulEstimatedStartDate_Skey]
	  , COALESCE(AtW_e.[Month5UpdateSuccessfulEstimatedStartDate_Skey]	  ,-1) AS [Month5UpdateSuccessfulEstimatedStartDate_Skey]

      , AtW_e.[NewEnquiryEstimatedEndDate_Skey]
	  , AtW_e.[ReferralCallRequiredEstimatedEndDate_Skey]
	  , AtW_e.[ReferralCallBackAttempt1EstimatedEndDate_Skey]
	  , AtW_e.[ReferralCallBackAttempt2EstimatedEndDate_Skey]
	  , AtW_e.[ReferralCallBackAttempt3EstimatedEndDate_Skey]
	  , AtW_e.[LiveEnquiryEstimatedEndDate_Skey]
      , AtW_e.[UnsuccessfulEnquiryEstimatedEndDate_Skey]
      , AtW_e.[SuccessfulEnquiryEstimatedEndDate_Skey]
      , AtW_e.[AwaitingReferralEstimatedEndDate_Skey]
      , AtW_e.[ReferralReceivedEstimatedEndDate_Skey]
      , AtW_e.[InitialContactEstimatedEndDate_Skey]
      , AtW_e.[ReferralApprovedEstimatedEndDate_Skey]
      , AtW_e.[ReferralUnsuccessfulEstimatedEndDate_Skey]
      , AtW_e.[AwaitingTelephoneAssessmentMeetingScheduleEstimatedEndDate_Skey]
      , AtW_e.[TelephoneAssessmentScheduledEstimatedEndDate_Skey]
      , AtW_e.[TelephoneAssessmentCompletedEstimatedEndDate_Skey]
      , AtW_e.[AwaitingSupportPlanMeetingScheduledEstimatedEndDate_Skey]
      , AtW_e.[SupportPlanMeetingScheduledEstimatedEndDate_Skey]
      , AtW_e.[SupportPlanMeetingCompletedEstimatedEndDate_Skey]
      , AtW_e.[SupportPlanSignedByCustomerEstimatedEndDate_Skey]
      , AtW_e.[SupportPlanUploadedEstimatedEndDate_Skey]
      , AtW_e.[SupportPlanCompletedButNotSubmittedToDwpEstimatedEndDate_Skey]
      , AtW_e.[SupportPlanSubmittedToDwpEstimatedEndDate_Skey]
	  , AtW_e.[SupportPlanNotApprovedbyDWPEstimatedEndDate_Skey]
	  , AtW_e.[AwaitingSupportPlanReSubmissionEstimatedEndDate_Skey]
	  , AtW_e.[SupportPlanReSubmittedEstimatedEndDate_Skey]
      , AtW_e.[SupportPlanApprovedByDwpEstimatedEndDate_Skey]
      , AtW_e.[SupportPlanPaidByDwpEstimatedEndDate_Skey]
      , AtW_e.[Month1UpdateOutstandingEstimatedEndDate_Skey]
      , AtW_e.[Month1UpdateCompletedEstimatedEndDate_Skey]
	  , AtW_e.[Month1BOTUpdateCompletedEstimatedEndDate_Skey]
      , AtW_e.[Month1UpdateSubmittedToDwpEstimatedEndDate_Skey]
      , AtW_e.[Month2UpdateOutstandingEstimatedEndDate_Skey]
      , AtW_e.[Month2UpdateCompletedEstimatedEndDate_Skey]
      , AtW_e.[Month2BOTUpdateCompletedEstimatedEndDate_Skey]
	  , AtW_e.[Month2UpdateSubmittedToDwpEstimatedEndDate_Skey]
      , AtW_e.[Month3UpdateOutstandingEstimatedEndDate_Skey]
      , AtW_e.[Month3UpdateCompletedEstimatedEndDate_Skey]
      , AtW_e.[Month3BOTUpdateCompletedEstimatedEndDate_Skey]
	  , AtW_e.[Month3UpdateSubmittedToDwpEstimatedEndDate_Skey]
      , AtW_e.[Month4UpdateOutstandingEstimatedEndDate_Skey]
      , AtW_e.[Month4UpdateCompletedEstimatedEndDate_Skey]
      , AtW_e.[Month4BOTUpdateCompletedEstimatedEndDate_Skey]
	  , AtW_e.[Month4UpdateSubmittedToDwpEstimatedEndDate_Skey]
      , AtW_e.[Month5UpdateOutstandingEstimatedEndDate_Skey]
      , AtW_e.[Month5UpdateCompletedEstimatedEndDate_Skey]
      , AtW_e.[Month5BOTUpdateCompletedEstimatedEndDate_Skey]
	  , AtW_e.[Month5UpdateSubmittedToDwpEstimatedEndDate_Skey]
      , AtW_e.[Awaiting6MonthSupportPlanMeetingScheduledEstimatedEndDate_Skey]
      , AtW_e.[Month6SupportPlanMeetingScheduledEstimatedEndDate_Skey]
      , AtW_e.[Month6SupportPlanMeetingCompletedEstimatedEndDate_Skey]
      , AtW_e.[Month6SupportPlanSignedByCustomerEstimatedEndDate_Skey]
      , AtW_e.[Month6SupportPlanUploadedEstimatedEndDate_Skey]
      , AtW_e.[Month6SupportPlanCompletedButNotSubmittedToDwpEstimatedEndDate_Skey]
      , AtW_e.[Month6SupportPlanSubmittedToDwpEstimatedEndDate_Skey]
	  , AtW_e.[Month6SupportPlanNotApprovedByDwpEstimatedEndDate_Skey]
	  , AtW_e.[AwaitingMonth6SupportPlanReSubmissionEstimatedEndDate_Skey]
	  , AtW_e.[Month6SupportPlanReSubmittedEstimatedEndDate_Skey]
      , AtW_e.[Month6SupportPlanApprovedByDwpEstimatedEndDate_Skey]
      , AtW_e.[Month6SupportPlanPaidByDwpEstimatedEndDate_Skey]
      , AtW_e.[AwaitingTransferToBscEstimatedEndDate_Skey]
      , AtW_e.[TransferredToBscEstimatedEndDate_Skey]
      , AtW_e.[LightTouchEmailSentUnsuccessfulEstimatedEndDate_Skey]
      , AtW_e.[LightTouchEmailSentSuccessfulEstimatedEndDate_Skey]
      , AtW_e.[AwaitingMonth7ContactEstimatedEndDate_Skey]
      , AtW_e.[Month7ContactSuccessfulEstimatedEndDate_Skey]
      , AtW_e.[Month7ContactUnsuccessfulEstimatedEndDate_Skey]
      , AtW_e.[AwaitingMonth8ContactEstimatedEndDate_Skey]
      , AtW_e.[Month8ContactSuccessfulEstimatedEndDate_Skey]
      , AtW_e.[Month8ContactUnsuccessfulEstimatedEndDate_Skey]
      , AtW_e.[Awaiting9MonthReportMeetingScheduledEstimatedEndDate_Skey]
      , AtW_e.[NineMonthReportMeetingScheduledEstimatedEndDate_Skey]
      , AtW_e.[NineMonthReportMeetingCompletedEstimatedEndDate_Skey]
      , AtW_e.[NineMonthReportSignedByCustomerEstimatedEndDate_Skey]
      , AtW_e.[NineMonthReportUploadedEstimatedEndDate_Skey]
      , AtW_e.[NineMonthReportCompletedButNotSubmittedToDwpEstimatedEndDate_Skey]
      , AtW_e.[NineMonthReportSubmittedToDwpEstimatedEndDate_Skey]
	  , AtW_e.[NineMonthReportNotApprovedByDWPEstimatedEndDate_Skey]
	  , AtW_e.[Awaiting9MonthReportReSubmissionEstimatedEndDate_Skey]
	  , AtW_e.[NineMonthReportReSubmittedEstimatedEndDate_Skey]
      , AtW_e.[NineMonthReportApprovedByDwpEstimatedEndDate_Skey]
      , AtW_e.[NineMonthReportPaidByDwpEstimatedEndDate_Skey]
	  , AtW_e.[RejectedEstimatedEndDate_Skey]
	  , COALESCE(AtW_e.[MarketingCampaignAttemptedEstimatedEndDate_Skey],-1) AS [MarketingCampaignAttemptedEstimatedEndDate_Skey]
	  , COALESCE(AtW_e.[Month7ContactAttemptedEstimatedEndDate_Skey]	,-1) AS [Month7ContactAttemptedEstimatedEndDate_Skey]	
	  , COALESCE(AtW_e.[Month8ContactAttemptedEstimatedEndDate_Skey]	,-1) AS [Month8ContactAttemptedEstimatedEndDate_Skey]	
	  , COALESCE(AtW_e.[Month1UpdateSuccessfulEstimatedEndDate_Skey]	,-1) AS [Month1UpdateSuccessfulEstimatedEndDate_Skey]	
	  , COALESCE(AtW_e.[Month2UpdateSuccessfulEstimatedEndDate_Skey]	,-1) AS [Month2UpdateSuccessfulEstimatedEndDate_Skey]	
	  , COALESCE(AtW_e.[Month3UpdateSuccessfulEstimatedEndDate_Skey]	,-1) AS [Month3UpdateSuccessfulEstimatedEndDate_Skey]	
	  , COALESCE(AtW_e.[Month4UpdateSuccessfulEstimatedEndDate_Skey]	,-1) AS [Month4UpdateSuccessfulEstimatedEndDate_Skey]	
	  , COALESCE(AtW_e.[Month5UpdateSuccessfulEstimatedEndDate_Skey]	,-1) AS [Month5UpdateSuccessfulEstimatedEndDate_Skey]	

	  , AtW_e.[SupportplanUploadedEmployee_Skey]
	  , AtW_e.[Month6SupportPlanUploadedEmployee_Skey]
	  , AtW_e.[NineMonthReportUploadedEmployee_Skey]
	  
FROM LNK_Stages lnk_s
		INNER JOIN AtW_Events AtW_e ON lnk_s.Case_Analysis_skey = AtW_e.Case_Analysis_skey
		INNER JOIN DW.F_Case_Analysis f_ca ON lnk_s.Case_analysis_skey = f_ca.Case_analysis_skey

-- Create NOT NULL constraint on temp
--alter table stg.DW_F_AtW_Case_Analysis_TEMP
--ALTER COLUMN Case_Analysis_Skey INT NOT NULL

-- Create primary key on temp
--alter table stg.DW_F_AtW_Case_Analysis_TEMP
--ADD CONSTRAINT PK_DW_F_AtW_Case_Analysis PRIMARY KEY NONCLUSTERED (Case_Analysis_Skey) NOT ENFORCED

---- Switch table contents replacing target with temp.

alter table DW.F_AtW_Case_Analysis switch to OLD.DW_F_AtW_Case_Analysis with (truncate_target=on);
alter table stg.DW_F_AtW_Case_Analysis_TEMP switch to DW.F_AtW_Case_Analysis with (truncate_target=on);

drop table stg.DW_F_AtW_Case_Analysis_TEMP;

---- Force replication of table.
--select * from DW.[F_AtW_Case_Analysis] order by 1;


--drop table DW.F_AtW_Case_Analysis
--drop table OLD.DW_F_AtW_Case_Analysis

--CREATE TABLE DW.F_AtW_Case_Analysis
--        WITH (clustered columnstore index, distribution = hash(Case_Skey)) 
--AS
--select * from stg.DW_F_AtW_Case_Analysis_TEMP WHERE 1=0

--CREATE TABLE OLD.DW_F_AtW_Case_Analysis
--        WITH (clustered columnstore index, distribution = hash(Case_Skey)) 
--AS
--select * from stg.DW_F_AtW_Case_Analysis_TEMP WHERE 1=0