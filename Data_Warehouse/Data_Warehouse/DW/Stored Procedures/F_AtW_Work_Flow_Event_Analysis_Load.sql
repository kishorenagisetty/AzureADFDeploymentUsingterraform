CREATE PROC [DW].[F_AtW_Work_Flow_Event_Analysis_Load] AS

-- -------------------------------------------------------------------
-- Script:         DW.AtW_Work_Flow_Event_Analysis Load
-- Target:         Azure Synapse Data Warehouse
-- -------------------------------------------------------------------

-- Delete temporary tables if present.

if object_id ('stg.DW_F_AtW_Work_Flow_Event_Analysis_TEMP','U') is not null drop table stg.DW_F_AtW_Work_Flow_Event_Analysis_TEMP;

---- -------------------------------------------------------------------
---- Create new table
---- -------------------------------------------------------------------

---- Get dataset from Landing Zone
CREATE TABLE stg.DW_F_AtW_Work_Flow_Event_Analysis_TEMP
        WITH (clustered columnstore index, distribution = hash(Case_Analysis_Skey)) 
AS

SELECT 
	--  DW.LNK_Work_Flow_Event_Analysis --

	    dw_LNK_wfea.[Work_Flow_Events_Skey]			
      , dw_LNK_wfea.[WorkFlowStages_Skey]
      , dw_LNK_wfea.[WorkFlowEventType_Skey]
      , dw_LNK_wfea.[WorkFlowEventDate_Skey]
	  , dw_LNK_wfea.[WorkFlowEventTime_Skey]
      , dw_LNK_wfea.[WorkFlowEstimatedStartDate_Skey]
	  , dw_LNK_wfea.[WorkFlowEstimatedStartTime_Skey]
      , dw_LNK_wfea.[WorkFlowEstimatedEndDate_Skey]
	  , dw_LNK_wfea.[WorkFlowEstimatedEndTime_Skey]
      , dw_LNK_wfea.[WorkFlowOriginalStartDate_Skey]
	  , dw_LNK_wfea.[WorkFlowOriginalStartTime_Skey]
      , dw_LNK_wfea.[WorkFlowEndDate_Skey]
	  , dw_LNK_wfea.[WorkFlowEndTime_Skey]
      , dw_LNK_wfea.[WorkFlowEventEmployee_Skey]
      , dw_LNK_wfea.[WorkFlowEventEmployeeHistory_Skey]

	  -- DW.F_Case_Analysis columns --

      , dw_f_ca.[Case_Analysis_Skey]
	  , dw_f_ca.[Candidate_Skey]
      , dw_f_ca.[Case_Skey]
      , dw_f_ca.[Source_Skey]
      , dw_f_ca.[Case_Status_Skey]
      , dw_f_ca.[Programme_Skey]
      , dw_f_ca.[CaseCreatedDate_Skey]
      , dw_f_ca.[CaseCreatedTime_Skey]
      , dw_f_ca.[CaseReceivedDate_Skey]
      , dw_f_ca.[CaseReceivedTime_Skey]
      , dw_f_ca.[PredictedEndDate_Skey]
      , dw_f_ca.[PredictedEndTime_Skey]
      , dw_f_ca.[ApprovedDate_Skey]
      , dw_f_ca.[ApprovedTime_Skey]
      , dw_f_ca.[CaseClosedDate_Skey]
      , dw_f_ca.[CaseClosedTime_Skey]
      , dw_f_ca.[CasePlanActiveDate_Skey]
      , dw_f_ca.[CasePlanActiveTime_Skey]
	  , dw_f_ca.[Employer_Contact_Skey]
	  , dw_f_ca.[Employer_Skey]
      , dw_f_ca.[Attrition_Reason_Skey]
      , dw_f_ca.[CaseOwnerEmp_Skey]
      , dw_f_ca.[CaseOwnerEmpHist_Skey]
      , dw_f_ca.[CurrentStage_Skey]
      , dw_f_ca.[AttritionStage_Skey]
      , dw_f_ca.[AttritionDate_Skey]
      , dw_f_ca.[AttritionTime_Skey]

	  , CASE WHEN WorkFlowEventType = 'New Enquiry' AND WorkFlowEventDate_Skey <> -1												THEN 1 ELSE 0 END AS NewEnquiry
	  , CASE WHEN WorkFlowEventType = 'Referral call required' AND WorkFlowEventDate_Skey <> -1										THEN 1 ELSE 0 END AS ReferralCallRequired
	  , CASE WHEN WorkFlowEventType = 'Referral call back - Attempt 1' AND WorkFlowEventDate_Skey <> -1								THEN 1 ELSE 0 END AS ReferralCallBackAttempt1
	  , CASE WHEN WorkFlowEventType = 'Referral call back - Attempt 2' AND WorkFlowEventDate_Skey <> -1								THEN 1 ELSE 0 END AS ReferralCallBackAttempt2
	  , CASE WHEN WorkFlowEventType = 'Referral call back - Attempt 3' AND WorkFlowEventDate_Skey <> -1								THEN 1 ELSE 0 END AS ReferralCallBackAttempt3
	  , CASE WHEN WorkFlowEventType = 'Live Enquiry' AND WorkFlowEventDate_Skey <> -1												THEN 1 ELSE 0 END AS LiveEnquiry
	  , CASE WHEN WorkFlowEventType = 'Unsuccessful Enquiry' AND WorkFlowEventDate_Skey <> -1										THEN 1 ELSE 0 END AS UnsuccessfulEnquiry
	  , CASE WHEN WorkFlowEventType = 'Successful Enquiry' AND WorkFlowEventDate_Skey <> -1											THEN 1 ELSE 0 END AS SuccessfulEnquiry
	  , CASE WHEN WorkFlowEventType = 'Awaiting Referral' AND WorkFlowEventDate_Skey <> -1											THEN 1 ELSE 0 END AS AwaitingReferral
	  , CASE WHEN WorkFlowEventType = 'Referral Received' AND WorkFlowEventDate_Skey <> -1											THEN 1 ELSE 0 END AS ReferralReceived
	  , CASE WHEN WorkFlowEventType = 'Email referral to DWP' AND WorkFlowEventDate_Skey <> -1										THEN 1 ELSE 0 END AS EmailreferraltoDWP
	  , CASE WHEN WorkFlowEventType = 'Referral Approved' AND WorkFlowEventDate_Skey <> -1											THEN 1 ELSE 0 END AS ReferralApproved
	  , CASE WHEN WorkFlowEventType = 'Referral Unsuccessful' AND WorkFlowEventDate_Skey <> -1										THEN 1 ELSE 0 END AS ReferralUnsuccessful
	  , CASE WHEN WorkFlowEventType = 'Initial Contact' AND WorkFlowEventDate_Skey <> -1											THEN 1 ELSE 0 END AS InitialContact
	  , CASE WHEN WorkFlowEventType = 'Awaiting Telephone Assessment Meeting Schedule' AND WorkFlowEventDate_Skey <> -1				THEN 1 ELSE 0 END AS AwaitingTelephoneAssessmentMeetingSchedule
	  , CASE WHEN WorkFlowEventType = 'Telephone Assessment scheduled' AND WorkFlowEventDate_Skey <> -1								THEN 1 ELSE 0 END AS TelephoneAssessmentscheduled
	  , CASE WHEN WorkFlowEventType = 'Telephone Assessment Completed' AND WorkFlowEventDate_Skey <> -1								THEN 1 ELSE 0 END AS TelephoneAssessmentCompleted
	  , CASE WHEN WorkFlowEventType = 'Awaiting Support Plan meeting scheduled' AND WorkFlowEventDate_Skey <> -1					THEN 1 ELSE 0 END AS AwaitingSupportPlanmeetingscheduled
	  , CASE WHEN WorkFlowEventType = 'Support plan meeting scheduled' AND WorkFlowEventDate_Skey <> -1								THEN 1 ELSE 0 END AS Supportplanmeetingscheduled
	  , CASE WHEN WorkFlowEventType = 'Support plan meeting completed' AND WorkFlowEventDate_Skey <> -1								THEN 1 ELSE 0 END AS Supportplanmeetingcompleted
	  , CASE WHEN WorkFlowEventType = 'Support plan signed by customer' AND WorkFlowEventDate_Skey <> -1							THEN 1 ELSE 0 END AS Supportplansignedbycustomer
	  , CASE WHEN WorkFlowEventType = 'Support plan Uploaded' AND WorkFlowEventDate_Skey <> -1										THEN 1 ELSE 0 END AS SupportplanUploaded
	  , CASE WHEN WorkFlowEventType = 'Support plan completed but not submitted to DWP' AND WorkFlowEventDate_Skey <> -1			THEN 1 ELSE 0 END AS SupportplancompletedbutnotsubmittedtoDWP
	  , CASE WHEN WorkFlowEventType = 'Support plan submitted to DWP' AND WorkFlowEventDate_Skey <> -1								THEN 1 ELSE 0 END AS SupportplansubmittedtoDWP
	  , CASE WHEN WorkFlowEventType = 'Support Plan Not Approved by DWP' AND WorkFlowEventDate_Skey <> -1							THEN 1 ELSE 0 END AS SupportPlanNotApprovedbyDWP
	  , CASE WHEN WorkFlowEventType = 'Awaiting Support Plan Re-Submission' AND WorkFlowEventDate_Skey <> -1						THEN 1 ELSE 0 END AS AwaitingSupportPlanReSubmission
	  , CASE WHEN WorkFlowEventType = 'Support Plan Re-Submitted' AND WorkFlowEventDate_Skey <> -1									THEN 1 ELSE 0 END AS SupportPlanReSubmitted
	  , CASE WHEN WorkFlowEventType = 'Support plan approved by DWP' AND WorkFlowEventDate_Skey <> -1								THEN 1 ELSE 0 END AS SupportplanapprovedbyDWP
	  , CASE WHEN WorkFlowEventType = 'Support plan paid by DWP' AND WorkFlowEventDate_Skey <> -1									THEN 1 ELSE 0 END AS SupportplanpaidbyDWP
	  , CASE WHEN WorkFlowEventType = 'Month 1 update outstanding' AND WorkFlowEventDate_Skey <> -1									THEN 1 ELSE 0 END AS Month1updateoutstanding
	  , CASE WHEN WorkFlowEventType = 'Month 1 update completed' AND WorkFlowEventDate_Skey <> -1									THEN 1 ELSE 0 END AS Month1updatecompleted
	  , CASE WHEN WorkFlowEventType = 'Month 1 BOT Update Completed' AND WorkFlowEventDate_Skey <> -1								THEN 1 ELSE 0 END AS Month1BOTUpdateCompleted
	  , CASE WHEN WorkFlowEventType = 'Month 1 update submitted to DWP' AND WorkFlowEventDate_Skey <> -1							THEN 1 ELSE 0 END AS Month1updatesubmittedtoDWP
	  , CASE WHEN WorkFlowEventType = 'Month 2 update outstanding' AND WorkFlowEventDate_Skey <> -1									THEN 1 ELSE 0 END AS Month2updateoutstanding
	  , CASE WHEN WorkFlowEventType = 'Month 2 update completed' AND WorkFlowEventDate_Skey <> -1									THEN 1 ELSE 0 END AS Month2updatecompleted
	  , CASE WHEN WorkFlowEventType = 'Month 2 BOT Update Completed' AND WorkFlowEventDate_Skey <> -1								THEN 1 ELSE 0 END AS Month2BOTUpdateCompleted
	  , CASE WHEN WorkFlowEventType = 'Month 2 update submitted to DWP' AND WorkFlowEventDate_Skey <> -1							THEN 1 ELSE 0 END AS Month2updatesubmittedtoDWP
	  , CASE WHEN WorkFlowEventType = 'Month 3 update outstanding' AND WorkFlowEventDate_Skey <> -1									THEN 1 ELSE 0 END AS Month3updateoutstanding
	  , CASE WHEN WorkFlowEventType = 'Month 3 update completed' AND WorkFlowEventDate_Skey <> -1									THEN 1 ELSE 0 END AS Month3updatecompleted
	  , CASE WHEN WorkFlowEventType = 'Month 3 BOT Update Completed' AND WorkFlowEventDate_Skey <> -1								THEN 1 ELSE 0 END AS Month3BOTUpdateCompleted
	  , CASE WHEN WorkFlowEventType = 'Month 3 update submitted to DWP' AND WorkFlowEventDate_Skey <> -1							THEN 1 ELSE 0 END AS Month3updatesubmittedtoDWP
	  , CASE WHEN WorkFlowEventType = 'Month 4 update outstanding' AND WorkFlowEventDate_Skey <> -1									THEN 1 ELSE 0 END AS Month4updateoutstanding
	  , CASE WHEN WorkFlowEventType = 'Month 4 update completed' AND WorkFlowEventDate_Skey <> -1									THEN 1 ELSE 0 END AS Month4updatecompleted
	  , CASE WHEN WorkFlowEventType = 'Month 4 BOT Update Completed' AND WorkFlowEventDate_Skey <> -1								THEN 1 ELSE 0 END AS Month4BOTUpdateCompleted
	  , CASE WHEN WorkFlowEventType = 'Month 4 update submitted to DWP' AND WorkFlowEventDate_Skey <> -1							THEN 1 ELSE 0 END AS Month4updatesubmittedtoDWP
	  , CASE WHEN WorkFlowEventType = 'Month 5 update outstanding' AND WorkFlowEventDate_Skey <> -1									THEN 1 ELSE 0 END AS Month5updateoutstanding
	  , CASE WHEN WorkFlowEventType = 'Month 5 update completed' AND WorkFlowEventDate_Skey <> -1									THEN 1 ELSE 0 END AS Month5updatecompleted
	  , CASE WHEN WorkFlowEventType = 'Month 5 BOT Update Completed' AND WorkFlowEventDate_Skey <> -1								THEN 1 ELSE 0 END AS Month5BOTUpdateCompleted
	  , CASE WHEN WorkFlowEventType = 'Month 5 update submitted to DWP' AND WorkFlowEventDate_Skey <> -1							THEN 1 ELSE 0 END AS Month5updatesubmittedtoDWP
	  , CASE WHEN WorkFlowEventType = 'Awaiting 6 Month Support Plan meeting scheduled' AND WorkFlowEventDate_Skey <> -1			THEN 1 ELSE 0 END AS Awaiting6MonthSupportPlanmeetingscheduled
	  , CASE WHEN WorkFlowEventType = 'Month 6 Support plan meeting scheduled' AND WorkFlowEventDate_Skey <> -1						THEN 1 ELSE 0 END AS Month6Supportplanmeetingscheduled
	  , CASE WHEN WorkFlowEventType = 'Month 6 Support plan meeting completed' AND WorkFlowEventDate_Skey <> -1						THEN 1 ELSE 0 END AS Month6Supportplanmeetingcompleted
	  , CASE WHEN WorkFlowEventType = 'Month 6 Support plan signed by customer' AND WorkFlowEventDate_Skey <> -1					THEN 1 ELSE 0 END AS Month6Supportplansignedbycustomer
	  , CASE WHEN WorkFlowEventType = 'Month 6 Support plan Uploaded' AND WorkFlowEventDate_Skey <> -1								THEN 1 ELSE 0 END AS Month6SupportplanUploaded
	  , CASE WHEN WorkFlowEventType = 'Month 6 Support plan completed but not submitted to DWP' AND WorkFlowEventDate_Skey <> -1	THEN 1 ELSE 0 END AS Month6SupportplancompletedbutnotsubmittedtoDWP
	  , CASE WHEN WorkFlowEventType = 'Month 6 Support plan submitted to DWP' AND WorkFlowEventDate_Skey <> -1						THEN 1 ELSE 0 END AS Month6SupportplansubmittedtoDWP
	  , CASE WHEN WorkFlowEventType = 'Month 6 Support Plan Not Approved by DWP' AND WorkFlowEventDate_Skey <> -1					THEN 1 ELSE 0 END AS Month6SupportPlanNotApprovedbyDWP
	  , CASE WHEN WorkFlowEventType = 'Awaiting Month 6 Support Plan Re-Submission' AND WorkFlowEventDate_Skey <> -1				THEN 1 ELSE 0 END AS AwaitingMonth6SupportPlanReSubmission
	  , CASE WHEN WorkFlowEventType = 'Month 6 Support Plan Re-Submitted' AND WorkFlowEventDate_Skey <> -1							THEN 1 ELSE 0 END AS Month6SupportPlanReSubmitted
	  , CASE WHEN WorkFlowEventType = 'Month 6 Support plan approved by DWP' AND WorkFlowEventDate_Skey <> -1						THEN 1 ELSE 0 END AS Month6SupportplanapprovedbyDWP
	  , CASE WHEN WorkFlowEventType = 'Month 6 Support plan paid by DWP' AND WorkFlowEventDate_Skey <> -1							THEN 1 ELSE 0 END AS Month6SupportplanpaidbyDWP
	  , CASE WHEN WorkFlowEventType = 'Awaiting Transfer To BSC' AND WorkFlowEventDate_Skey <> -1									THEN 1 ELSE 0 END AS AwaitingTransferToBSC
	  , CASE WHEN WorkFlowEventType = 'Transferred To BSC' AND WorkFlowEventDate_Skey <> -1											THEN 1 ELSE 0 END AS TransferredToBSC
	  , CASE WHEN WorkFlowEventType = 'Light Touch Email Sent - Unsuccessful' AND WorkFlowEventDate_Skey <> -1						THEN 1 ELSE 0 END AS LightTouchEmailSentUnsuccessful
	  , CASE WHEN WorkFlowEventType = 'Light Touch Email Sent - Successful' AND WorkFlowEventDate_Skey <> -1						THEN 1 ELSE 0 END AS LightTouchEmailSentSuccessful
	  , CASE WHEN WorkFlowEventType = 'Awaiting Month 7 Contact' AND WorkFlowEventDate_Skey <> -1									THEN 1 ELSE 0 END AS AwaitingMonth7Contact
	  , CASE WHEN WorkFlowEventType = 'Month 7 Contact Successful' AND WorkFlowEventDate_Skey <> -1									THEN 1 ELSE 0 END AS Month7ContactSuccessful
	  , CASE WHEN WorkFlowEventType = 'Month 7 Contact Unsuccessful' AND WorkFlowEventDate_Skey <> -1								THEN 1 ELSE 0 END AS Month7ContactUnsuccessful
	  , CASE WHEN WorkFlowEventType = 'Awaiting Month 8 Contact' AND WorkFlowEventDate_Skey <> -1									THEN 1 ELSE 0 END AS AwaitingMonth8Contact
	  , CASE WHEN WorkFlowEventType = 'Month 8 Contact Successful' AND WorkFlowEventDate_Skey <> -1									THEN 1 ELSE 0 END AS Month8ContactSuccessful
	  , CASE WHEN WorkFlowEventType = 'Month 8 Contact Unsuccessful' AND WorkFlowEventDate_Skey <> -1								THEN 1 ELSE 0 END AS Month8ContactUnsuccessful
	  , CASE WHEN WorkFlowEventType = 'Awaiting 9 Month Report meeting scheduled' AND WorkFlowEventDate_Skey <> -1					THEN 1 ELSE 0 END AS Awaiting9MonthReportmeetingscheduled
	  , CASE WHEN WorkFlowEventType = '9 Month Report meeting scheduled' AND WorkFlowEventDate_Skey <> -1							THEN 1 ELSE 0 END AS NineMonthReportmeetingscheduled
	  , CASE WHEN WorkFlowEventType = '9 Month Report meeting completed' AND WorkFlowEventDate_Skey <> -1							THEN 1 ELSE 0 END AS NineMonthReportmeetingcompleted
	  , CASE WHEN WorkFlowEventType = '9 Month Report signed by customer' AND WorkFlowEventDate_Skey <> -1							THEN 1 ELSE 0 END AS NineMonthReportsignedbycustomer
	  , CASE WHEN WorkFlowEventType = '9 Month Report Uploaded' AND WorkFlowEventDate_Skey <> -1									THEN 1 ELSE 0 END AS NineMonthReportUploaded
	  , CASE WHEN WorkFlowEventType = '9 Month Report completed but not submitted to DWP' AND WorkFlowEventDate_Skey <> -1			THEN 1 ELSE 0 END AS NineMonthReportcompletedbutnotsubmittedtoDWP
	  , CASE WHEN WorkFlowEventType = '9 Month Report submitted to DWP' AND WorkFlowEventDate_Skey <> -1							THEN 1 ELSE 0 END AS NineMonthReportsubmittedtoDWP
	  , CASE WHEN WorkFlowEventType = '9 Month Report Not Approved by DWP' AND WorkFlowEventDate_Skey <> -1							THEN 1 ELSE 0 END AS NineMonthReportNotApprovedbyDWP
	  , CASE WHEN WorkFlowEventType = 'Awaiting 9 Month Report Re-Submission' AND WorkFlowEventDate_Skey <> -1						THEN 1 ELSE 0 END AS Awaiting9MonthReportReSubmission
	  , CASE WHEN WorkFlowEventType = '9 Month Report Re-Submitted' AND WorkFlowEventDate_Skey <> -1								THEN 1 ELSE 0 END AS NineMonthReportReSubmitted
	  , CASE WHEN WorkFlowEventType = '9 Month Report approved by DWP' AND WorkFlowEventDate_Skey <> -1								THEN 1 ELSE 0 END AS NineMonthReportapprovedbyDWP
	  , CASE WHEN WorkFlowEventType = '9 Month Report paid by DWP' AND WorkFlowEventDate_Skey <> -1									THEN 1 ELSE 0 END AS NineMonthReportpaidbyDWP
	  , CASE WHEN WorkFlowEventType = 'Rejected' AND WorkFlowEventDate_Skey <> -1													THEN 1 ELSE 0 END AS Rejected

	  , dw_LNK_wfea.[EventCount]
	  , dw_LNK_wfea.[EventOutstandingCount]
	  , dw_LNK_wfea.[EventCompletedCount]
	  , dw_LNK_wfea.[EventOverDueCount]
	  , dw_LNK_wfea.[EventCompletedWithinSLACount]
	  , dw_LNK_wfea.[EventCompletedOutsideSLACount]
	  , dw_LNK_wfea.[EventSkippedCount]

	  , CASE WHEN (WorkFlowEventType = 'Light Touch Email Sent - Unsuccessful' AND WorkFlowEventDate_Skey <> -1) OR (WorkFlowEventType = 'Light Touch Email Sent - Successful' AND WorkFlowEventDate_Skey <> -1)	THEN 1 ELSE 0 END AS MarketingCampaignAttempted
	  , CASE WHEN (WorkFlowEventType = 'Month 7 Contact Unsuccessful' AND WorkFlowEventDate_Skey <> -1) OR (WorkFlowEventType = 'Month 7 Contact Successful' AND WorkFlowEventDate_Skey <> -1)						THEN 1 ELSE 0 END AS Month7ContactAttempted
	  , CASE WHEN (WorkFlowEventType = 'Month 8 Contact Unsuccessful' AND WorkFlowEventDate_Skey <> -1) OR (WorkFlowEventType = 'Month 8 Contact Successful' AND WorkFlowEventDate_Skey <> -1)						THEN 1 ELSE 0 END AS Month8ContactAttempted
	  , CASE WHEN (WorkFlowEventType = 'Month 1 update completed' AND WorkFlowEventDate_Skey <> -1) OR (WorkFlowEventType = 'Month 1 BOT Update Completed' AND WorkFlowEventDate_Skey <> -1)						THEN 1 ELSE 0 END AS Month1UpdateSuccessful
	  , CASE WHEN (WorkFlowEventType = 'Month 2 update completed' AND WorkFlowEventDate_Skey <> -1) OR (WorkFlowEventType = 'Month 2 BOT Update Completed' AND WorkFlowEventDate_Skey <> -1)						THEN 1 ELSE 0 END AS Month2UpdateSuccessful
	  , CASE WHEN (WorkFlowEventType = 'Month 3 update completed' AND WorkFlowEventDate_Skey <> -1) OR (WorkFlowEventType = 'Month 3 BOT Update Completed' AND WorkFlowEventDate_Skey <> -1)						THEN 1 ELSE 0 END AS Month3UpdateSuccessful
	  , CASE WHEN (WorkFlowEventType = 'Month 4 update completed' AND WorkFlowEventDate_Skey <> -1) OR (WorkFlowEventType = 'Month 4 BOT Update Completed' AND WorkFlowEventDate_Skey <> -1)						THEN 1 ELSE 0 END AS Month4UpdateSuccessful
	  , CASE WHEN (WorkFlowEventType = 'Month 5 update completed' AND WorkFlowEventDate_Skey <> -1) OR (WorkFlowEventType = 'Month 5 BOT Update Completed' AND WorkFlowEventDate_Skey <> -1)						THEN 1 ELSE 0 END AS Month5UpdateSuccessful

	  , dw_lnk_wfea.Sys_LoadDate
	  , dw_lnk_wfea.Sys_RunID

FROM DW.LNK_Work_Flow_Event_Analysis dw_LNK_wfea
		LEFT JOIN DW.F_Case_Analysis dw_f_ca
			ON dw_LNK_wfea.[Case_Analysis_Skey] = dw_f_ca.[Case_Analysis_Skey]
		LEFT JOIN DW.D_Work_Flow_Event_Type dw_d_wfet
			ON dw_LNK_wfea.[WorkFlowEventType_Skey] = dw_d_wfet.[Work_Flow_Event_Type_Skey]
		INNER JOIN DW.D_Time dw_est_st_time
			ON dw_LNK_wfea.[WorkFlowEstimatedStartTime_Skey] = dw_est_st_time.Time_Skey
		INNER JOIN DW.D_Time dw_est_end_time
			ON dw_LNK_wfea.[WorkFlowEstimatedEndTime_Skey] = dw_est_end_time.Time_Skey

-- Create NOT NULL constraint on temp
alter table stg.DW_F_AtW_Work_Flow_Event_Analysis_TEMP
ALTER COLUMN Work_Flow_Events_Skey INT NOT NULL

-- Create primary key on temp
alter table stg.DW_F_AtW_Work_Flow_Event_Analysis_TEMP
ADD CONSTRAINT PK_DW_F_AtW_Work_Flow_Event_Analysis PRIMARY KEY NONCLUSTERED (Work_Flow_Events_Skey) NOT ENFORCED

---- Switch table contents replacing target with temp.

alter table DW.F_AtW_Work_Flow_Event_Analysis switch to OLD.DW_F_AtW_Work_Flow_Event_Analysis with (truncate_target=on);
alter table stg.DW_F_AtW_Work_Flow_Event_Analysis_TEMP switch to DW.F_AtW_Work_Flow_Event_Analysis with (truncate_target=on);

drop table stg.DW_F_AtW_Work_Flow_Event_Analysis_TEMP;

---- Force replication of table.
--select * from DW.[F_AtW_Work_Flow_Event_Analysis] order by 1;


--drop table DW.F_AtW_Work_Flow_Event_Analysis
--drop table OLD.DW_F_AtW_Work_Flow_Event_Analysis

--CREATE TABLE DW.F_AtW_Work_Flow_Event_Analysis
--        WITH (clustered columnstore index, distribution = hash(Case_Analysis_Skey)) 
--AS
--select * from stg.DW_F_AtW_Work_Flow_Event_Analysis_TEMP WHERE 1=0

--CREATE TABLE OLD.DW_F_AtW_Work_Flow_Event_Analysis
--        WITH (clustered columnstore index, distribution = hash(Case_Analysis_Skey)) 
--AS
--select * from stg.DW_F_AtW_Work_Flow_Event_Analysis_TEMP WHERE 1=0