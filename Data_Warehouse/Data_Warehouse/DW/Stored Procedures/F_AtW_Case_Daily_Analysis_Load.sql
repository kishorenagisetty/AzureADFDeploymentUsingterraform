CREATE PROC [DW].[F_AtW_Case_Daily_Analysis_Load] AS


-- -------------------------------------------------------------------
-- Script:         DW.AtW_Case_Daily_Analysis Load
-- Target:         Azure Synapse Data Warehouse
-- -------------------------------------------------------------------

-- Delete temporary tables if present.

if object_id ('stg.DW_F_AtW_Case_Daily_Analysis_TEMP','U')  is not null drop table stg.DW_F_AtW_Case_Daily_Analysis_TEMP;
if object_id ('stg.DW_F_AtW_Case_Daily_Analysis_TEMP1','U') is not null drop table stg.DW_F_AtW_Case_Daily_Analysis_TEMP1;
if object_id ('stg.DW_F_AtW_Case_Daily_Analysis_TEMP2','U') is not null drop table stg.DW_F_AtW_Case_Daily_Analysis_TEMP2;
if object_id ('stg.DW_F_AtW_Case_Daily_Analysis_TEMP3','U') is not null drop table stg.DW_F_AtW_Case_Daily_Analysis_TEMP3;
if object_id ('stg.DW_F_AtW_Case_Daily_Analysis_TEMP4','U') is not null drop table stg.DW_F_AtW_Case_Daily_Analysis_TEMP4;
if object_id ('stg.DW_F_AtW_Case_Daily_Analysis_TEMP5','U') is not null drop table stg.DW_F_AtW_Case_Daily_Analysis_TEMP5;

-- Get Date to build from --
DECLARE @LoadDate INT = (SELECT CAST(format(Load_Date,'yyyyMMdd') AS INT) FROM ELT.Load_Control_Table WHERE TableName = 'DW.F_AtW_Case_Daily_Analysis');

---- -------------------------------------------------------------------
---- Create new table
---- -------------------------------------------------------------------

-- Get All Cases and Snapshot Dates to be re-processed --
CREATE TABLE stg.DW_F_AtW_Case_Daily_Analysis_TEMP
       WITH (distribution = hash(Case_Analysis_Skey), HEAP) 
AS

SELECT
	dw_d_dt.[Date_Skey]			AS SnapshotDate
  , dw_f_ca.[Case_Analysis_Skey]
FROM DW.F_Case_Analysis dw_f_ca
	CROSS JOIN DW.D_Date dw_d_dt
	LEFT JOIN 
		(SELECT DISTINCT Case_Analysis_Skey FROM DW.F_AtW_Case_Daily_Analysis) dw_f_cda
		ON dw_f_ca.Case_Analysis_Skey = dw_f_cda.Case_Analysis_Skey
	
WHERE  
	dw_d_dt.Date_Skey >= dw_f_ca.CaseCreatedDate_Skey 
	AND dw_d_dt.Date_Skey >= CASE WHEN dw_f_cda.Case_Analysis_Skey IS NOT NULL THEN @LoadDate  ELSE 0 END
	AND dw_d_dt.[Date] <= GETDATE()

-- Calculate the Event measures on snapshot date --
CREATE TABLE stg.DW_F_AtW_Case_Daily_Analysis_TEMP1
        WITH (distribution = hash(Case_Analysis_Skey), HEAP) 
AS
SELECT
	  SnapshotDate
	, fca.Case_Analysis_Skey

	, MAX(CASE WHEN [WorkFlowEventType] = 'New Enquiry'												AND ((WorkFlowEventDate_Skey BETWEEN 20110102 AND fca.SnapshotDate) OR (fca.SnapshotDate >= lnk_wfea.WorkFlowOriginalStartDate_Skey AND fca.SnapshotDate < lnk_wfea.WorkFlowEndDate_Skey)) THEN 1 ELSE 0 END) AS NewEnquiry
	, MAX(CASE WHEN [WorkFlowEventType] = 'Referral call required'									AND ((WorkFlowEventDate_Skey BETWEEN 20110102 AND fca.SnapshotDate) OR (fca.SnapshotDate >= lnk_wfea.WorkFlowOriginalStartDate_Skey AND fca.SnapshotDate < lnk_wfea.WorkFlowEndDate_Skey)) THEN 1 ELSE 0 END) AS ReferralCallRequired
	, MAX(CASE WHEN [WorkFlowEventType] = 'Referral call back - Attempt 1'							AND ((WorkFlowEventDate_Skey BETWEEN 20110102 AND fca.SnapshotDate) OR (fca.SnapshotDate >= lnk_wfea.WorkFlowOriginalStartDate_Skey AND fca.SnapshotDate < lnk_wfea.WorkFlowEndDate_Skey)) THEN 1 ELSE 0 END) AS ReferralCallBackAttempt1
	, MAX(CASE WHEN [WorkFlowEventType] = 'Referral call back - Attempt 2'							AND ((WorkFlowEventDate_Skey BETWEEN 20110102 AND fca.SnapshotDate) OR (fca.SnapshotDate >= lnk_wfea.WorkFlowOriginalStartDate_Skey AND fca.SnapshotDate < lnk_wfea.WorkFlowEndDate_Skey)) THEN 1 ELSE 0 END) AS ReferralCallBackAttempt2
	, MAX(CASE WHEN [WorkFlowEventType] = 'Referral call back - Attempt 3'							AND ((WorkFlowEventDate_Skey BETWEEN 20110102 AND fca.SnapshotDate) OR (fca.SnapshotDate >= lnk_wfea.WorkFlowOriginalStartDate_Skey AND fca.SnapshotDate < lnk_wfea.WorkFlowEndDate_Skey)) THEN 1 ELSE 0 END) AS ReferralCallBackAttempt3
	, MAX(CASE WHEN [WorkFlowEventType] = 'Live Enquiry'											AND ((WorkFlowEventDate_Skey BETWEEN 20110102 AND fca.SnapshotDate) OR (fca.SnapshotDate >= lnk_wfea.WorkFlowOriginalStartDate_Skey AND fca.SnapshotDate < lnk_wfea.WorkFlowEndDate_Skey)) THEN 1 ELSE 0 END) AS LiveEnquiry
	, MAX(CASE WHEN [WorkFlowEventType] = 'Unsuccessful Enquiry'									AND ((WorkFlowEventDate_Skey BETWEEN 20110102 AND fca.SnapshotDate) OR (fca.SnapshotDate >= lnk_wfea.WorkFlowOriginalStartDate_Skey AND fca.SnapshotDate < lnk_wfea.WorkFlowEndDate_Skey)) THEN 1 ELSE 0 END) AS UnsuccessfulEnquiry
	, MAX(CASE WHEN [WorkFlowEventType] = 'Successful Enquiry'										AND ((WorkFlowEventDate_Skey BETWEEN 20110102 AND fca.SnapshotDate) OR (fca.SnapshotDate >= lnk_wfea.WorkFlowOriginalStartDate_Skey AND fca.SnapshotDate < lnk_wfea.WorkFlowEndDate_Skey)) THEN 1 ELSE 0 END) AS SuccessfulEnquiry
	, MAX(CASE WHEN [WorkFlowEventType] = 'Awaiting Referral'										AND ((WorkFlowEventDate_Skey BETWEEN 20110102 AND fca.SnapshotDate) OR (fca.SnapshotDate >= lnk_wfea.WorkFlowOriginalStartDate_Skey AND fca.SnapshotDate < lnk_wfea.WorkFlowEndDate_Skey)) THEN 1 ELSE 0 END) AS AwaitingReferral
	, MAX(CASE WHEN [WorkFlowEventType] = 'Referral Received'										AND ((WorkFlowEventDate_Skey BETWEEN 20110102 AND fca.SnapshotDate) OR (fca.SnapshotDate >= lnk_wfea.WorkFlowOriginalStartDate_Skey AND fca.SnapshotDate < lnk_wfea.WorkFlowEndDate_Skey)) THEN 1 ELSE 0 END) AS ReferralReceived
	, MAX(CASE WHEN [WorkFlowEventType] = 'Email referral to DWP'									AND ((WorkFlowEventDate_Skey BETWEEN 20110102 AND fca.SnapshotDate) OR (fca.SnapshotDate >= lnk_wfea.WorkFlowOriginalStartDate_Skey AND fca.SnapshotDate < lnk_wfea.WorkFlowEndDate_Skey)) THEN 1 ELSE 0 END) AS EmailreferraltoDWP
	, MAX(CASE WHEN [WorkFlowEventType] = 'Referral Approved'										AND ((WorkFlowEventDate_Skey BETWEEN 20110102 AND fca.SnapshotDate) OR (fca.SnapshotDate >= lnk_wfea.WorkFlowOriginalStartDate_Skey AND fca.SnapshotDate < lnk_wfea.WorkFlowEndDate_Skey)) THEN 1 ELSE 0 END) AS ReferralApproved
	, MAX(CASE WHEN [WorkFlowEventType] = 'Referral Unsuccessful'									AND ((WorkFlowEventDate_Skey BETWEEN 20110102 AND fca.SnapshotDate) OR (fca.SnapshotDate >= lnk_wfea.WorkFlowOriginalStartDate_Skey AND fca.SnapshotDate < lnk_wfea.WorkFlowEndDate_Skey)) THEN 1 ELSE 0 END) AS ReferralUnsuccessful
	, MAX(CASE WHEN [WorkFlowEventType] = 'Initial Contact'											AND ((WorkFlowEventDate_Skey BETWEEN 20110102 AND fca.SnapshotDate) OR (fca.SnapshotDate >= lnk_wfea.WorkFlowOriginalStartDate_Skey AND fca.SnapshotDate < lnk_wfea.WorkFlowEndDate_Skey)) THEN 1 ELSE 0 END) AS InitialContact
	, MAX(CASE WHEN [WorkFlowEventType] = 'Awaiting Telephone Assessment Meeting Schedule'			AND ((WorkFlowEventDate_Skey BETWEEN 20110102 AND fca.SnapshotDate) OR (fca.SnapshotDate >= lnk_wfea.WorkFlowOriginalStartDate_Skey AND fca.SnapshotDate < lnk_wfea.WorkFlowEndDate_Skey)) THEN 1 ELSE 0 END) AS AwaitingTelephoneAssessmentMeetingSchedule
	, MAX(CASE WHEN [WorkFlowEventType] = 'Telephone Assessment scheduled'							AND ((WorkFlowEventDate_Skey BETWEEN 20110102 AND fca.SnapshotDate) OR (fca.SnapshotDate >= lnk_wfea.WorkFlowOriginalStartDate_Skey AND fca.SnapshotDate < lnk_wfea.WorkFlowEndDate_Skey)) THEN 1 ELSE 0 END) AS TelephoneAssessmentscheduled
	, MAX(CASE WHEN [WorkFlowEventType] = 'Telephone Assessment Completed'							AND ((WorkFlowEventDate_Skey BETWEEN 20110102 AND fca.SnapshotDate) OR (fca.SnapshotDate >= lnk_wfea.WorkFlowOriginalStartDate_Skey AND fca.SnapshotDate < lnk_wfea.WorkFlowEndDate_Skey)) THEN 1 ELSE 0 END) AS TelephoneAssessmentCompleted
	, MAX(CASE WHEN [WorkFlowEventType] = 'Awaiting Support Plan meeting scheduled'					AND ((WorkFlowEventDate_Skey BETWEEN 20110102 AND fca.SnapshotDate) OR (fca.SnapshotDate >= lnk_wfea.WorkFlowOriginalStartDate_Skey AND fca.SnapshotDate < lnk_wfea.WorkFlowEndDate_Skey)) THEN 1 ELSE 0 END) AS AwaitingSupportPlanmeetingscheduled
	, MAX(CASE WHEN [WorkFlowEventType] = 'Support plan meeting scheduled'							AND ((WorkFlowEventDate_Skey BETWEEN 20110102 AND fca.SnapshotDate) OR (fca.SnapshotDate >= lnk_wfea.WorkFlowOriginalStartDate_Skey AND fca.SnapshotDate < lnk_wfea.WorkFlowEndDate_Skey)) THEN 1 ELSE 0 END) AS Supportplanmeetingscheduled
	, MAX(CASE WHEN [WorkFlowEventType] = 'Support plan meeting completed'							AND ((WorkFlowEventDate_Skey BETWEEN 20110102 AND fca.SnapshotDate) OR (fca.SnapshotDate >= lnk_wfea.WorkFlowOriginalStartDate_Skey AND fca.SnapshotDate < lnk_wfea.WorkFlowEndDate_Skey)) THEN 1 ELSE 0 END) AS Supportplanmeetingcompleted
	, MAX(CASE WHEN [WorkFlowEventType] = 'Support plan signed by customer'							AND ((WorkFlowEventDate_Skey BETWEEN 20110102 AND fca.SnapshotDate) OR (fca.SnapshotDate >= lnk_wfea.WorkFlowOriginalStartDate_Skey AND fca.SnapshotDate < lnk_wfea.WorkFlowEndDate_Skey)) THEN 1 ELSE 0 END) AS Supportplansignedbycustomer
	, MAX(CASE WHEN [WorkFlowEventType] = 'Support plan Uploaded'									AND ((WorkFlowEventDate_Skey BETWEEN 20110102 AND fca.SnapshotDate) OR (fca.SnapshotDate >= lnk_wfea.WorkFlowOriginalStartDate_Skey AND fca.SnapshotDate < lnk_wfea.WorkFlowEndDate_Skey)) THEN 1 ELSE 0 END) AS SupportplanUploaded
	, MAX(CASE WHEN [WorkFlowEventType] = 'Support plan completed but not submitted to DWP'			AND ((WorkFlowEventDate_Skey BETWEEN 20110102 AND fca.SnapshotDate) OR (fca.SnapshotDate >= lnk_wfea.WorkFlowOriginalStartDate_Skey AND fca.SnapshotDate < lnk_wfea.WorkFlowEndDate_Skey)) THEN 1 ELSE 0 END) AS SupportplancompletedbutnotsubmittedtoDWP
	, MAX(CASE WHEN [WorkFlowEventType] = 'Support plan submitted to DWP'							AND ((WorkFlowEventDate_Skey BETWEEN 20110102 AND fca.SnapshotDate) OR (fca.SnapshotDate >= lnk_wfea.WorkFlowOriginalStartDate_Skey AND fca.SnapshotDate < lnk_wfea.WorkFlowEndDate_Skey)) THEN 1 ELSE 0 END) AS SupportplansubmittedtoDWP
	, MAX(CASE WHEN [WorkFlowEventType] = 'Support Plan Not Approved by DWP'						AND ((WorkFlowEventDate_Skey BETWEEN 20110102 AND fca.SnapshotDate) OR (fca.SnapshotDate >= lnk_wfea.WorkFlowOriginalStartDate_Skey AND fca.SnapshotDate < lnk_wfea.WorkFlowEndDate_Skey)) THEN 1 ELSE 0 END) AS SupportPlanNotApprovedbyDWP
	, MAX(CASE WHEN [WorkFlowEventType] = 'Awaiting Support Plan Re-Submission'						AND ((WorkFlowEventDate_Skey BETWEEN 20110102 AND fca.SnapshotDate) OR (fca.SnapshotDate >= lnk_wfea.WorkFlowOriginalStartDate_Skey AND fca.SnapshotDate < lnk_wfea.WorkFlowEndDate_Skey)) THEN 1 ELSE 0 END) AS AwaitingSupportPlanReSubmission
	, MAX(CASE WHEN [WorkFlowEventType] = 'Support Plan Re-Submitted'								AND ((WorkFlowEventDate_Skey BETWEEN 20110102 AND fca.SnapshotDate) OR (fca.SnapshotDate >= lnk_wfea.WorkFlowOriginalStartDate_Skey AND fca.SnapshotDate < lnk_wfea.WorkFlowEndDate_Skey)) THEN 1 ELSE 0 END) AS SupportPlanReSubmitted
	, MAX(CASE WHEN [WorkFlowEventType] = 'Support plan approved by DWP'							AND ((WorkFlowEventDate_Skey BETWEEN 20110102 AND fca.SnapshotDate) OR (fca.SnapshotDate >= lnk_wfea.WorkFlowOriginalStartDate_Skey AND fca.SnapshotDate < lnk_wfea.WorkFlowEndDate_Skey)) THEN 1 ELSE 0 END) AS SupportplanapprovedbyDWP
	, MAX(CASE WHEN [WorkFlowEventType] = 'Support plan paid by DWP'								AND ((WorkFlowEventDate_Skey BETWEEN 20110102 AND fca.SnapshotDate) OR (fca.SnapshotDate >= lnk_wfea.WorkFlowOriginalStartDate_Skey AND fca.SnapshotDate < lnk_wfea.WorkFlowEndDate_Skey)) THEN 1 ELSE 0 END) AS SupportplanpaidbyDWP
	, MAX(CASE WHEN [WorkFlowEventType] = 'Month 1 update outstanding'								AND ((WorkFlowEventDate_Skey BETWEEN 20110102 AND fca.SnapshotDate) OR (fca.SnapshotDate >= lnk_wfea.WorkFlowOriginalStartDate_Skey AND fca.SnapshotDate < lnk_wfea.WorkFlowEndDate_Skey)) THEN 1 ELSE 0 END) AS Month1updateoutstanding
	, MAX(CASE WHEN [WorkFlowEventType] = 'Month 1 update completed'								AND ((WorkFlowEventDate_Skey BETWEEN 20110102 AND fca.SnapshotDate) OR (fca.SnapshotDate >= lnk_wfea.WorkFlowOriginalStartDate_Skey AND fca.SnapshotDate < lnk_wfea.WorkFlowEndDate_Skey)) THEN 1 ELSE 0 END) AS Month1updatecompleted
	, MAX(CASE WHEN [WorkFlowEventType] = 'Month 1 BOT Update Completed'							AND ((WorkFlowEventDate_Skey BETWEEN 20110102 AND fca.SnapshotDate) OR (fca.SnapshotDate >= lnk_wfea.WorkFlowOriginalStartDate_Skey AND fca.SnapshotDate < lnk_wfea.WorkFlowEndDate_Skey)) THEN 1 ELSE 0 END) AS Month1BOTUpdateCompleted
	, MAX(CASE WHEN [WorkFlowEventType] = 'Month 1 update submitted to DWP'							AND ((WorkFlowEventDate_Skey BETWEEN 20110102 AND fca.SnapshotDate) OR (fca.SnapshotDate >= lnk_wfea.WorkFlowOriginalStartDate_Skey AND fca.SnapshotDate < lnk_wfea.WorkFlowEndDate_Skey)) THEN 1 ELSE 0 END) AS Month1updatesubmittedtoDWP
	, MAX(CASE WHEN [WorkFlowEventType] = 'Month 2 update outstanding'								AND ((WorkFlowEventDate_Skey BETWEEN 20110102 AND fca.SnapshotDate) OR (fca.SnapshotDate >= lnk_wfea.WorkFlowOriginalStartDate_Skey AND fca.SnapshotDate < lnk_wfea.WorkFlowEndDate_Skey)) THEN 1 ELSE 0 END) AS Month2updateoutstanding
	, MAX(CASE WHEN [WorkFlowEventType] = 'Month 2 update completed'								AND ((WorkFlowEventDate_Skey BETWEEN 20110102 AND fca.SnapshotDate) OR (fca.SnapshotDate >= lnk_wfea.WorkFlowOriginalStartDate_Skey AND fca.SnapshotDate < lnk_wfea.WorkFlowEndDate_Skey)) THEN 1 ELSE 0 END) AS Month2updatecompleted
	, MAX(CASE WHEN [WorkFlowEventType] = 'Month 2 BOT Update Completed'							AND ((WorkFlowEventDate_Skey BETWEEN 20110102 AND fca.SnapshotDate) OR (fca.SnapshotDate >= lnk_wfea.WorkFlowOriginalStartDate_Skey AND fca.SnapshotDate < lnk_wfea.WorkFlowEndDate_Skey)) THEN 1 ELSE 0 END) AS Month2BOTUpdateCompleted
	, MAX(CASE WHEN [WorkFlowEventType] = 'Month 2 update submitted to DWP'							AND ((WorkFlowEventDate_Skey BETWEEN 20110102 AND fca.SnapshotDate) OR (fca.SnapshotDate >= lnk_wfea.WorkFlowOriginalStartDate_Skey AND fca.SnapshotDate < lnk_wfea.WorkFlowEndDate_Skey)) THEN 1 ELSE 0 END) AS Month2updatesubmittedtoDWP
	, MAX(CASE WHEN [WorkFlowEventType] = 'Month 3 update outstanding'								AND ((WorkFlowEventDate_Skey BETWEEN 20110102 AND fca.SnapshotDate) OR (fca.SnapshotDate >= lnk_wfea.WorkFlowOriginalStartDate_Skey AND fca.SnapshotDate < lnk_wfea.WorkFlowEndDate_Skey)) THEN 1 ELSE 0 END) AS Month3updateoutstanding
	, MAX(CASE WHEN [WorkFlowEventType] = 'Month 3 update completed'								AND ((WorkFlowEventDate_Skey BETWEEN 20110102 AND fca.SnapshotDate) OR (fca.SnapshotDate >= lnk_wfea.WorkFlowOriginalStartDate_Skey AND fca.SnapshotDate < lnk_wfea.WorkFlowEndDate_Skey)) THEN 1 ELSE 0 END) AS Month3updatecompleted
	, MAX(CASE WHEN [WorkFlowEventType] = 'Month 3 BOT Update Completed'							AND ((WorkFlowEventDate_Skey BETWEEN 20110102 AND fca.SnapshotDate) OR (fca.SnapshotDate >= lnk_wfea.WorkFlowOriginalStartDate_Skey AND fca.SnapshotDate < lnk_wfea.WorkFlowEndDate_Skey)) THEN 1 ELSE 0 END) AS Month3BOTUpdateCompleted
	, MAX(CASE WHEN [WorkFlowEventType] = 'Month 3 update submitted to DWP'							AND ((WorkFlowEventDate_Skey BETWEEN 20110102 AND fca.SnapshotDate) OR (fca.SnapshotDate >= lnk_wfea.WorkFlowOriginalStartDate_Skey AND fca.SnapshotDate < lnk_wfea.WorkFlowEndDate_Skey)) THEN 1 ELSE 0 END) AS Month3updatesubmittedtoDWP
	, MAX(CASE WHEN [WorkFlowEventType] = 'Month 4 update outstanding'								AND ((WorkFlowEventDate_Skey BETWEEN 20110102 AND fca.SnapshotDate) OR (fca.SnapshotDate >= lnk_wfea.WorkFlowOriginalStartDate_Skey AND fca.SnapshotDate < lnk_wfea.WorkFlowEndDate_Skey)) THEN 1 ELSE 0 END) AS Month4updateoutstanding
	, MAX(CASE WHEN [WorkFlowEventType] = 'Month 4 update completed'								AND ((WorkFlowEventDate_Skey BETWEEN 20110102 AND fca.SnapshotDate) OR (fca.SnapshotDate >= lnk_wfea.WorkFlowOriginalStartDate_Skey AND fca.SnapshotDate < lnk_wfea.WorkFlowEndDate_Skey)) THEN 1 ELSE 0 END) AS Month4updatecompleted
	, MAX(CASE WHEN [WorkFlowEventType] = 'Month 4 BOT Update Completed'							AND ((WorkFlowEventDate_Skey BETWEEN 20110102 AND fca.SnapshotDate) OR (fca.SnapshotDate >= lnk_wfea.WorkFlowOriginalStartDate_Skey AND fca.SnapshotDate < lnk_wfea.WorkFlowEndDate_Skey)) THEN 1 ELSE 0 END) AS Month4BOTUpdateCompleted
	, MAX(CASE WHEN [WorkFlowEventType] = 'Month 4 update submitted to DWP'							AND ((WorkFlowEventDate_Skey BETWEEN 20110102 AND fca.SnapshotDate) OR (fca.SnapshotDate >= lnk_wfea.WorkFlowOriginalStartDate_Skey AND fca.SnapshotDate < lnk_wfea.WorkFlowEndDate_Skey)) THEN 1 ELSE 0 END) AS Month4updatesubmittedtoDWP
	, MAX(CASE WHEN [WorkFlowEventType] = 'Month 5 update outstanding'								AND ((WorkFlowEventDate_Skey BETWEEN 20110102 AND fca.SnapshotDate) OR (fca.SnapshotDate >= lnk_wfea.WorkFlowOriginalStartDate_Skey AND fca.SnapshotDate < lnk_wfea.WorkFlowEndDate_Skey)) THEN 1 ELSE 0 END) AS Month5updateoutstanding
	, MAX(CASE WHEN [WorkFlowEventType] = 'Month 5 update completed'								AND ((WorkFlowEventDate_Skey BETWEEN 20110102 AND fca.SnapshotDate) OR (fca.SnapshotDate >= lnk_wfea.WorkFlowOriginalStartDate_Skey AND fca.SnapshotDate < lnk_wfea.WorkFlowEndDate_Skey)) THEN 1 ELSE 0 END) AS Month5updatecompleted
	, MAX(CASE WHEN [WorkFlowEventType] = 'Month 5 BOT Update Completed'							AND ((WorkFlowEventDate_Skey BETWEEN 20110102 AND fca.SnapshotDate) OR (fca.SnapshotDate >= lnk_wfea.WorkFlowOriginalStartDate_Skey AND fca.SnapshotDate < lnk_wfea.WorkFlowEndDate_Skey)) THEN 1 ELSE 0 END) AS Month5BOTUpdateCompleted
	, MAX(CASE WHEN [WorkFlowEventType] = 'Month 5 update submitted to DWP'							AND ((WorkFlowEventDate_Skey BETWEEN 20110102 AND fca.SnapshotDate) OR (fca.SnapshotDate >= lnk_wfea.WorkFlowOriginalStartDate_Skey AND fca.SnapshotDate < lnk_wfea.WorkFlowEndDate_Skey)) THEN 1 ELSE 0 END) AS Month5updatesubmittedtoDWP
	, MAX(CASE WHEN [WorkFlowEventType] = 'Awaiting 6 Month Support Plan meeting scheduled'			AND ((WorkFlowEventDate_Skey BETWEEN 20110102 AND fca.SnapshotDate) OR (fca.SnapshotDate >= lnk_wfea.WorkFlowOriginalStartDate_Skey AND fca.SnapshotDate < lnk_wfea.WorkFlowEndDate_Skey)) THEN 1 ELSE 0 END) AS Awaiting6MonthSupportPlanmeetingscheduled
	, MAX(CASE WHEN [WorkFlowEventType] = 'Month 6 Support plan meeting scheduled'					AND ((WorkFlowEventDate_Skey BETWEEN 20110102 AND fca.SnapshotDate) OR (fca.SnapshotDate >= lnk_wfea.WorkFlowOriginalStartDate_Skey AND fca.SnapshotDate < lnk_wfea.WorkFlowEndDate_Skey)) THEN 1 ELSE 0 END) AS Month6Supportplanmeetingscheduled
	, MAX(CASE WHEN [WorkFlowEventType] = 'Month 6 Support plan meeting completed'					AND ((WorkFlowEventDate_Skey BETWEEN 20110102 AND fca.SnapshotDate) OR (fca.SnapshotDate >= lnk_wfea.WorkFlowOriginalStartDate_Skey AND fca.SnapshotDate < lnk_wfea.WorkFlowEndDate_Skey)) THEN 1 ELSE 0 END) AS Month6Supportplanmeetingcompleted
	, MAX(CASE WHEN [WorkFlowEventType] = 'Month 6 Support plan signed by customer'					AND ((WorkFlowEventDate_Skey BETWEEN 20110102 AND fca.SnapshotDate) OR (fca.SnapshotDate >= lnk_wfea.WorkFlowOriginalStartDate_Skey AND fca.SnapshotDate < lnk_wfea.WorkFlowEndDate_Skey)) THEN 1 ELSE 0 END) AS Month6Supportplansignedbycustomer
	, MAX(CASE WHEN [WorkFlowEventType] = 'Month 6 Support plan Uploaded'							AND ((WorkFlowEventDate_Skey BETWEEN 20110102 AND fca.SnapshotDate) OR (fca.SnapshotDate >= lnk_wfea.WorkFlowOriginalStartDate_Skey AND fca.SnapshotDate < lnk_wfea.WorkFlowEndDate_Skey)) THEN 1 ELSE 0 END) AS Month6SupportplanUploaded
	, MAX(CASE WHEN [WorkFlowEventType] = 'Month 6 Support plan completed but not submitted to DWP' AND ((WorkFlowEventDate_Skey BETWEEN 20110102 AND fca.SnapshotDate) OR (fca.SnapshotDate >= lnk_wfea.WorkFlowOriginalStartDate_Skey AND fca.SnapshotDate < lnk_wfea.WorkFlowEndDate_Skey)) THEN 1 ELSE 0 END) AS Month6SupportplancompletedbutnotsubmittedtoDWP
	, MAX(CASE WHEN [WorkFlowEventType] = 'Month 6 Support plan submitted to DWP'					AND ((WorkFlowEventDate_Skey BETWEEN 20110102 AND fca.SnapshotDate) OR (fca.SnapshotDate >= lnk_wfea.WorkFlowOriginalStartDate_Skey AND fca.SnapshotDate < lnk_wfea.WorkFlowEndDate_Skey)) THEN 1 ELSE 0 END) AS Month6SupportplansubmittedtoDWP
	, MAX(CASE WHEN [WorkFlowEventType] = 'Month 6 Support Plan Not Approved by DWP'				AND ((WorkFlowEventDate_Skey BETWEEN 20110102 AND fca.SnapshotDate) OR (fca.SnapshotDate >= lnk_wfea.WorkFlowOriginalStartDate_Skey AND fca.SnapshotDate < lnk_wfea.WorkFlowEndDate_Skey)) THEN 1 ELSE 0 END) AS Month6SupportPlanNotApprovedbyDWP
	, MAX(CASE WHEN [WorkFlowEventType] = 'Awaiting Month 6 Support Plan Re-Submission'				AND ((WorkFlowEventDate_Skey BETWEEN 20110102 AND fca.SnapshotDate) OR (fca.SnapshotDate >= lnk_wfea.WorkFlowOriginalStartDate_Skey AND fca.SnapshotDate < lnk_wfea.WorkFlowEndDate_Skey)) THEN 1 ELSE 0 END) AS AwaitingMonth6SupportPlanReSubmission
	, MAX(CASE WHEN [WorkFlowEventType] = 'Month 6 Support Plan Re-Submitted'						AND ((WorkFlowEventDate_Skey BETWEEN 20110102 AND fca.SnapshotDate) OR (fca.SnapshotDate >= lnk_wfea.WorkFlowOriginalStartDate_Skey AND fca.SnapshotDate < lnk_wfea.WorkFlowEndDate_Skey)) THEN 1 ELSE 0 END) AS Month6SupportPlanReSubmitted	  	
	, MAX(CASE WHEN [WorkFlowEventType] = 'Month 6 Support plan approved by DWP'					AND ((WorkFlowEventDate_Skey BETWEEN 20110102 AND fca.SnapshotDate) OR (fca.SnapshotDate >= lnk_wfea.WorkFlowOriginalStartDate_Skey AND fca.SnapshotDate < lnk_wfea.WorkFlowEndDate_Skey)) THEN 1 ELSE 0 END) AS Month6SupportplanapprovedbyDWP
	, MAX(CASE WHEN [WorkFlowEventType] = 'Month 6 Support plan paid by DWP'						AND ((WorkFlowEventDate_Skey BETWEEN 20110102 AND fca.SnapshotDate) OR (fca.SnapshotDate >= lnk_wfea.WorkFlowOriginalStartDate_Skey AND fca.SnapshotDate < lnk_wfea.WorkFlowEndDate_Skey)) THEN 1 ELSE 0 END) AS Month6SupportplanpaidbyDWP
	, MAX(CASE WHEN [WorkFlowEventType] = 'Awaiting Transfer To BSC'								AND ((WorkFlowEventDate_Skey BETWEEN 20110102 AND fca.SnapshotDate) OR (fca.SnapshotDate >= lnk_wfea.WorkFlowOriginalStartDate_Skey AND fca.SnapshotDate < lnk_wfea.WorkFlowEndDate_Skey)) THEN 1 ELSE 0 END) AS AwaitingTransferToBSC
	, MAX(CASE WHEN [WorkFlowEventType] = 'Transferred To BSC'										AND ((WorkFlowEventDate_Skey BETWEEN 20110102 AND fca.SnapshotDate) OR (fca.SnapshotDate >= lnk_wfea.WorkFlowOriginalStartDate_Skey AND fca.SnapshotDate < lnk_wfea.WorkFlowEndDate_Skey)) THEN 1 ELSE 0 END) AS TransferredToBSC
	, MAX(CASE WHEN [WorkFlowEventType] = 'Light Touch Email Sent - Unsuccessful'					AND ((WorkFlowEventDate_Skey BETWEEN 20110102 AND fca.SnapshotDate) OR (fca.SnapshotDate >= lnk_wfea.WorkFlowOriginalStartDate_Skey AND fca.SnapshotDate < lnk_wfea.WorkFlowEndDate_Skey)) THEN 1 ELSE 0 END) AS LightTouchEmailSentUnsuccessful
	, MAX(CASE WHEN [WorkFlowEventType] = 'Light Touch Email Sent - Successful'						AND ((WorkFlowEventDate_Skey BETWEEN 20110102 AND fca.SnapshotDate) OR (fca.SnapshotDate >= lnk_wfea.WorkFlowOriginalStartDate_Skey AND fca.SnapshotDate < lnk_wfea.WorkFlowEndDate_Skey)) THEN 1 ELSE 0 END) AS LightTouchEmailSentSuccessful
	, MAX(CASE WHEN [WorkFlowEventType] = 'Awaiting Month 7 Contact'								AND ((WorkFlowEventDate_Skey BETWEEN 20110102 AND fca.SnapshotDate) OR (fca.SnapshotDate >= lnk_wfea.WorkFlowOriginalStartDate_Skey AND fca.SnapshotDate < lnk_wfea.WorkFlowEndDate_Skey)) THEN 1 ELSE 0 END) AS AwaitingMonth7Contact
	, MAX(CASE WHEN [WorkFlowEventType] = 'Month 7 Contact Successful'								AND ((WorkFlowEventDate_Skey BETWEEN 20110102 AND fca.SnapshotDate) OR (fca.SnapshotDate >= lnk_wfea.WorkFlowOriginalStartDate_Skey AND fca.SnapshotDate < lnk_wfea.WorkFlowEndDate_Skey)) THEN 1 ELSE 0 END) AS Month7ContactSuccessful
	, MAX(CASE WHEN [WorkFlowEventType] = 'Month 7 Contact Unsuccessful'							AND ((WorkFlowEventDate_Skey BETWEEN 20110102 AND fca.SnapshotDate) OR (fca.SnapshotDate >= lnk_wfea.WorkFlowOriginalStartDate_Skey AND fca.SnapshotDate < lnk_wfea.WorkFlowEndDate_Skey)) THEN 1 ELSE 0 END) AS Month7ContactUnsuccessful
	, MAX(CASE WHEN [WorkFlowEventType] = 'Awaiting Month 8 Contact'								AND ((WorkFlowEventDate_Skey BETWEEN 20110102 AND fca.SnapshotDate) OR (fca.SnapshotDate >= lnk_wfea.WorkFlowOriginalStartDate_Skey AND fca.SnapshotDate < lnk_wfea.WorkFlowEndDate_Skey)) THEN 1 ELSE 0 END) AS AwaitingMonth8Contact
	, MAX(CASE WHEN [WorkFlowEventType] = 'Month 8 Contact Successful'								AND ((WorkFlowEventDate_Skey BETWEEN 20110102 AND fca.SnapshotDate) OR (fca.SnapshotDate >= lnk_wfea.WorkFlowOriginalStartDate_Skey AND fca.SnapshotDate < lnk_wfea.WorkFlowEndDate_Skey)) THEN 1 ELSE 0 END) AS Month8ContactSuccessful
	, MAX(CASE WHEN [WorkFlowEventType] = 'Month 8 Contact Unsuccessful'							AND ((WorkFlowEventDate_Skey BETWEEN 20110102 AND fca.SnapshotDate) OR (fca.SnapshotDate >= lnk_wfea.WorkFlowOriginalStartDate_Skey AND fca.SnapshotDate < lnk_wfea.WorkFlowEndDate_Skey)) THEN 1 ELSE 0 END) AS Month8ContactUnsuccessful
	, MAX(CASE WHEN [WorkFlowEventType] = 'Awaiting 9 Month Report meeting scheduled'				AND ((WorkFlowEventDate_Skey BETWEEN 20110102 AND fca.SnapshotDate) OR (fca.SnapshotDate >= lnk_wfea.WorkFlowOriginalStartDate_Skey AND fca.SnapshotDate < lnk_wfea.WorkFlowEndDate_Skey)) THEN 1 ELSE 0 END) AS Awaiting9MonthReportmeetingscheduled
	, MAX(CASE WHEN [WorkFlowEventType] = '9 Month Report meeting scheduled'						AND ((WorkFlowEventDate_Skey BETWEEN 20110102 AND fca.SnapshotDate) OR (fca.SnapshotDate >= lnk_wfea.WorkFlowOriginalStartDate_Skey AND fca.SnapshotDate < lnk_wfea.WorkFlowEndDate_Skey)) THEN 1 ELSE 0 END) AS NineMonthReportmeetingscheduled
	, MAX(CASE WHEN [WorkFlowEventType] = '9 Month Report meeting completed'						AND ((WorkFlowEventDate_Skey BETWEEN 20110102 AND fca.SnapshotDate) OR (fca.SnapshotDate >= lnk_wfea.WorkFlowOriginalStartDate_Skey AND fca.SnapshotDate < lnk_wfea.WorkFlowEndDate_Skey)) THEN 1 ELSE 0 END) AS NineMonthReportmeetingcompleted
	, MAX(CASE WHEN [WorkFlowEventType] = '9 Month Report signed by customer'						AND ((WorkFlowEventDate_Skey BETWEEN 20110102 AND fca.SnapshotDate) OR (fca.SnapshotDate >= lnk_wfea.WorkFlowOriginalStartDate_Skey AND fca.SnapshotDate < lnk_wfea.WorkFlowEndDate_Skey)) THEN 1 ELSE 0 END) AS NineMonthReportsignedbycustomer
	, MAX(CASE WHEN [WorkFlowEventType] = '9 Month Report Uploaded'									AND ((WorkFlowEventDate_Skey BETWEEN 20110102 AND fca.SnapshotDate) OR (fca.SnapshotDate >= lnk_wfea.WorkFlowOriginalStartDate_Skey AND fca.SnapshotDate < lnk_wfea.WorkFlowEndDate_Skey)) THEN 1 ELSE 0 END) AS NineMonthReportUploaded
	, MAX(CASE WHEN [WorkFlowEventType] = '9 Month Report completed but not submitted to DWP'		AND ((WorkFlowEventDate_Skey BETWEEN 20110102 AND fca.SnapshotDate) OR (fca.SnapshotDate >= lnk_wfea.WorkFlowOriginalStartDate_Skey AND fca.SnapshotDate < lnk_wfea.WorkFlowEndDate_Skey)) THEN 1 ELSE 0 END) AS NineMonthReportcompletedbutnotsubmittedtoDWP
	, MAX(CASE WHEN [WorkFlowEventType] = '9 Month Report submitted to DWP'							AND ((WorkFlowEventDate_Skey BETWEEN 20110102 AND fca.SnapshotDate) OR (fca.SnapshotDate >= lnk_wfea.WorkFlowOriginalStartDate_Skey AND fca.SnapshotDate < lnk_wfea.WorkFlowEndDate_Skey)) THEN 1 ELSE 0 END) AS NineMonthReportsubmittedtoDWP
	, MAX(CASE WHEN [WorkFlowEventType] = '9 Month Report Not Approved by DWP'						AND ((WorkFlowEventDate_Skey BETWEEN 20110102 AND fca.SnapshotDate) OR (fca.SnapshotDate >= lnk_wfea.WorkFlowOriginalStartDate_Skey AND fca.SnapshotDate < lnk_wfea.WorkFlowEndDate_Skey)) THEN 1 ELSE 0 END) AS NineMonthReportNotApprovedbyDWP
	, MAX(CASE WHEN [WorkFlowEventType] = 'Awaiting 9 Month Report Re-Submission'					AND ((WorkFlowEventDate_Skey BETWEEN 20110102 AND fca.SnapshotDate) OR (fca.SnapshotDate >= lnk_wfea.WorkFlowOriginalStartDate_Skey AND fca.SnapshotDate < lnk_wfea.WorkFlowEndDate_Skey)) THEN 1 ELSE 0 END) AS Awaiting9MonthReportReSubmission
	, MAX(CASE WHEN [WorkFlowEventType] = '9 Month Report Re-Submitted'								AND ((WorkFlowEventDate_Skey BETWEEN 20110102 AND fca.SnapshotDate) OR (fca.SnapshotDate >= lnk_wfea.WorkFlowOriginalStartDate_Skey AND fca.SnapshotDate < lnk_wfea.WorkFlowEndDate_Skey)) THEN 1 ELSE 0 END) AS NineMonthReportReSubmitted
	, MAX(CASE WHEN [WorkFlowEventType] = '9 Month Report approved by DWP'							AND ((WorkFlowEventDate_Skey BETWEEN 20110102 AND fca.SnapshotDate) OR (fca.SnapshotDate >= lnk_wfea.WorkFlowOriginalStartDate_Skey AND fca.SnapshotDate < lnk_wfea.WorkFlowEndDate_Skey)) THEN 1 ELSE 0 END) AS NineMonthReportapprovedbyDWP
	, MAX(CASE WHEN [WorkFlowEventType] = '9 Month Report paid by DWP'								AND ((WorkFlowEventDate_Skey BETWEEN 20110102 AND fca.SnapshotDate) OR (fca.SnapshotDate >= lnk_wfea.WorkFlowOriginalStartDate_Skey AND fca.SnapshotDate < lnk_wfea.WorkFlowEndDate_Skey)) THEN 1 ELSE 0 END) AS NineMonthReportpaidbyDWP
	, MAX(CASE WHEN [WorkFlowEventType] = 'Rejected'												AND ((WorkFlowEventDate_Skey BETWEEN 20110102 AND fca.SnapshotDate) OR (fca.SnapshotDate >= lnk_wfea.WorkFlowOriginalStartDate_Skey AND fca.SnapshotDate < lnk_wfea.WorkFlowEndDate_Skey)) THEN 1 ELSE 0 END) AS Rejected

	, MAX(CASE WHEN ([WorkFlowEventType] = 'Light Touch Email Sent - Unsuccessful'	AND ((WorkFlowEventDate_Skey BETWEEN 20110102 AND fca.SnapshotDate) OR (fca.SnapshotDate >= lnk_wfea.WorkFlowOriginalStartDate_Skey AND fca.SnapshotDate < lnk_wfea.WorkFlowEndDate_Skey)) ) OR (WorkFlowEventType = 'Light Touch Email Sent - Successful' AND ((WorkFlowEventDate_Skey BETWEEN 20110102 AND fca.SnapshotDate) OR (fca.SnapshotDate BETWEEN lnk_wfea.WorkFlowOriginalStartDate_Skey AND lnk_wfea.WorkFlowEndDate_Skey)))	THEN 1 ELSE 0 END)			   AS MarketingCampaignAttempted
	, MAX(CASE WHEN ([WorkFlowEventType] = 'Month 7 Contact Unsuccessful'			AND ((WorkFlowEventDate_Skey BETWEEN 20110102 AND fca.SnapshotDate) OR (fca.SnapshotDate >= lnk_wfea.WorkFlowOriginalStartDate_Skey AND fca.SnapshotDate < lnk_wfea.WorkFlowEndDate_Skey))) OR (WorkFlowEventType = 'Month 7 Contact Successful' AND ((WorkFlowEventDate_Skey BETWEEN 20110102 AND fca.SnapshotDate) OR (fca.SnapshotDate BETWEEN lnk_wfea.WorkFlowOriginalStartDate_Skey AND lnk_wfea.WorkFlowEndDate_Skey)))						THEN 1 ELSE 0 END) AS Month7ContactAttempted
	, MAX(CASE WHEN ([WorkFlowEventType] = 'Month 8 Contact Unsuccessful'			AND ((WorkFlowEventDate_Skey BETWEEN 20110102 AND fca.SnapshotDate) OR (fca.SnapshotDate >= lnk_wfea.WorkFlowOriginalStartDate_Skey AND fca.SnapshotDate < lnk_wfea.WorkFlowEndDate_Skey))) OR (WorkFlowEventType = 'Month 8 Contact Successful' AND ((WorkFlowEventDate_Skey BETWEEN 20110102 AND fca.SnapshotDate) OR (fca.SnapshotDate BETWEEN lnk_wfea.WorkFlowOriginalStartDate_Skey AND lnk_wfea.WorkFlowEndDate_Skey)))						THEN 1 ELSE 0 END) AS Month8ContactAttempted
	, MAX(CASE WHEN ([WorkFlowEventType] = 'Month 1 update completed'				AND ((WorkFlowEventDate_Skey BETWEEN 20110102 AND fca.SnapshotDate) OR (fca.SnapshotDate >= lnk_wfea.WorkFlowOriginalStartDate_Skey AND fca.SnapshotDate < lnk_wfea.WorkFlowEndDate_Skey))) OR (WorkFlowEventType = 'Month 1 BOT Update Completed' AND ((WorkFlowEventDate_Skey BETWEEN 20110102 AND fca.SnapshotDate) OR (fca.SnapshotDate BETWEEN lnk_wfea.WorkFlowOriginalStartDate_Skey AND lnk_wfea.WorkFlowEndDate_Skey)))						THEN 1 ELSE 0 END) AS Month1UpdateSuccessful
	, MAX(CASE WHEN ([WorkFlowEventType] = 'Month 2 update completed'				AND ((WorkFlowEventDate_Skey BETWEEN 20110102 AND fca.SnapshotDate) OR (fca.SnapshotDate >= lnk_wfea.WorkFlowOriginalStartDate_Skey AND fca.SnapshotDate < lnk_wfea.WorkFlowEndDate_Skey))) OR (WorkFlowEventType = 'Month 2 BOT Update Completed' AND ((WorkFlowEventDate_Skey BETWEEN 20110102 AND fca.SnapshotDate) OR (fca.SnapshotDate BETWEEN lnk_wfea.WorkFlowOriginalStartDate_Skey AND lnk_wfea.WorkFlowEndDate_Skey)))						THEN 1 ELSE 0 END) AS Month2UpdateSuccessful
	, MAX(CASE WHEN ([WorkFlowEventType] = 'Month 3 update completed'				AND ((WorkFlowEventDate_Skey BETWEEN 20110102 AND fca.SnapshotDate) OR (fca.SnapshotDate >= lnk_wfea.WorkFlowOriginalStartDate_Skey AND fca.SnapshotDate < lnk_wfea.WorkFlowEndDate_Skey))) OR (WorkFlowEventType = 'Month 3 BOT Update Completed' AND ((WorkFlowEventDate_Skey BETWEEN 20110102 AND fca.SnapshotDate) OR (fca.SnapshotDate BETWEEN lnk_wfea.WorkFlowOriginalStartDate_Skey AND lnk_wfea.WorkFlowEndDate_Skey)))						THEN 1 ELSE 0 END) AS Month3UpdateSuccessful
	, MAX(CASE WHEN ([WorkFlowEventType] = 'Month 4 update completed'				AND ((WorkFlowEventDate_Skey BETWEEN 20110102 AND fca.SnapshotDate) OR (fca.SnapshotDate >= lnk_wfea.WorkFlowOriginalStartDate_Skey AND fca.SnapshotDate < lnk_wfea.WorkFlowEndDate_Skey))) OR (WorkFlowEventType = 'Month 4 BOT Update Completed' AND ((WorkFlowEventDate_Skey BETWEEN 20110102 AND fca.SnapshotDate) OR (fca.SnapshotDate BETWEEN lnk_wfea.WorkFlowOriginalStartDate_Skey AND lnk_wfea.WorkFlowEndDate_Skey)))						THEN 1 ELSE 0 END) AS Month4UpdateSuccessful
	, MAX(CASE WHEN ([WorkFlowEventType] = 'Month 5 update completed'				AND ((WorkFlowEventDate_Skey BETWEEN 20110102 AND fca.SnapshotDate) OR (fca.SnapshotDate >= lnk_wfea.WorkFlowOriginalStartDate_Skey AND fca.SnapshotDate < lnk_wfea.WorkFlowEndDate_Skey))) OR (WorkFlowEventType = 'Month 5 BOT Update Completed' AND ((WorkFlowEventDate_Skey BETWEEN 20110102 AND fca.SnapshotDate) OR (fca.SnapshotDate BETWEEN lnk_wfea.WorkFlowOriginalStartDate_Skey AND lnk_wfea.WorkFlowEndDate_Skey)))						THEN 1 ELSE 0 END) AS Month5UpdateSuccessful

FROM stg.DW_F_AtW_Case_Daily_Analysis_TEMP fca
		INNER JOIN DW.LNK_Work_Flow_Event_Analysis lnk_wfea
			ON fca.Case_Analysis_Skey = lnk_wfea.Case_Analysis_Skey
		INNER JOIN DW.D_Work_Flow_Event_Type dw_d_wfet
			ON dw_d_wfet.Work_Flow_Event_Type_Skey = lnk_wfea.WorkFlowEventType_Skey
GROUP BY
	  SnapshotDate
	, fca.Case_Analysis_Skey
-- 
CREATE TABLE stg.DW_F_AtW_Case_Daily_Analysis_TEMP2
        WITH (distribution = hash(Case_Analysis_Skey), HEAP) 
AS

SELECT
	  ev.SnapshotDate
	, ev.Case_Analysis_Skey

	, MAX(NewEnquiry)										AS NewEnquiry
	, MAX(ReferralCallRequired)								AS ReferralCallRequired
	, MAX(ReferralCallBackAttempt1)							AS ReferralCallBackAttempt1
	, MAX(ReferralCallBackAttempt2)							AS ReferralCallBackAttempt2
	, MAX(ReferralCallBackAttempt3)							AS ReferralCallBackAttempt3
	, MAX(LiveEnquiry)										AS LiveEnquiry
	, MAX(UnsuccessfulEnquiry)								AS UnsuccessfulEnquiry
	, MAX(SuccessfulEnquiry)								AS SuccessfulEnquiry
	, MAX(AwaitingReferral)									AS AwaitingReferral
	, MAX(ReferralReceived)									AS ReferralReceived
	, MAX(EmailreferraltoDWP)								AS EmailreferraltoDWP
	, MAX(ReferralApproved)									AS ReferralApproved
	, MAX(ReferralUnsuccessful)								AS ReferralUnsuccessful
	, MAX(InitialContact)									AS InitialContact
	, MAX(AwaitingTelephoneAssessmentMeetingSchedule)		AS AwaitingTelephoneAssessmentMeetingSchedule
	, MAX(TelephoneAssessmentscheduled)						AS TelephoneAssessmentscheduled
	, MAX(TelephoneAssessmentCompleted)						AS TelephoneAssessmentCompleted
	, MAX(AwaitingSupportPlanmeetingscheduled)				AS AwaitingSupportPlanmeetingscheduled
	, MAX(Supportplanmeetingscheduled)						AS Supportplanmeetingscheduled
	, MAX(Supportplanmeetingcompleted)						AS Supportplanmeetingcompleted
	, MAX(Supportplansignedbycustomer)						AS Supportplansignedbycustomer
	, MAX(SupportplanUploaded)								AS SupportplanUploaded
	, MAX(SupportplancompletedbutnotsubmittedtoDWP)			AS SupportplancompletedbutnotsubmittedtoDWP
	, MAX(SupportplansubmittedtoDWP)						AS SupportplansubmittedtoDWP
	, MAX(SupportPlanNotApprovedbyDWP)						AS SupportPlanNotApprovedbyDWP
	, MAX(AwaitingSupportPlanReSubmission)					AS AwaitingSupportPlanReSubmission
	, MAX(SupportPlanReSubmitted)							AS SupportPlanReSubmitted
	, MAX(SupportplanapprovedbyDWP)							AS SupportplanapprovedbyDWP
	, MAX(SupportplanpaidbyDWP)								AS SupportplanpaidbyDWP
	, MAX(Month1updateoutstanding)							AS Month1updateoutstanding
	, MAX(Month1updatecompleted)							AS Month1updatecompleted
	, MAX(Month1BOTUpdateCompleted)							AS Month1BOTUpdateCompleted
	, MAX(Month1updatesubmittedtoDWP)						AS Month1updatesubmittedtoDWP
	, MAX(Month2updateoutstanding)							AS Month2updateoutstanding
	, MAX(Month2updatecompleted)							AS Month2updatecompleted
	, MAX(Month2BOTUpdateCompleted)							AS Month2BOTUpdateCompleted
	, MAX(Month2updatesubmittedtoDWP)						AS Month2updatesubmittedtoDWP
	, MAX(Month3updateoutstanding)							AS Month3updateoutstanding
	, MAX(Month3updatecompleted)							AS Month3updatecompleted
	, MAX(Month3BOTUpdateCompleted)							AS Month3BOTUpdateCompleted
	, MAX(Month3updatesubmittedtoDWP)						AS Month3updatesubmittedtoDWP
	, MAX(Month4updateoutstanding)							AS Month4updateoutstanding
	, MAX(Month4updatecompleted)							AS Month4updatecompleted
	, MAX(Month4BOTUpdateCompleted)							AS Month4BOTUpdateCompleted
	, MAX(Month4updatesubmittedtoDWP)						AS Month4updatesubmittedtoDWP
	, MAX(Month5updateoutstanding)							AS Month5updateoutstanding
	, MAX(Month5updatecompleted)							AS Month5updatecompleted
	, MAX(Month5BOTUpdateCompleted)							AS Month5BOTUpdateCompleted
	, MAX(Month5updatesubmittedtoDWP)						AS Month5updatesubmittedtoDWP
	, MAX(Awaiting6MonthSupportPlanmeetingscheduled)		AS Awaiting6MonthSupportPlanmeetingscheduled
	, MAX(Month6Supportplanmeetingscheduled)				AS Month6Supportplanmeetingscheduled
	, MAX(Month6Supportplanmeetingcompleted)				AS Month6Supportplanmeetingcompleted
	, MAX(Month6Supportplansignedbycustomer)				AS Month6Supportplansignedbycustomer
	, MAX(Month6SupportplanUploaded)						AS Month6SupportplanUploaded
	, MAX(Month6SupportplancompletedbutnotsubmittedtoDWP)	AS Month6SupportplancompletedbutnotsubmittedtoDWP
	, MAX(Month6SupportplansubmittedtoDWP)					AS Month6SupportplansubmittedtoDWP
	, MAX(Month6SupportPlanNotApprovedbyDWP)				AS Month6SupportPlanNotApprovedbyDWP
	, MAX(AwaitingMonth6SupportPlanReSubmission)			AS AwaitingMonth6SupportPlanReSubmission
	, MAX(Month6SupportPlanReSubmitted)						AS Month6SupportPlanReSubmitted
	, MAX(Month6SupportplanapprovedbyDWP)					AS Month6SupportplanapprovedbyDWP
	, MAX(Month6SupportplanpaidbyDWP)						AS Month6SupportplanpaidbyDWP
	, MAX(AwaitingTransferToBSC)							AS AwaitingTransferToBSC
	, MAX(TransferredToBSC)									AS TransferredToBSC
	, MAX(LightTouchEmailSentUnsuccessful)					AS LightTouchEmailSentUnsuccessful
	, MAX(LightTouchEmailSentSuccessful)					AS LightTouchEmailSentSuccessful
	, MAX(AwaitingMonth7Contact)							AS AwaitingMonth7Contact
	, MAX(Month7ContactSuccessful)							AS Month7ContactSuccessful
	, MAX(Month7ContactUnsuccessful)						AS Month7ContactUnsuccessful
	, MAX(AwaitingMonth8Contact)							AS AwaitingMonth8Contact
	, MAX(Month8ContactSuccessful)							AS Month8ContactSuccessful
	, MAX(Month8ContactUnsuccessful)						AS Month8ContactUnsuccessful
	, MAX(Awaiting9MonthReportmeetingscheduled)				AS Awaiting9MonthReportmeetingscheduled
	, MAX(NineMonthReportmeetingscheduled)					AS NineMonthReportmeetingscheduled
	, MAX(NineMonthReportmeetingcompleted)					AS NineMonthReportmeetingcompleted
	, MAX(NineMonthReportsignedbycustomer)					AS NineMonthReportsignedbycustomer
	, MAX(NineMonthReportUploaded)							AS NineMonthReportUploaded
	, MAX(NineMonthReportcompletedbutnotsubmittedtoDWP)		AS NineMonthReportcompletedbutnotsubmittedtoDWP
	, MAX(NineMonthReportsubmittedtoDWP)					AS NineMonthReportsubmittedtoDWP
	, MAX(NineMonthReportNotApprovedbyDWP)					AS NineMonthReportNotApprovedbyDWP
	, MAX(Awaiting9MonthReportReSubmission)					AS Awaiting9MonthReportReSubmission
	, MAX(NineMonthReportReSubmitted)						AS NineMonthReportReSubmitted	
	, MAX(NineMonthReportapprovedbyDWP)						AS NineMonthReportapprovedbyDWP
	, MAX(NineMonthReportpaidbyDWP)							AS NineMonthReportpaidbyDWP
	, MAX(Rejected)											AS Rejected

	, MAX(MarketingCampaignAttempted)						AS MarketingCampaignAttempted
	, MAX(Month7ContactAttempted)							AS Month7ContactAttempted
	, MAX(Month8ContactAttempted)							AS Month8ContactAttempted
	, MAX(Month1UpdateSuccessful)							AS Month1UpdateSuccessful
	, MAX(Month2UpdateSuccessful)							AS Month2UpdateSuccessful
	, MAX(Month3UpdateSuccessful)							AS Month3UpdateSuccessful
	, MAX(Month4UpdateSuccessful)							AS Month4UpdateSuccessful
	, MAX(Month5UpdateSuccessful)							AS Month5UpdateSuccessful

	--Completed Within SLA
	, MAX(CASE WHEN ev.NewEnquiry = 1										AND [WorkFlowEventType] = 'New Enquiry'												AND WorkFlowEventDate_Skey <= WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS NewEnquiryCompletedWithinSLA
	, MAX(CASE WHEN ev.ReferralCallRequired = 1								AND [WorkFlowEventType] = 'Referral call required'									AND WorkFlowEventDate_Skey <= WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS ReferralCallRequiredCompletedWithinSLA
	, MAX(CASE WHEN ev.ReferralCallBackAttempt1 = 1							AND [WorkFlowEventType] = 'Referral call back - Attempt 1'							AND WorkFlowEventDate_Skey <= WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS ReferralCallBackAttempt1CompletedWithinSLA
	, MAX(CASE WHEN ev.ReferralCallBackAttempt2 = 1							AND [WorkFlowEventType] = 'Referral call back - Attempt 2'							AND WorkFlowEventDate_Skey <= WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS ReferralCallBackAttempt2CompletedWithinSLA
	, MAX(CASE WHEN ev.ReferralCallBackAttempt3 = 1							AND [WorkFlowEventType] = 'Referral call back - Attempt 3'							AND WorkFlowEventDate_Skey <= WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS ReferralCallBackAttempt3CompletedWithinSLA
	, MAX(CASE WHEN ev.LiveEnquiry = 1										AND [WorkFlowEventType] = 'Live Enquiry'											AND WorkFlowEventDate_Skey <= WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS LiveEnquiryCompletedWithinSLA
	, MAX(CASE WHEN ev.UnsuccessfulEnquiry = 1								AND [WorkFlowEventType] = 'Unsuccessful Enquiry'									AND WorkFlowEventDate_Skey <= WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS UnsuccessfulEnquiryCompletedWithinSLA
	, MAX(CASE WHEN ev.SuccessfulEnquiry = 1								AND [WorkFlowEventType] = 'Successful Enquiry'										AND WorkFlowEventDate_Skey <= WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS SuccessfulEnquiryCompletedWithinSLA
	, MAX(CASE WHEN ev.AwaitingReferral = 1									AND [WorkFlowEventType] = 'Awaiting Referral'										AND WorkFlowEventDate_Skey <= WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS AwaitingReferralCompletedWithinSLA
	, MAX(CASE WHEN ev.ReferralReceived = 1									AND [WorkFlowEventType] = 'Referral Received'										AND WorkFlowEventDate_Skey <= WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS ReferralReceivedCompletedWithinSLA
	, MAX(CASE WHEN ev.EmailreferraltoDWP = 1								AND [WorkFlowEventType] = 'Email referral to DWP'									AND WorkFlowEventDate_Skey <= WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS EmailreferraltoDWPCompletedWithinSLA
	, MAX(CASE WHEN ev.ReferralApproved = 1									AND [WorkFlowEventType] = 'Referral Approved'										AND WorkFlowEventDate_Skey <= WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS ReferralApprovedCompletedWithinSLA
	, MAX(CASE WHEN ev.ReferralUnsuccessful = 1								AND [WorkFlowEventType] = 'Referral Unsuccessful'									AND WorkFlowEventDate_Skey <= WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS ReferralUnsuccessfulCompletedWithinSLA
	, MAX(CASE WHEN ev.InitialContact = 1									AND [WorkFlowEventType] = 'Initial Contact'											AND WorkFlowEventDate_Skey <= WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS InitialContactCompletedWithinSLA
	, MAX(CASE WHEN ev.AwaitingTelephoneAssessmentMeetingSchedule = 1		AND [WorkFlowEventType] = 'Awaiting Telephone Assessment Meeting Schedule'			AND WorkFlowEventDate_Skey <= WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS AwaitingTelephoneAssessmentMeetingScheduleCompletedWithinSLA
	, MAX(CASE WHEN ev.TelephoneAssessmentscheduled = 1						AND [WorkFlowEventType] = 'Telephone Assessment scheduled'							AND WorkFlowEventDate_Skey <= WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS TelephoneAssessmentscheduledCompletedWithinSLA
	, MAX(CASE WHEN ev.TelephoneAssessmentCompleted = 1						AND [WorkFlowEventType] = 'Telephone Assessment Completed'							AND WorkFlowEventDate_Skey <= WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS TelephoneAssessmentCompletedCompletedWithinSLA
	, MAX(CASE WHEN ev.AwaitingSupportPlanmeetingscheduled = 1				AND [WorkFlowEventType] = 'Awaiting Support Plan meeting scheduled'					AND WorkFlowEventDate_Skey <= WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS AwaitingSupportPlanmeetingscheduledCompletedWithinSLA
	, MAX(CASE WHEN ev.Supportplanmeetingscheduled = 1						AND [WorkFlowEventType] = 'Support plan meeting scheduled'							AND WorkFlowEventDate_Skey <= WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS SupportplanmeetingscheduledCompletedWithinSLA
	, MAX(CASE WHEN ev.Supportplanmeetingcompleted = 1						AND [WorkFlowEventType] = 'Support plan meeting completed'							AND WorkFlowEventDate_Skey <= WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS SupportplanmeetingcompletedCompletedWithinSLA
	, MAX(CASE WHEN ev.Supportplansignedbycustomer = 1						AND [WorkFlowEventType] = 'Support plan signed by customer'							AND WorkFlowEventDate_Skey <= WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS SupportplansignedbycustomerCompletedWithinSLA
	, MAX(CASE WHEN ev.SupportplanUploaded = 1								AND [WorkFlowEventType] = 'Support plan Uploaded'									AND WorkFlowEventDate_Skey <= WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS SupportplanUploadedCompletedWithinSLA
	, MAX(CASE WHEN ev.SupportplancompletedbutnotsubmittedtoDWP = 1			AND [WorkFlowEventType] = 'Support plan completed but not submitted to DWP'			AND WorkFlowEventDate_Skey <= WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS SupportplancompletedbutnotsubmittedtoDWPCompletedWithinSLA
	, MAX(CASE WHEN ev.SupportplansubmittedtoDWP = 1						AND [WorkFlowEventType] = 'Support plan submitted to DWP'							AND WorkFlowEventDate_Skey <= WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS SupportplansubmittedtoDWPCompletedWithinSLA
	, MAX(CASE WHEN ev.SupportPlanNotApprovedbyDWP = 1						AND [WorkFlowEventType] = 'Support Plan Not Approved by DWP'						AND WorkFlowEventDate_Skey <= WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS SupportPlanNotApprovedbyDWPCompletedWithinSLA
	, MAX(CASE WHEN ev.AwaitingSupportPlanReSubmission = 1					AND [WorkFlowEventType] = 'Awaiting Support Plan Re-Submission'						AND WorkFlowEventDate_Skey <= WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS AwaitingSupportPlanReSubmissionCompletedWithinSLA
	, MAX(CASE WHEN ev.SupportPlanReSubmitted = 1							AND [WorkFlowEventType] = 'Support Plan Re-Submitted'								AND WorkFlowEventDate_Skey <= WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS SupportPlanReSubmittedCompletedWithinSLA	
	, MAX(CASE WHEN ev.SupportplanapprovedbyDWP = 1							AND [WorkFlowEventType] = 'Support plan approved by DWP'							AND WorkFlowEventDate_Skey <= WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS SupportplanapprovedbyDWPCompletedWithinSLA
	, MAX(CASE WHEN ev.SupportplanpaidbyDWP = 1								AND [WorkFlowEventType] = 'Support plan paid by DWP'								AND WorkFlowEventDate_Skey <= WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS SupportplanpaidbyDWPCompletedWithinSLA
	, MAX(CASE WHEN ev.Month1updateoutstanding = 1							AND [WorkFlowEventType] = 'Month 1 update outstanding'								AND WorkFlowEventDate_Skey <= WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS Month1updateoutstandingCompletedWithinSLA
	, MAX(CASE WHEN ev.Month1updatecompleted = 1							AND [WorkFlowEventType] = 'Month 1 update completed'								AND WorkFlowEventDate_Skey <= WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS Month1updatecompletedCompletedWithinSLA
	, MAX(CASE WHEN ev.Month1BOTUpdateCompleted = 1							AND [WorkFlowEventType] = 'Month 1 BOT Update Completed'							AND WorkFlowEventDate_Skey <= WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS Month1BOTUpdateCompletedCompletedWithinSLA
	, MAX(CASE WHEN ev.Month1updatesubmittedtoDWP = 1						AND [WorkFlowEventType] = 'Month 1 update submitted to DWP'							AND WorkFlowEventDate_Skey <= WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS Month1updatesubmittedtoDWPCompletedWithinSLA
	, MAX(CASE WHEN ev.Month2updateoutstanding = 1							AND [WorkFlowEventType] = 'Month 2 update outstanding'								AND WorkFlowEventDate_Skey <= WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS Month2updateoutstandingCompletedWithinSLA
	, MAX(CASE WHEN ev.Month2updatecompleted = 1							AND [WorkFlowEventType] = 'Month 2 update completed'								AND WorkFlowEventDate_Skey <= WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS Month2updatecompletedCompletedWithinSLA
	, MAX(CASE WHEN ev.Month2BOTUpdateCompleted = 1							AND [WorkFlowEventType] = 'Month 2 BOT Update Completed'							AND WorkFlowEventDate_Skey <= WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS Month2BOTUpdateCompletedCompletedWithinSLA
	, MAX(CASE WHEN ev.Month2updatesubmittedtoDWP = 1						AND [WorkFlowEventType] = 'Month 2 update submitted to DWP'							AND WorkFlowEventDate_Skey <= WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS Month2updatesubmittedtoDWPCompletedWithinSLA
	, MAX(CASE WHEN ev.Month3updateoutstanding = 1							AND [WorkFlowEventType] = 'Month 3 update outstanding'								AND WorkFlowEventDate_Skey <= WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS Month3updateoutstandingCompletedWithinSLA
	, MAX(CASE WHEN ev.Month3updatecompleted = 1							AND [WorkFlowEventType] = 'Month 3 update completed'								AND WorkFlowEventDate_Skey <= WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS Month3updatecompletedCompletedWithinSLA
	, MAX(CASE WHEN ev.Month3BOTUpdateCompleted = 1							AND [WorkFlowEventType] = 'Month 3 BOT Update Completed'							AND WorkFlowEventDate_Skey <= WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS Month3BOTUpdateCompletedCompletedWithinSLA
	, MAX(CASE WHEN ev.Month3updatesubmittedtoDWP = 1						AND [WorkFlowEventType] = 'Month 3 update submitted to DWP'							AND WorkFlowEventDate_Skey <= WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS Month3updatesubmittedtoDWPCompletedWithinSLA
	, MAX(CASE WHEN ev.Month4updateoutstanding = 1							AND [WorkFlowEventType] = 'Month 4 update outstanding'								AND WorkFlowEventDate_Skey <= WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS Month4updateoutstandingCompletedWithinSLA
	, MAX(CASE WHEN ev.Month4updatecompleted = 1							AND [WorkFlowEventType] = 'Month 4 update completed'								AND WorkFlowEventDate_Skey <= WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS Month4updatecompletedCompletedWithinSLA
	, MAX(CASE WHEN ev.Month4BOTUpdateCompleted = 1							AND [WorkFlowEventType] = 'Month 4 BOT Update Completed'							AND WorkFlowEventDate_Skey <= WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS Month4BOTUpdateCompletedCompletedWithinSLA
	, MAX(CASE WHEN ev.Month4updatesubmittedtoDWP = 1						AND [WorkFlowEventType] = 'Month 4 update submitted to DWP'							AND WorkFlowEventDate_Skey <= WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS Month4updatesubmittedtoDWPCompletedWithinSLA
	, MAX(CASE WHEN ev.Month5updateoutstanding = 1							AND [WorkFlowEventType] = 'Month 5 update outstanding'								AND WorkFlowEventDate_Skey <= WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS Month5updateoutstandingCompletedWithinSLA
	, MAX(CASE WHEN ev.Month5updatecompleted = 1							AND [WorkFlowEventType] = 'Month 5 update completed'								AND WorkFlowEventDate_Skey <= WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS Month5updatecompletedCompletedWithinSLA
	, MAX(CASE WHEN ev.Month5BOTUpdateCompleted = 1							AND [WorkFlowEventType] = 'Month 5 BOT Update Completed'							AND WorkFlowEventDate_Skey <= WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS Month5BOTUpdateCompletedCompletedWithinSLA
	, MAX(CASE WHEN ev.Month5updatesubmittedtoDWP = 1						AND [WorkFlowEventType] = 'Month 5 update submitted to DWP'							AND WorkFlowEventDate_Skey <= WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS Month5updatesubmittedtoDWPCompletedWithinSLA
	, MAX(CASE WHEN ev.Awaiting6MonthSupportPlanmeetingscheduled = 1		AND [WorkFlowEventType] = 'Awaiting 6 Month Support Plan meeting scheduled'			AND WorkFlowEventDate_Skey <= WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS Awaiting6MonthSupportPlanmeetingscheduledCompletedWithinSLA
	, MAX(CASE WHEN ev.Month6Supportplanmeetingscheduled = 1				AND [WorkFlowEventType] = 'Month 6 Support plan meeting scheduled'					AND WorkFlowEventDate_Skey <= WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS Month6SupportplanmeetingscheduledCompletedWithinSLA
	, MAX(CASE WHEN ev.Month6Supportplanmeetingcompleted = 1				AND [WorkFlowEventType] = 'Month 6 Support plan meeting completed'					AND WorkFlowEventDate_Skey <= WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS Month6SupportplanmeetingcompletedCompletedWithinSLA
	, MAX(CASE WHEN ev.Month6Supportplansignedbycustomer = 1				AND [WorkFlowEventType] = 'Month 6 Support plan signed by customer'					AND WorkFlowEventDate_Skey <= WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS Month6SupportplansignedbycustomerCompletedWithinSLA
	, MAX(CASE WHEN ev.Month6SupportplanUploaded = 1						AND [WorkFlowEventType] = 'Month 6 Support plan Uploaded'							AND WorkFlowEventDate_Skey <= WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS Month6SupportplanUploadedCompletedWithinSLA
	, MAX(CASE WHEN ev.Month6SupportplancompletedbutnotsubmittedtoDWP = 1	AND [WorkFlowEventType] = 'Month 6 Support plan completed but not submitted to DWP' AND WorkFlowEventDate_Skey <= WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS Month6SupportplancompletedbutnotsubmittedtoDWPCompletedWithinSLA
	, MAX(CASE WHEN ev.Month6SupportplansubmittedtoDWP = 1					AND [WorkFlowEventType] = 'Month 6 Support plan submitted to DWP'					AND WorkFlowEventDate_Skey <= WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS Month6SupportplansubmittedtoDWPCompletedWithinSLA
	, MAX(CASE WHEN ev.Month6SupportPlanNotApprovedbyDWP = 1				AND [WorkFlowEventType] = 'Month 6 Support Plan Not Approved by DWP'				AND WorkFlowEventDate_Skey <= WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS Month6SupportPlanNotApprovedbyDWPCompletedWithinSLA
	, MAX(CASE WHEN ev.AwaitingMonth6SupportPlanReSubmission = 1			AND [WorkFlowEventType] = 'Awaiting Month 6 Support Plan Re-Submission'				AND WorkFlowEventDate_Skey <= WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS AwaitingMonth6SupportPlanReSubmissionCompletedWithinSLA
	, MAX(CASE WHEN ev.Month6SupportPlanReSubmitted = 1						AND [WorkFlowEventType] = 'Month 6 Support Plan Re-Submitted'						AND WorkFlowEventDate_Skey <= WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS Month6SupportPlanReSubmittedCompletedWithinSLA
	, MAX(CASE WHEN ev.Month6SupportplanapprovedbyDWP = 1					AND [WorkFlowEventType] = 'Month 6 Support plan approved by DWP'					AND WorkFlowEventDate_Skey <= WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS Month6SupportplanapprovedbyDWPCompletedWithinSLA
	, MAX(CASE WHEN ev.Month6SupportplanpaidbyDWP = 1						AND [WorkFlowEventType] = 'Month 6 Support plan paid by DWP'						AND WorkFlowEventDate_Skey <= WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS Month6SupportplanpaidbyDWPCompletedWithinSLA
	, MAX(CASE WHEN ev.AwaitingTransferToBSC = 1							AND [WorkFlowEventType] = 'Awaiting Transfer To BSC'								AND WorkFlowEventDate_Skey <= WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS AwaitingTransferToBSCCompletedWithinSLA
	, MAX(CASE WHEN ev.TransferredToBSC = 1									AND [WorkFlowEventType] = 'Transferred To BSC'										AND WorkFlowEventDate_Skey <= WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS TransferredToBSCCompletedWithinSLA
	, MAX(CASE WHEN ev.LightTouchEmailSentUnsuccessful = 1					AND [WorkFlowEventType] = 'Light Touch Email Sent - Unsuccessful'					AND WorkFlowEventDate_Skey <= WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS LightTouchEmailSentUnsuccessfulCompletedWithinSLA
	, MAX(CASE WHEN ev.LightTouchEmailSentSuccessful = 1					AND [WorkFlowEventType] = 'Light Touch Email Sent - Successful'						AND WorkFlowEventDate_Skey <= WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS LightTouchEmailSentSuccessfulCompletedWithinSLA
	, MAX(CASE WHEN ev.AwaitingMonth7Contact = 1							AND [WorkFlowEventType] = 'Awaiting Month 7 Contact'								AND WorkFlowEventDate_Skey <= WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS AwaitingMonth7ContactCompletedWithinSLA
	, MAX(CASE WHEN ev.Month7ContactSuccessful = 1							AND [WorkFlowEventType] = 'Month 7 Contact Successful'								AND WorkFlowEventDate_Skey <= WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS Month7ContactSuccessfulCompletedWithinSLA
	, MAX(CASE WHEN ev.Month7ContactUnsuccessful = 1						AND [WorkFlowEventType] = 'Month 7 Contact Unsuccessful'							AND WorkFlowEventDate_Skey <= WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS Month7ContactUnsuccessfulCompletedWithinSLA
	, MAX(CASE WHEN ev.AwaitingMonth8Contact = 1							AND [WorkFlowEventType] = 'Awaiting Month 8 Contact'								AND WorkFlowEventDate_Skey <= WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS AwaitingMonth8ContactCompletedWithinSLA
	, MAX(CASE WHEN ev.Month8ContactSuccessful = 1							AND [WorkFlowEventType] = 'Month 8 Contact Successful'								AND WorkFlowEventDate_Skey <= WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS Month8ContactSuccessfulCompletedWithinSLA
	, MAX(CASE WHEN ev.Month8ContactUnsuccessful = 1						AND [WorkFlowEventType] = 'Month 8 Contact Unsuccessful'							AND WorkFlowEventDate_Skey <= WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS Month8ContactUnsuccessfulCompletedWithinSLA
	, MAX(CASE WHEN ev.Awaiting9MonthReportmeetingscheduled = 1				AND [WorkFlowEventType] = 'Awaiting 9 Month Report meeting scheduled'				AND WorkFlowEventDate_Skey <= WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS Awaiting9MonthReportmeetingscheduledCompletedWithinSLA
	, MAX(CASE WHEN ev.NineMonthReportmeetingscheduled = 1					AND [WorkFlowEventType] = '9 Month Report meeting scheduled'						AND WorkFlowEventDate_Skey <= WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS NineMonthReportmeetingscheduledCompletedWithinSLA
	, MAX(CASE WHEN ev.NineMonthReportmeetingcompleted = 1					AND [WorkFlowEventType] = '9 Month Report meeting completed'						AND WorkFlowEventDate_Skey <= WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS NineMonthReportmeetingcompletedCompletedWithinSLA
	, MAX(CASE WHEN ev.NineMonthReportsignedbycustomer = 1					AND [WorkFlowEventType] = '9 Month Report signed by customer'						AND WorkFlowEventDate_Skey <= WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS NineMonthReportsignedbycustomerCompletedWithinSLA
	, MAX(CASE WHEN ev.NineMonthReportUploaded = 1							AND [WorkFlowEventType] = '9 Month Report Uploaded'									AND	WorkFlowEventDate_Skey <= WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS NineMonthReportUploadedCompletedWithinSLA
	, MAX(CASE WHEN ev.NineMonthReportcompletedbutnotsubmittedtoDWP = 1		AND [WorkFlowEventType] = '9 Month Report completed but not submitted to DWP'		AND WorkFlowEventDate_Skey <= WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS NineMonthReportcompletedbutnotsubmittedtoDWPCompletedWithinSLA
	, MAX(CASE WHEN ev.NineMonthReportsubmittedtoDWP = 1					AND [WorkFlowEventType] = '9 Month Report submitted to DWP'							AND WorkFlowEventDate_Skey <= WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS NineMonthReportsubmittedtoDWPCompletedWithinSLA
	, MAX(CASE WHEN ev.NineMonthReportNotApprovedbyDWP = 1					AND [WorkFlowEventType] = '9 Month Report Not Approved by DWP'						AND WorkFlowEventDate_Skey <= WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS NineMonthReportNotApprovedbyDWPCompletedWithinSLA
	, MAX(CASE WHEN ev.Awaiting9MonthReportReSubmission = 1					AND [WorkFlowEventType] = 'Awaiting 9 Month Report Re-Submission'					AND WorkFlowEventDate_Skey <= WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS Awaiting9MonthReportReSubmissionCompletedWithinSLA
	, MAX(CASE WHEN ev.NineMonthReportReSubmitted = 1						AND [WorkFlowEventType] = '9 Month Report Re-Submitted'								AND WorkFlowEventDate_Skey <= WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS NineMonthReportReSubmittedCompletedWithinSLA
	, MAX(CASE WHEN ev.NineMonthReportapprovedbyDWP = 1						AND [WorkFlowEventType] = '9 Month Report approved by DWP'							AND WorkFlowEventDate_Skey <= WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS NineMonthReportapprovedbyDWPCompletedWithinSLA
	, MAX(CASE WHEN ev.NineMonthReportpaidbyDWP = 1							AND [WorkFlowEventType] = '9 Month Report paid by DWP'								AND WorkFlowEventDate_Skey <= WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS NineMonthReportpaidbyDWPCompletedWithinSLA
	, MAX(CASE WHEN ev.Rejected = 1											AND [WorkFlowEventType] = 'Rejected'												AND WorkFlowEventDate_Skey <= WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS RejectedCompletedWithinSLA

	, MAX(CASE WHEN ev.MarketingCampaignAttempted	= 1	AND ([WorkFlowEventType] = 'Light Touch Email Sent - Unsuccessful'	AND WorkFlowEventDate_Skey <= WorkFlowEstimatedEndDate_Skey	) 	OR 	(WorkFlowEventType = 'Light Touch Email Sent - Successful'	AND	WorkFlowEventDate_Skey <= WorkFlowEstimatedEndDate_Skey	)	THEN 1 ELSE 0 END)	AS MarketingCampaignAttemptedCompletedWithinSLA
	, MAX(CASE WHEN ev.Month7ContactAttempted		= 1	AND ([WorkFlowEventType] = 'Month 7 Contact Unsuccessful'			AND WorkFlowEventDate_Skey <= WorkFlowEstimatedEndDate_Skey	)	OR 	(WorkFlowEventType = 'Month 7 Contact Successful'			AND	WorkFlowEventDate_Skey <= WorkFlowEstimatedEndDate_Skey	)	THEN 1 ELSE 0 END)	AS Month7ContactAttemptedCompletedWithinSLA
	, MAX(CASE WHEN ev.Month8ContactAttempted		= 1	AND ([WorkFlowEventType] = 'Month 8 Contact Unsuccessful'			AND WorkFlowEventDate_Skey <= WorkFlowEstimatedEndDate_Skey	)	OR 	(WorkFlowEventType = 'Month 8 Contact Successful'			AND	WorkFlowEventDate_Skey <= WorkFlowEstimatedEndDate_Skey	)	THEN 1 ELSE 0 END)	AS Month8ContactAttemptedCompletedWithinSLA
	, MAX(CASE WHEN ev.Month1UpdateSuccessful		= 1	AND ([WorkFlowEventType] = 'Month 1 update completed'				AND WorkFlowEventDate_Skey <= WorkFlowEstimatedEndDate_Skey	)	OR 	(WorkFlowEventType = 'Month 1 BOT Update Completed'			AND	WorkFlowEventDate_Skey <= WorkFlowEstimatedEndDate_Skey	)	THEN 1 ELSE 0 END)	AS Month1UpdateSuccessfulCompletedWithinSLA
	, MAX(CASE WHEN ev.Month2UpdateSuccessful		= 1	AND ([WorkFlowEventType] = 'Month 2 update completed'				AND WorkFlowEventDate_Skey <= WorkFlowEstimatedEndDate_Skey	)	OR 	(WorkFlowEventType = 'Month 2 BOT Update Completed'			AND	WorkFlowEventDate_Skey <= WorkFlowEstimatedEndDate_Skey	)	THEN 1 ELSE 0 END)	AS Month2UpdateSuccessfulCompletedWithinSLA
	, MAX(CASE WHEN ev.Month3UpdateSuccessful		= 1	AND ([WorkFlowEventType] = 'Month 3 update completed'				AND WorkFlowEventDate_Skey <= WorkFlowEstimatedEndDate_Skey	)	OR 	(WorkFlowEventType = 'Month 3 BOT Update Completed'			AND	WorkFlowEventDate_Skey <= WorkFlowEstimatedEndDate_Skey	)	THEN 1 ELSE 0 END)	AS Month3UpdateSuccessfulCompletedWithinSLA
	, MAX(CASE WHEN ev.Month4UpdateSuccessful		= 1	AND ([WorkFlowEventType] = 'Month 4 update completed'				AND WorkFlowEventDate_Skey <= WorkFlowEstimatedEndDate_Skey	)	OR 	(WorkFlowEventType = 'Month 4 BOT Update Completed'			AND	WorkFlowEventDate_Skey <= WorkFlowEstimatedEndDate_Skey	)	THEN 1 ELSE 0 END)	AS Month4UpdateSuccessfulCompletedWithinSLA
	, MAX(CASE WHEN ev.Month5UpdateSuccessful		= 1	AND ([WorkFlowEventType] = 'Month 5 update completed'				AND WorkFlowEventDate_Skey <= WorkFlowEstimatedEndDate_Skey	)	OR 	(WorkFlowEventType = 'Month 5 BOT Update Completed'			AND	WorkFlowEventDate_Skey <= WorkFlowEstimatedEndDate_Skey	)	THEN 1 ELSE 0 END)	AS Month5UpdateSuccessfulCompletedWithinSLA

	--CompletedOutsideSLA
	, MAX(CASE WHEN ev.NewEnquiry = 1										AND [WorkFlowEventType] = 'New Enquiry'												AND WorkFlowEventDate_Skey > WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS NewEnquiryOutsideSLA
	, MAX(CASE WHEN ev.ReferralCallRequired = 1								AND [WorkFlowEventType] = 'Referral call required'									AND WorkFlowEventDate_Skey > WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS ReferralCallRequiredOutsideSLA
	, MAX(CASE WHEN ev.ReferralCallBackAttempt1 = 1							AND [WorkFlowEventType] = 'Referral call back - Attempt 1'							AND WorkFlowEventDate_Skey > WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS ReferralCallBackAttempt1OutsideSLA
	, MAX(CASE WHEN ev.ReferralCallBackAttempt2 = 1							AND [WorkFlowEventType] = 'Referral call back - Attempt 2'							AND WorkFlowEventDate_Skey > WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS ReferralCallBackAttempt2OutsideSLA
	, MAX(CASE WHEN ev.ReferralCallBackAttempt3 = 1							AND [WorkFlowEventType] = 'Referral call back - Attempt 3'							AND WorkFlowEventDate_Skey > WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS ReferralCallBackAttempt3OutsideSLA
	, MAX(CASE WHEN ev.LiveEnquiry = 1										AND [WorkFlowEventType] = 'Live Enquiry'											AND WorkFlowEventDate_Skey > WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS LiveEnquiryOutsideSLA
	, MAX(CASE WHEN ev.UnsuccessfulEnquiry = 1								AND [WorkFlowEventType] = 'Unsuccessful Enquiry'									AND WorkFlowEventDate_Skey > WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS UnsuccessfulEnquiryOutsideSLA
	, MAX(CASE WHEN ev.SuccessfulEnquiry = 1								AND [WorkFlowEventType] = 'Successful Enquiry'										AND WorkFlowEventDate_Skey > WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS SuccessfulEnquiryOutsideSLA
	, MAX(CASE WHEN ev.AwaitingReferral = 1									AND [WorkFlowEventType] = 'Awaiting Referral'										AND WorkFlowEventDate_Skey > WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS AwaitingReferralOutsideSLA
	, MAX(CASE WHEN ev.ReferralReceived = 1									AND [WorkFlowEventType] = 'Referral Received'										AND WorkFlowEventDate_Skey > WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS ReferralReceivedOutsideSLA
	, MAX(CASE WHEN ev.EmailreferraltoDWP = 1								AND [WorkFlowEventType] = 'Email referral to DWP'									AND WorkFlowEventDate_Skey > WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS EmailreferraltoDWPOutsideSLA
	, MAX(CASE WHEN ev.ReferralApproved = 1									AND [WorkFlowEventType] = 'Referral Approved'										AND WorkFlowEventDate_Skey > WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS ReferralApprovedOutsideSLA
	, MAX(CASE WHEN ev.ReferralUnsuccessful = 1								AND [WorkFlowEventType] = 'Referral Unsuccessful'									AND WorkFlowEventDate_Skey > WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS ReferralUnsuccessfulOutsideSLA
	, MAX(CASE WHEN ev.InitialContact = 1									AND [WorkFlowEventType] = 'Initial Contact'											AND WorkFlowEventDate_Skey > WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS InitialContactOutsideSLA
	, MAX(CASE WHEN ev.AwaitingTelephoneAssessmentMeetingSchedule = 1		AND [WorkFlowEventType] = 'Awaiting Telephone Assessment Meeting Schedule'			AND WorkFlowEventDate_Skey > WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS AwaitingTelephoneAssessmentMeetingScheduleOutsideSLA
	, MAX(CASE WHEN ev.TelephoneAssessmentscheduled = 1						AND [WorkFlowEventType] = 'Telephone Assessment scheduled'							AND WorkFlowEventDate_Skey > WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS TelephoneAssessmentscheduledOutsideSLA
	, MAX(CASE WHEN ev.TelephoneAssessmentCompleted = 1						AND [WorkFlowEventType] = 'Telephone Assessment Completed'							AND WorkFlowEventDate_Skey > WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS TelephoneAssessmentCompletedOutsideSLA
	, MAX(CASE WHEN ev.AwaitingSupportPlanmeetingscheduled = 1				AND [WorkFlowEventType] = 'Awaiting Support Plan meeting scheduled'					AND WorkFlowEventDate_Skey > WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS AwaitingSupportPlanmeetingscheduledOutsideSLA
	, MAX(CASE WHEN ev.Supportplanmeetingscheduled = 1						AND [WorkFlowEventType] = 'Support plan meeting scheduled'							AND WorkFlowEventDate_Skey > WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS SupportplanmeetingscheduledOutsideSLA
	, MAX(CASE WHEN ev.Supportplanmeetingcompleted = 1						AND [WorkFlowEventType] = 'Support plan meeting completed'							AND WorkFlowEventDate_Skey > WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS SupportplanmeetingcompletedOutsideSLA
	, MAX(CASE WHEN ev.Supportplansignedbycustomer = 1						AND [WorkFlowEventType] = 'Support plan signed by customer'							AND WorkFlowEventDate_Skey > WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS SupportplansignedbycustomerOutsideSLA
	, MAX(CASE WHEN ev.SupportplanUploaded = 1								AND [WorkFlowEventType] = 'Support plan Uploaded'									AND WorkFlowEventDate_Skey > WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS SupportplanUploadedOutsideSLA
	, MAX(CASE WHEN ev.SupportplancompletedbutnotsubmittedtoDWP = 1			AND [WorkFlowEventType] = 'Support plan completed but not submitted to DWP'			AND WorkFlowEventDate_Skey > WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS SupportplancompletedbutnotsubmittedtoDWPOutsideSLA
	, MAX(CASE WHEN ev.SupportplansubmittedtoDWP = 1						AND [WorkFlowEventType] = 'Support plan submitted to DWP'							AND WorkFlowEventDate_Skey > WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS SupportplansubmittedtoDWPOutsideSLA	
	, MAX(CASE WHEN ev.SupportPlanNotApprovedbyDWP = 1						AND [WorkFlowEventType] = 'Support Plan Not Approved by DWP'						AND WorkFlowEventDate_Skey > WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS SupportPlanNotApprovedbyDWPOutsideSLA
	, MAX(CASE WHEN ev.AwaitingSupportPlanReSubmission = 1					AND [WorkFlowEventType] = 'Awaiting Support Plan Re-Submission'						AND WorkFlowEventDate_Skey > WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS AwaitingSupportPlanReSubmissionOutsideSLA
	, MAX(CASE WHEN ev.SupportPlanReSubmitted = 1							AND [WorkFlowEventType] = 'Support Plan Re-Submitted'								AND WorkFlowEventDate_Skey > WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS SupportPlanReSubmittedOutsideSLA
	, MAX(CASE WHEN ev.SupportplanapprovedbyDWP = 1							AND [WorkFlowEventType] = 'Support plan approved by DWP'							AND WorkFlowEventDate_Skey > WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS SupportplanapprovedbyDWPOutsideSLA
	, MAX(CASE WHEN ev.SupportplanpaidbyDWP = 1								AND [WorkFlowEventType] = 'Support plan paid by DWP'								AND WorkFlowEventDate_Skey > WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS SupportplanpaidbyDWPOutsideSLA
	, MAX(CASE WHEN ev.Month1updateoutstanding = 1							AND [WorkFlowEventType] = 'Month 1 update outstanding'								AND WorkFlowEventDate_Skey > WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS Month1updateoutstandingOutsideSLA
	, MAX(CASE WHEN ev.Month1updatecompleted = 1							AND [WorkFlowEventType] = 'Month 1 update completed'								AND WorkFlowEventDate_Skey > WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS Month1updatecompletedOutsideSLA
	, MAX(CASE WHEN ev.Month1BOTUpdateCompleted = 1							AND [WorkFlowEventType] = 'Month 1 BOT Update Completed'							AND WorkFlowEventDate_Skey > WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS Month1BOTUpdateCompletedOutsideSLA
	, MAX(CASE WHEN ev.Month1updatesubmittedtoDWP = 1						AND [WorkFlowEventType] = 'Month 1 update submitted to DWP'							AND WorkFlowEventDate_Skey > WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS Month1updatesubmittedtoDWPOutsideSLA
	, MAX(CASE WHEN ev.Month2updateoutstanding = 1							AND [WorkFlowEventType] = 'Month 2 update outstanding'								AND WorkFlowEventDate_Skey > WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS Month2updateoutstandingOutsideSLA
	, MAX(CASE WHEN ev.Month2updatecompleted = 1							AND [WorkFlowEventType] = 'Month 2 update completed'								AND WorkFlowEventDate_Skey > WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS Month2updatecompletedOutsideSLA
	, MAX(CASE WHEN ev.Month2BOTUpdateCompleted = 1							AND [WorkFlowEventType] = 'Month 2 BOT Update Completed'							AND WorkFlowEventDate_Skey > WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS Month2BOTUpdateCompletedOutsideSLA
	, MAX(CASE WHEN ev.Month2updatesubmittedtoDWP = 1						AND [WorkFlowEventType] = 'Month 2 update submitted to DWP'							AND WorkFlowEventDate_Skey > WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS Month2updatesubmittedtoDWPOutsideSLA
	, MAX(CASE WHEN ev.Month3updateoutstanding = 1							AND [WorkFlowEventType] = 'Month 3 update outstanding'								AND WorkFlowEventDate_Skey > WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS Month3updateoutstandingOutsideSLA
	, MAX(CASE WHEN ev.Month3updatecompleted = 1							AND [WorkFlowEventType] = 'Month 3 update completed'								AND WorkFlowEventDate_Skey > WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS Month3updatecompletedOutsideSLA
	, MAX(CASE WHEN ev.Month3BOTUpdateCompleted = 1							AND [WorkFlowEventType] = 'Month 3 BOT Update Completed'							AND WorkFlowEventDate_Skey > WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS Month3BOTUpdateCompletedOutsideSLA
	, MAX(CASE WHEN ev.Month3updatesubmittedtoDWP = 1						AND [WorkFlowEventType] = 'Month 3 update submitted to DWP'							AND WorkFlowEventDate_Skey > WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS Month3updatesubmittedtoDWPOutsideSLA
	, MAX(CASE WHEN ev.Month4updateoutstanding = 1							AND [WorkFlowEventType] = 'Month 4 update outstanding'								AND WorkFlowEventDate_Skey > WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS Month4updateoutstandingOutsideSLA
	, MAX(CASE WHEN ev.Month4updatecompleted = 1							AND [WorkFlowEventType] = 'Month 4 update completed'								AND WorkFlowEventDate_Skey > WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS Month4updatecompletedOutsideSLA
	, MAX(CASE WHEN ev.Month4BOTUpdateCompleted = 1							AND [WorkFlowEventType] = 'Month 4 BOT Update Completed'							AND WorkFlowEventDate_Skey > WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS Month4BOTUpdateCompletedOutsideSLA
	, MAX(CASE WHEN ev.Month4updatesubmittedtoDWP = 1						AND [WorkFlowEventType] = 'Month 4 update submitted to DWP'							AND WorkFlowEventDate_Skey > WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS Month4updatesubmittedtoDWPOutsideSLA
	, MAX(CASE WHEN ev.Month5updateoutstanding = 1							AND [WorkFlowEventType] = 'Month 5 update outstanding'								AND WorkFlowEventDate_Skey > WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS Month5updateoutstandingOutsideSLA
	, MAX(CASE WHEN ev.Month5updatecompleted = 1							AND [WorkFlowEventType] = 'Month 5 update completed'								AND WorkFlowEventDate_Skey > WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS Month5updatecompletedOutsideSLA
	, MAX(CASE WHEN ev.Month5BOTUpdateCompleted = 1							AND [WorkFlowEventType] = 'Month 5 BOT Update Completed'							AND WorkFlowEventDate_Skey > WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS Month5BOTUpdateCompletedOutsideSLA
	, MAX(CASE WHEN ev.Month5updatesubmittedtoDWP = 1						AND [WorkFlowEventType] = 'Month 5 update submitted to DWP'							AND WorkFlowEventDate_Skey > WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS Month5updatesubmittedtoDWPOutsideSLA
	, MAX(CASE WHEN ev.Awaiting6MonthSupportPlanmeetingscheduled = 1		AND [WorkFlowEventType] = 'Awaiting 6 Month Support Plan meeting scheduled'			AND WorkFlowEventDate_Skey > WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS Awaiting6MonthSupportPlanmeetingscheduledOutsideSLA
	, MAX(CASE WHEN ev.Month6Supportplanmeetingscheduled = 1				AND [WorkFlowEventType] = 'Month 6 Support plan meeting scheduled'					AND WorkFlowEventDate_Skey > WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS Month6SupportplanmeetingscheduledOutsideSLA
	, MAX(CASE WHEN ev.Month6Supportplanmeetingcompleted = 1				AND [WorkFlowEventType] = 'Month 6 Support plan meeting completed'					AND WorkFlowEventDate_Skey > WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS Month6SupportplanmeetingcompletedOutsideSLA
	, MAX(CASE WHEN ev.Month6Supportplansignedbycustomer = 1				AND [WorkFlowEventType] = 'Month 6 Support plan signed by customer'					AND WorkFlowEventDate_Skey > WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS Month6SupportplansignedbycustomerOutsideSLA
	, MAX(CASE WHEN ev.Month6SupportplanUploaded = 1						AND [WorkFlowEventType] = 'Month 6 Support plan Uploaded'							AND WorkFlowEventDate_Skey > WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS Month6SupportplanUploadedOutsideSLA
	, MAX(CASE WHEN ev.Month6SupportplancompletedbutnotsubmittedtoDWP = 1	AND [WorkFlowEventType] = 'Month 6 Support plan completed but not submitted to DWP' AND WorkFlowEventDate_Skey > WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS Month6SupportplancompletedbutnotsubmittedtoDWPOutsideSLA
	, MAX(CASE WHEN ev.Month6SupportplansubmittedtoDWP = 1					AND [WorkFlowEventType] = 'Month 6 Support plan submitted to DWP'					AND WorkFlowEventDate_Skey > WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS Month6SupportplansubmittedtoDWPOutsideSLA
	, MAX(CASE WHEN ev.Month6SupportPlanNotApprovedbyDWP = 1				AND [WorkFlowEventType] = 'Month 6 Support Plan Not Approved by DWP'				AND WorkFlowEventDate_Skey > WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS Month6SupportPlanNotApprovedbyDWPOutsideSLA
	, MAX(CASE WHEN ev.AwaitingMonth6SupportPlanReSubmission = 1			AND [WorkFlowEventType] = 'Awaiting Month 6 Support Plan Re-Submission'				AND WorkFlowEventDate_Skey > WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS AwaitingMonth6SupportPlanReSubmissionOutsideSLA
	, MAX(CASE WHEN ev.Month6SupportPlanReSubmitted = 1						AND [WorkFlowEventType] = 'Month 6 Support Plan Re-Submitted'						AND WorkFlowEventDate_Skey > WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS Month6SupportPlanReSubmittedOutsideSLA
	, MAX(CASE WHEN ev.Month6SupportplanapprovedbyDWP = 1					AND [WorkFlowEventType] = 'Month 6 Support plan approved by DWP'					AND WorkFlowEventDate_Skey > WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS Month6SupportplanapprovedbyDWPOutsideSLA
	, MAX(CASE WHEN ev.Month6SupportplanpaidbyDWP = 1						AND [WorkFlowEventType] = 'Month 6 Support plan paid by DWP'						AND WorkFlowEventDate_Skey > WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS Month6SupportplanpaidbyDWPOutsideSLA
	, MAX(CASE WHEN ev.AwaitingTransferToBSC = 1							AND [WorkFlowEventType] = 'Awaiting Transfer To BSC'								AND WorkFlowEventDate_Skey > WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS AwaitingTransferToBSCOutsideSLA
	, MAX(CASE WHEN ev.TransferredToBSC = 1									AND [WorkFlowEventType] = 'Transferred To BSC'										AND WorkFlowEventDate_Skey > WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS TransferredToBSCOutsideSLA
	, MAX(CASE WHEN ev.LightTouchEmailSentUnsuccessful = 1					AND [WorkFlowEventType] = 'Light Touch Email Sent - Unsuccessful'					AND WorkFlowEventDate_Skey > WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS LightTouchEmailSentUnsuccessfulOutsideSLA
	, MAX(CASE WHEN ev.LightTouchEmailSentSuccessful = 1					AND [WorkFlowEventType] = 'Light Touch Email Sent - Successful'						AND WorkFlowEventDate_Skey > WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS LightTouchEmailSentSuccessfulOutsideSLA
	, MAX(CASE WHEN ev.AwaitingMonth7Contact = 1							AND [WorkFlowEventType] = 'Awaiting Month 7 Contact'								AND WorkFlowEventDate_Skey > WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS AwaitingMonth7ContactOutsideSLA
	, MAX(CASE WHEN ev.Month7ContactSuccessful = 1							AND [WorkFlowEventType] = 'Month 7 Contact Successful'								AND WorkFlowEventDate_Skey > WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS Month7ContactSuccessfulOutsideSLA
	, MAX(CASE WHEN ev.Month7ContactUnsuccessful = 1						AND [WorkFlowEventType] = 'Month 7 Contact Unsuccessful'							AND WorkFlowEventDate_Skey > WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS Month7ContactUnsuccessfulOutsideSLA
	, MAX(CASE WHEN ev.AwaitingMonth8Contact = 1							AND [WorkFlowEventType] = 'Awaiting Month 8 Contact'								AND WorkFlowEventDate_Skey > WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS AwaitingMonth8ContactOutsideSLA
	, MAX(CASE WHEN ev.Month8ContactSuccessful = 1							AND [WorkFlowEventType] = 'Month 8 Contact Successful'								AND WorkFlowEventDate_Skey > WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS Month8ContactSuccessfulOutsideSLA
	, MAX(CASE WHEN ev.Month8ContactUnsuccessful = 1						AND [WorkFlowEventType] = 'Month 8 Contact Unsuccessful'							AND WorkFlowEventDate_Skey > WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS Month8ContactUnsuccessfulOutsideSLA
	, MAX(CASE WHEN ev.Awaiting9MonthReportmeetingscheduled = 1				AND [WorkFlowEventType] = 'Awaiting 9 Month Report meeting scheduled'				AND WorkFlowEventDate_Skey > WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS Awaiting9MonthReportmeetingscheduledOutsideSLA
	, MAX(CASE WHEN ev.NineMonthReportmeetingscheduled = 1					AND [WorkFlowEventType] = '9 Month Report meeting scheduled'						AND WorkFlowEventDate_Skey > WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS NineMonthReportmeetingscheduledOutsideSLA
	, MAX(CASE WHEN ev.NineMonthReportmeetingcompleted = 1					AND [WorkFlowEventType] = '9 Month Report meeting completed'						AND WorkFlowEventDate_Skey > WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS NineMonthReportmeetingcompletedOutsideSLA
	, MAX(CASE WHEN ev.NineMonthReportsignedbycustomer = 1					AND [WorkFlowEventType] = '9 Month Report signed by customer'						AND WorkFlowEventDate_Skey > WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS NineMonthReportsignedbycustomerOutsideSLA
	, MAX(CASE WHEN ev.NineMonthReportUploaded = 1							AND [WorkFlowEventType] = '9 Month Report Uploaded'									AND	WorkFlowEventDate_Skey > WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS NineMonthReportUploadedOutsideSLA
	, MAX(CASE WHEN ev.NineMonthReportcompletedbutnotsubmittedtoDWP = 1		AND [WorkFlowEventType] = '9 Month Report completed but not submitted to DWP'		AND WorkFlowEventDate_Skey > WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS NineMonthReportcompletedbutnotsubmittedtoDWPOutsideSLA
	, MAX(CASE WHEN ev.NineMonthReportsubmittedtoDWP = 1					AND [WorkFlowEventType] = '9 Month Report submitted to DWP'							AND WorkFlowEventDate_Skey > WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS NineMonthReportsubmittedtoDWPOutsideSLA
	, MAX(CASE WHEN ev.NineMonthReportNotApprovedbyDWP = 1					AND [WorkFlowEventType] = '9 Month Report Not Approved by DWP'						AND WorkFlowEventDate_Skey > WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS NineMonthReportNotApprovedbyDWPOutsideSLA
	, MAX(CASE WHEN ev.Awaiting9MonthReportReSubmission = 1					AND [WorkFlowEventType] = 'Awaiting 9 Month Report Re-Submission'					AND WorkFlowEventDate_Skey > WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS Awaiting9MonthReportReSubmissionOutsideSLA
	, MAX(CASE WHEN ev.NineMonthReportReSubmitted = 1						AND [WorkFlowEventType] = '9 Month Report Re-Submitted'								AND WorkFlowEventDate_Skey > WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS NineMonthReportReSubmittedOutsideSLA	
	, MAX(CASE WHEN ev.NineMonthReportapprovedbyDWP = 1						AND [WorkFlowEventType] = '9 Month Report approved by DWP'							AND WorkFlowEventDate_Skey > WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS NineMonthReportapprovedbyDWPOutsideSLA
	, MAX(CASE WHEN ev.NineMonthReportpaidbyDWP = 1							AND [WorkFlowEventType] = '9 Month Report paid by DWP'								AND WorkFlowEventDate_Skey > WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS NineMonthReportpaidbyDWPOutsideSLA
	, MAX(CASE WHEN ev.Rejected = 1											AND [WorkFlowEventType] = 'Rejected'												AND WorkFlowEventDate_Skey > WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS RejectedOutsideSLA

	, MAX(CASE WHEN ev.MarketingCampaignAttempted	= 1						AND ([WorkFlowEventType] = 'Light Touch Email Sent - Unsuccessful'					AND WorkFlowEventDate_Skey > WorkFlowEstimatedEndDate_Skey	) 	OR 	(WorkFlowEventType = 'Light Touch Email Sent - Successful'	AND	WorkFlowEventDate_Skey > WorkFlowEstimatedEndDate_Skey	)	THEN 1 ELSE 0 END)	AS MarketingCampaignAttemptedCompletedOutsideSLA
	, MAX(CASE WHEN ev.Month7ContactAttempted		= 1						AND ([WorkFlowEventType] = 'Month 7 Contact Unsuccessful'							AND WorkFlowEventDate_Skey > WorkFlowEstimatedEndDate_Skey	)	OR 	(WorkFlowEventType = 'Month 7 Contact Successful'			AND	WorkFlowEventDate_Skey > WorkFlowEstimatedEndDate_Skey	)	THEN 1 ELSE 0 END)	AS Month7ContactAttemptedCompletedOutsideSLA
	, MAX(CASE WHEN ev.Month8ContactAttempted		= 1						AND ([WorkFlowEventType] = 'Month 8 Contact Unsuccessful'							AND WorkFlowEventDate_Skey > WorkFlowEstimatedEndDate_Skey	)	OR 	(WorkFlowEventType = 'Month 8 Contact Successful'			AND	WorkFlowEventDate_Skey > WorkFlowEstimatedEndDate_Skey	)	THEN 1 ELSE 0 END)	AS Month8ContactAttemptedCompletedOutsideSLA
	, MAX(CASE WHEN ev.Month1UpdateSuccessful		= 1						AND ([WorkFlowEventType] = 'Month 1 update completed'								AND WorkFlowEventDate_Skey > WorkFlowEstimatedEndDate_Skey	)	OR 	(WorkFlowEventType = 'Month 1 BOT Update Completed'			AND	WorkFlowEventDate_Skey > WorkFlowEstimatedEndDate_Skey	)	THEN 1 ELSE 0 END)	AS Month1UpdateSuccessfulCompletedOutsideSLA
	, MAX(CASE WHEN ev.Month2UpdateSuccessful		= 1						AND ([WorkFlowEventType] = 'Month 2 update completed'								AND WorkFlowEventDate_Skey > WorkFlowEstimatedEndDate_Skey	)	OR 	(WorkFlowEventType = 'Month 2 BOT Update Completed'			AND	WorkFlowEventDate_Skey > WorkFlowEstimatedEndDate_Skey	)	THEN 1 ELSE 0 END)	AS Month2UpdateSuccessfulCompletedOutsideSLA
	, MAX(CASE WHEN ev.Month3UpdateSuccessful		= 1						AND ([WorkFlowEventType] = 'Month 3 update completed'								AND WorkFlowEventDate_Skey > WorkFlowEstimatedEndDate_Skey	)	OR 	(WorkFlowEventType = 'Month 3 BOT Update Completed'			AND	WorkFlowEventDate_Skey > WorkFlowEstimatedEndDate_Skey	)	THEN 1 ELSE 0 END)	AS Month3UpdateSuccessfulCompletedOutsideSLA
	, MAX(CASE WHEN ev.Month4UpdateSuccessful		= 1						AND ([WorkFlowEventType] = 'Month 4 update completed'								AND WorkFlowEventDate_Skey > WorkFlowEstimatedEndDate_Skey	)	OR 	(WorkFlowEventType = 'Month 4 BOT Update Completed'			AND	WorkFlowEventDate_Skey > WorkFlowEstimatedEndDate_Skey	)	THEN 1 ELSE 0 END)	AS Month4UpdateSuccessfulCompletedOutsideSLA
	, MAX(CASE WHEN ev.Month5UpdateSuccessful		= 1						AND ([WorkFlowEventType] = 'Month 5 update completed'								AND WorkFlowEventDate_Skey > WorkFlowEstimatedEndDate_Skey	)	OR 	(WorkFlowEventType = 'Month 5 BOT Update Completed'			AND	WorkFlowEventDate_Skey > WorkFlowEstimatedEndDate_Skey	)	THEN 1 ELSE 0 END)	AS Month5UpdateSuccessfulCompletedOutsideSLA

	--Overdue
	, MAX(CASE WHEN ev.NewEnquiry = 0										AND [WorkFlowEventType] = 'New Enquiry'												AND SnapshotDate > WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS NewEnquiryOverdue
	, MAX(CASE WHEN ev.ReferralCallRequired = 0								AND [WorkFlowEventType] = 'Referral call required'									AND SnapshotDate > WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS ReferralCallRequiredOverdue
	, MAX(CASE WHEN ev.ReferralCallBackAttempt1 = 0							AND [WorkFlowEventType] = 'Referral call back - Attempt 1'							AND SnapshotDate > WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS ReferralCallBackAttempt1Overdue
	, MAX(CASE WHEN ev.ReferralCallBackAttempt2 = 0							AND [WorkFlowEventType] = 'Referral call back - Attempt 2'							AND SnapshotDate > WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS ReferralCallBackAttempt2Overdue
	, MAX(CASE WHEN ev.ReferralCallBackAttempt3 = 0							AND [WorkFlowEventType] = 'Referral call back - Attempt 3'							AND SnapshotDate > WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS ReferralCallBackAttempt3Overdue
	, MAX(CASE WHEN ev.LiveEnquiry = 0										AND [WorkFlowEventType] = 'Live Enquiry'											AND SnapshotDate > WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS LiveEnquiryOverdue
	, MAX(CASE WHEN ev.UnsuccessfulEnquiry = 0								AND [WorkFlowEventType] = 'Unsuccessful Enquiry'									AND SnapshotDate > WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS UnsuccessfulEnquiryOverdue
	, MAX(CASE WHEN ev.SuccessfulEnquiry = 0								AND [WorkFlowEventType] = 'Successful Enquiry'										AND SnapshotDate > WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS SuccessfulEnquiryOverdue
	, MAX(CASE WHEN ev.AwaitingReferral = 0									AND [WorkFlowEventType] = 'Awaiting Referral'										AND SnapshotDate > WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS AwaitingReferralOverdue
	, MAX(CASE WHEN ev.ReferralReceived = 0									AND [WorkFlowEventType] = 'Referral Received'										AND SnapshotDate > WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS ReferralReceivedOverdue
	, MAX(CASE WHEN ev.EmailreferraltoDWP = 0								AND [WorkFlowEventType] = 'Email referral to DWP'									AND SnapshotDate > WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS EmailreferraltoDWPOverdue
	, MAX(CASE WHEN ev.ReferralApproved = 0									AND [WorkFlowEventType] = 'Referral Approved'										AND SnapshotDate > WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS ReferralApprovedOverdue
	, MAX(CASE WHEN ev.ReferralUnsuccessful = 0								AND [WorkFlowEventType] = 'Referral Unsuccessful'									AND SnapshotDate > WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS ReferralUnsuccessfulOverdue
	, MAX(CASE WHEN ev.InitialContact = 0									AND [WorkFlowEventType] = 'Initial Contact'											AND SnapshotDate > WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS InitialContactOverdue
	, MAX(CASE WHEN ev.AwaitingTelephoneAssessmentMeetingSchedule = 0		AND [WorkFlowEventType] = 'Awaiting Telephone Assessment Meeting Schedule'			AND SnapshotDate > WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS AwaitingTelephoneAssessmentMeetingScheduleOverdue
	, MAX(CASE WHEN ev.TelephoneAssessmentscheduled = 0						AND [WorkFlowEventType] = 'Telephone Assessment scheduled'							AND SnapshotDate > WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS TelephoneAssessmentscheduledOverdue
	, MAX(CASE WHEN ev.TelephoneAssessmentCompleted = 0						AND [WorkFlowEventType] = 'Telephone Assessment Completed'							AND SnapshotDate > WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS TelephoneAssessmentCompletedOverdue
	, MAX(CASE WHEN ev.AwaitingSupportPlanmeetingscheduled = 0				AND [WorkFlowEventType] = 'Awaiting Support Plan meeting scheduled'					AND SnapshotDate > WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS AwaitingSupportPlanmeetingscheduledOverdue
	, MAX(CASE WHEN ev.Supportplanmeetingscheduled = 0						AND [WorkFlowEventType] = 'Support plan meeting scheduled'							AND SnapshotDate > WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS SupportplanmeetingscheduledOverdue
	, MAX(CASE WHEN ev.Supportplanmeetingcompleted = 0						AND [WorkFlowEventType] = 'Support plan meeting completed'							AND SnapshotDate > WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS SupportplanmeetingcompletedOverdue
	, MAX(CASE WHEN ev.Supportplansignedbycustomer = 0						AND [WorkFlowEventType] = 'Support plan signed by customer'							AND SnapshotDate > WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS SupportplansignedbycustomerOverdue
	, MAX(CASE WHEN ev.SupportplanUploaded = 0								AND [WorkFlowEventType] = 'Support plan Uploaded'									AND SnapshotDate > WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS SupportplanUploadedOverdue
	, MAX(CASE WHEN ev.SupportplancompletedbutnotsubmittedtoDWP = 0			AND [WorkFlowEventType] = 'Support plan completed but not submitted to DWP'			AND SnapshotDate > WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS SupportplancompletedbutnotsubmittedtoDWPOverdue
	, MAX(CASE WHEN ev.SupportplansubmittedtoDWP = 0						AND [WorkFlowEventType] = 'Support plan submitted to DWP'							AND SnapshotDate > WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS SupportplansubmittedtoDWPOverdue
	, MAX(CASE WHEN ev.SupportPlanNotApprovedbyDWP = 0						AND [WorkFlowEventType] = 'Support Plan Not Approved by DWP'						AND SnapshotDate > WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS SupportPlanNotApprovedbyDWPOverdue
	, MAX(CASE WHEN ev.AwaitingSupportPlanReSubmission = 0					AND [WorkFlowEventType] = 'Awaiting Support Plan Re-Submission'						AND SnapshotDate > WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS AwaitingSupportPlanReSubmissionOverdue
	, MAX(CASE WHEN ev.SupportPlanReSubmitted = 0							AND [WorkFlowEventType] = 'Support Plan Re-Submitted'								AND SnapshotDate > WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS SupportPlanReSubmittedOverdue
	, MAX(CASE WHEN ev.SupportplanapprovedbyDWP = 0							AND [WorkFlowEventType] = 'Support plan approved by DWP'							AND SnapshotDate > WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS SupportplanapprovedbyDWPOverdue
	, MAX(CASE WHEN ev.SupportplanpaidbyDWP = 0								AND [WorkFlowEventType] = 'Support plan paid by DWP'								AND SnapshotDate > WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS SupportplanpaidbyDWPOverdue
	, MAX(CASE WHEN ev.Month1updateoutstanding = 0							AND [WorkFlowEventType] = 'Month 1 update outstanding'								AND SnapshotDate > WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS Month1updateoutstandingOverdue
	, MAX(CASE WHEN ev.Month1updatecompleted = 0							AND [WorkFlowEventType] = 'Month 1 update completed'								AND SnapshotDate > WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS Month1updatecompletedOverdue
	, MAX(CASE WHEN ev.Month1BOTUpdateCompleted = 0							AND [WorkFlowEventType] = 'Month 1 BOT Update Completed'							AND SnapshotDate > WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS Month1BOTUpdateCompletedOverdue
	, MAX(CASE WHEN ev.Month1updatesubmittedtoDWP = 0						AND [WorkFlowEventType] = 'Month 1 update submitted to DWP'							AND SnapshotDate > WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS Month1updatesubmittedtoDWPOverdue
	, MAX(CASE WHEN ev.Month2updateoutstanding = 0							AND [WorkFlowEventType] = 'Month 2 update outstanding'								AND SnapshotDate > WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS Month2updateoutstandingOverdue
	, MAX(CASE WHEN ev.Month2updatecompleted = 0							AND [WorkFlowEventType] = 'Month 2 update completed'								AND SnapshotDate > WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS Month2updatecompletedOverdue
	, MAX(CASE WHEN ev.Month2BOTUpdateCompleted = 0							AND [WorkFlowEventType] = 'Month 2 BOT Update Completed'							AND SnapshotDate > WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS Month2BOTUpdateCompletedOverdue
	, MAX(CASE WHEN ev.Month2updatesubmittedtoDWP = 0						AND [WorkFlowEventType] = 'Month 2 update submitted to DWP'							AND SnapshotDate > WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS Month2updatesubmittedtoDWPOverdue
	, MAX(CASE WHEN ev.Month3updateoutstanding = 0							AND [WorkFlowEventType] = 'Month 3 update outstanding'								AND SnapshotDate > WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS Month3updateoutstandingOverdue
	, MAX(CASE WHEN ev.Month3updatecompleted = 0							AND [WorkFlowEventType] = 'Month 3 update completed'								AND SnapshotDate > WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS Month3updatecompletedOverdue
	, MAX(CASE WHEN ev.Month3BOTUpdateCompleted = 0							AND [WorkFlowEventType] = 'Month 3 BOT Update Completed'							AND SnapshotDate > WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS Month3BOTUpdateCompletedOverdue
	, MAX(CASE WHEN ev.Month3updatesubmittedtoDWP = 0						AND [WorkFlowEventType] = 'Month 3 update submitted to DWP'							AND SnapshotDate > WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS Month3updatesubmittedtoDWPOverdue
	, MAX(CASE WHEN ev.Month4updateoutstanding = 0							AND [WorkFlowEventType] = 'Month 4 update outstanding'								AND SnapshotDate > WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS Month4updateoutstandingOverdue
	, MAX(CASE WHEN ev.Month4updatecompleted = 0							AND [WorkFlowEventType] = 'Month 4 update completed'								AND SnapshotDate > WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS Month4updatecompletedOverdue
	, MAX(CASE WHEN ev.Month4BOTUpdateCompleted = 0							AND [WorkFlowEventType] = 'Month 4 BOT Update Completed'							AND SnapshotDate > WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS Month4BOTUpdateCompletedOverdue
	, MAX(CASE WHEN ev.Month4updatesubmittedtoDWP = 0						AND [WorkFlowEventType] = 'Month 4 update submitted to DWP'							AND SnapshotDate > WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS Month4updatesubmittedtoDWPOverdue
	, MAX(CASE WHEN ev.Month5updateoutstanding = 0							AND [WorkFlowEventType] = 'Month 5 update outstanding'								AND SnapshotDate > WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS Month5updateoutstandingOverdue
	, MAX(CASE WHEN ev.Month5updatecompleted = 0							AND [WorkFlowEventType] = 'Month 5 update completed'								AND SnapshotDate > WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS Month5updatecompletedOverdue
	, MAX(CASE WHEN ev.Month5BOTUpdateCompleted = 0							AND [WorkFlowEventType] = 'Month 5 BOT Update Completed'							AND SnapshotDate > WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS Month5BOTUpdateCompletedOverdue
	, MAX(CASE WHEN ev.Month5updatesubmittedtoDWP = 0						AND [WorkFlowEventType] = 'Month 5 update submitted to DWP'							AND SnapshotDate > WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS Month5updatesubmittedtoDWPOverdue
	, MAX(CASE WHEN ev.Awaiting6MonthSupportPlanmeetingscheduled = 0		AND [WorkFlowEventType] = 'Awaiting 6 Month Support Plan meeting scheduled'			AND SnapshotDate > WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS Awaiting6MonthSupportPlanmeetingscheduledOverdue
	, MAX(CASE WHEN ev.Month6Supportplanmeetingscheduled = 0				AND [WorkFlowEventType] = 'Month 6 Support plan meeting scheduled'					AND SnapshotDate > WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS Month6SupportplanmeetingscheduledOverdue
	, MAX(CASE WHEN ev.Month6Supportplanmeetingcompleted = 0				AND [WorkFlowEventType] = 'Month 6 Support plan meeting completed'					AND SnapshotDate > WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS Month6SupportplanmeetingcompletedOverdue
	, MAX(CASE WHEN ev.Month6Supportplansignedbycustomer = 0				AND [WorkFlowEventType] = 'Month 6 Support plan signed by customer'					AND SnapshotDate > WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS Month6SupportplansignedbycustomerOverdue
	, MAX(CASE WHEN ev.Month6SupportplanUploaded = 0						AND [WorkFlowEventType] = 'Month 6 Support plan Uploaded'							AND SnapshotDate > WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS Month6SupportplanUploadedOverdue
	, MAX(CASE WHEN ev.Month6SupportplancompletedbutnotsubmittedtoDWP = 0	AND [WorkFlowEventType] = 'Month 6 Support plan completed but not submitted to DWP' AND SnapshotDate > WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS Month6SupportplancompletedbutnotsubmittedtoDWPOverdue
	, MAX(CASE WHEN ev.Month6SupportplansubmittedtoDWP = 0					AND [WorkFlowEventType] = 'Month 6 Support plan submitted to DWP'					AND SnapshotDate > WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS Month6SupportplansubmittedtoDWPOverdue
	, MAX(CASE WHEN ev.Month6SupportPlanNotApprovedbyDWP = 0				AND [WorkFlowEventType] = 'Month 6 Support Plan Not Approved by DWP'				AND SnapshotDate > WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS Month6SupportPlanNotApprovedbyDWPOverdue
	, MAX(CASE WHEN ev.AwaitingMonth6SupportPlanReSubmission = 0			AND [WorkFlowEventType] = 'Awaiting Month 6 Support Plan Re-Submission'				AND SnapshotDate > WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS AwaitingMonth6SupportPlanReSubmissionOverdue
	, MAX(CASE WHEN ev.Month6SupportPlanReSubmitted = 0						AND [WorkFlowEventType] = 'Month 6 Support Plan Re-Submitted'						AND SnapshotDate > WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS Month6SupportPlanReSubmittedOverdue
	, MAX(CASE WHEN ev.Month6SupportplanapprovedbyDWP = 0					AND [WorkFlowEventType] = 'Month 6 Support plan approved by DWP'					AND SnapshotDate > WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS Month6SupportplanapprovedbyDWPOverdue
	, MAX(CASE WHEN ev.Month6SupportplanpaidbyDWP = 0						AND [WorkFlowEventType] = 'Month 6 Support plan paid by DWP'						AND SnapshotDate > WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS Month6SupportplanpaidbyDWPOverdue
	, MAX(CASE WHEN ev.AwaitingTransferToBSC = 0							AND [WorkFlowEventType] = 'Awaiting Transfer To BSC'								AND SnapshotDate > WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS AwaitingTransferToBSCOverdue
	, MAX(CASE WHEN ev.TransferredToBSC = 0									AND [WorkFlowEventType] = 'Transferred To BSC'										AND SnapshotDate > WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS TransferredToBSCOverdue
	, MAX(CASE WHEN ev.LightTouchEmailSentUnsuccessful = 0					AND [WorkFlowEventType] = 'Light Touch Email Sent - Unsuccessful'					AND SnapshotDate > WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS LightTouchEmailSentUnsuccessfulOverdue
	, MAX(CASE WHEN ev.LightTouchEmailSentSuccessful = 0					AND [WorkFlowEventType] = 'Light Touch Email Sent - Successful'						AND SnapshotDate > WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS LightTouchEmailSentSuccessfulOverdue
	, MAX(CASE WHEN ev.AwaitingMonth7Contact = 0							AND [WorkFlowEventType] = 'Awaiting Month 7 Contact'								AND SnapshotDate > WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS AwaitingMonth7ContactOverdue
	, MAX(CASE WHEN ev.Month7ContactSuccessful = 0							AND [WorkFlowEventType] = 'Month 7 Contact Successful'								AND SnapshotDate > WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS Month7ContactSuccessfulOverdue
	, MAX(CASE WHEN ev.Month7ContactUnsuccessful = 0						AND [WorkFlowEventType] = 'Month 7 Contact Unsuccessful'							AND SnapshotDate > WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS Month7ContactUnsuccessfulOverdue
	, MAX(CASE WHEN ev.AwaitingMonth8Contact = 0							AND [WorkFlowEventType] = 'Awaiting Month 8 Contact'								AND SnapshotDate > WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS AwaitingMonth8ContactOverdue
	, MAX(CASE WHEN ev.Month8ContactSuccessful = 0							AND [WorkFlowEventType] = 'Month 8 Contact Successful'								AND SnapshotDate > WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS Month8ContactSuccessfulOverdue
	, MAX(CASE WHEN ev.Month8ContactUnsuccessful = 0						AND [WorkFlowEventType] = 'Month 8 Contact Unsuccessful'							AND SnapshotDate > WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS Month8ContactUnsuccessfulOverdue
	, MAX(CASE WHEN ev.Awaiting9MonthReportmeetingscheduled = 0				AND [WorkFlowEventType] = 'Awaiting 9 Month Report meeting scheduled'				AND SnapshotDate > WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS Awaiting9MonthReportmeetingscheduledOverdue
	, MAX(CASE WHEN ev.NineMonthReportmeetingscheduled = 0					AND [WorkFlowEventType] = '9 Month Report meeting scheduled'						AND SnapshotDate > WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS NineMonthReportmeetingscheduledOverdue
	, MAX(CASE WHEN ev.NineMonthReportmeetingcompleted = 0					AND [WorkFlowEventType] = '9 Month Report meeting completed'						AND SnapshotDate > WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS NineMonthReportmeetingcompletedOverdue
	, MAX(CASE WHEN ev.NineMonthReportsignedbycustomer = 0					AND [WorkFlowEventType] = '9 Month Report signed by customer'						AND SnapshotDate > WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS NineMonthReportsignedbycustomerOverdue
	, MAX(CASE WHEN ev.NineMonthReportUploaded = 0							AND [WorkFlowEventType] = '9 Month Report Uploaded'									AND	SnapshotDate > WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS NineMonthReportUploadedOverdue
	, MAX(CASE WHEN ev.NineMonthReportcompletedbutnotsubmittedtoDWP = 0		AND [WorkFlowEventType] = '9 Month Report completed but not submitted to DWP'		AND SnapshotDate > WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS NineMonthReportcompletedbutnotsubmittedtoDWPOverdue
	, MAX(CASE WHEN ev.NineMonthReportsubmittedtoDWP = 0					AND [WorkFlowEventType] = '9 Month Report submitted to DWP'							AND SnapshotDate > WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS NineMonthReportsubmittedtoDWPOverdue
	, MAX(CASE WHEN ev.NineMonthReportNotApprovedbyDWP = 0					AND [WorkFlowEventType] = '9 Month Report Not Approved by DWP'						AND SnapshotDate > WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS NineMonthReportNotApprovedbyDWPOverdue
	, MAX(CASE WHEN ev.Awaiting9MonthReportReSubmission = 0					AND [WorkFlowEventType] = 'Awaiting 9 Month Report Re-Submission'					AND SnapshotDate > WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS Awaiting9MonthReportReSubmissionOverdue
	, MAX(CASE WHEN ev.NineMonthReportReSubmitted = 0						AND [WorkFlowEventType] = '9 Month Report Re-Submitted'								AND SnapshotDate > WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS NineMonthReportReSubmittedOverdue
	, MAX(CASE WHEN ev.NineMonthReportapprovedbyDWP = 0						AND [WorkFlowEventType] = '9 Month Report approved by DWP'							AND SnapshotDate > WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS NineMonthReportapprovedbyDWPOverdue
	, MAX(CASE WHEN ev.NineMonthReportpaidbyDWP = 0							AND [WorkFlowEventType] = '9 Month Report paid by DWP'								AND SnapshotDate > WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS NineMonthReportpaidbyDWPOverdue
	, MAX(CASE WHEN ev.Rejected = 0											AND [WorkFlowEventType] = 'Rejected'												AND SnapshotDate > WorkFlowEstimatedEndDate_Skey THEN 1 ELSE 0 END) AS RejectedOverdue

	
	, MAX(CASE WHEN ev.MarketingCampaignAttempted	= 0						AND ([WorkFlowEventType] = 'Light Touch Email Sent - Unsuccessful'					AND SnapshotDate > WorkFlowEstimatedEndDate_Skey	) 	OR 	(WorkFlowEventType = 'Light Touch Email Sent - Successful'	AND	SnapshotDate > WorkFlowEstimatedEndDate_Skey	)	THEN 1 ELSE 0 END)	AS MarketingCampaignAttemptedOverdue
	, MAX(CASE WHEN ev.Month7ContactAttempted		= 0						AND ([WorkFlowEventType] = 'Month 7 Contact Unsuccessful'							AND SnapshotDate > WorkFlowEstimatedEndDate_Skey	)	OR 	(WorkFlowEventType = 'Month 7 Contact Successful'			AND	SnapshotDate > WorkFlowEstimatedEndDate_Skey	)	THEN 1 ELSE 0 END)	AS Month7ContactAttemptedOverdue
	, MAX(CASE WHEN ev.Month8ContactAttempted		= 0						AND ([WorkFlowEventType] = 'Month 8 Contact Unsuccessful'							AND SnapshotDate > WorkFlowEstimatedEndDate_Skey	)	OR 	(WorkFlowEventType = 'Month 8 Contact Successful'			AND	SnapshotDate > WorkFlowEstimatedEndDate_Skey	)	THEN 1 ELSE 0 END)	AS Month8ContactAttemptedOverdue
	, MAX(CASE WHEN ev.Month1UpdateSuccessful		= 0						AND ([WorkFlowEventType] = 'Month 1 update completed'								AND SnapshotDate > WorkFlowEstimatedEndDate_Skey	)	OR 	(WorkFlowEventType = 'Month 1 BOT Update Completed'			AND	SnapshotDate > WorkFlowEstimatedEndDate_Skey	)	THEN 1 ELSE 0 END)	AS Month1UpdateSuccessfulOverdue
	, MAX(CASE WHEN ev.Month2UpdateSuccessful		= 0						AND ([WorkFlowEventType] = 'Month 2 update completed'								AND SnapshotDate > WorkFlowEstimatedEndDate_Skey	)	OR 	(WorkFlowEventType = 'Month 2 BOT Update Completed'			AND	SnapshotDate > WorkFlowEstimatedEndDate_Skey	)	THEN 1 ELSE 0 END)	AS Month2UpdateSuccessfulOverdue
	, MAX(CASE WHEN ev.Month3UpdateSuccessful		= 0						AND ([WorkFlowEventType] = 'Month 3 update completed'								AND SnapshotDate > WorkFlowEstimatedEndDate_Skey	)	OR 	(WorkFlowEventType = 'Month 3 BOT Update Completed'			AND	SnapshotDate > WorkFlowEstimatedEndDate_Skey	)	THEN 1 ELSE 0 END)	AS Month3UpdateSuccessfulOverdue
	, MAX(CASE WHEN ev.Month4UpdateSuccessful		= 0						AND ([WorkFlowEventType] = 'Month 4 update completed'								AND SnapshotDate > WorkFlowEstimatedEndDate_Skey	)	OR 	(WorkFlowEventType = 'Month 4 BOT Update Completed'			AND	SnapshotDate > WorkFlowEstimatedEndDate_Skey	)	THEN 1 ELSE 0 END)	AS Month4UpdateSuccessfulOverdue
	, MAX(CASE WHEN ev.Month5UpdateSuccessful		= 0						AND ([WorkFlowEventType] = 'Month 5 update completed'								AND SnapshotDate > WorkFlowEstimatedEndDate_Skey	)	OR 	(WorkFlowEventType = 'Month 5 BOT Update Completed'			AND	SnapshotDate > WorkFlowEstimatedEndDate_Skey	)	THEN 1 ELSE 0 END)	AS Month5UpdateSuccessfulOverdue

	, MAX(CASE WHEN ev.SupportplanUploaded			= 1						AND  [WorkFlowEventType] = 'Support plan Uploaded'									THEN WorkFlowEventEmployee_Skey END) AS SupportplanUploadedEmployee_Skey
	, MAX(CASE WHEN ev.Month6SupportplanUploaded	= 1						AND  [WorkFlowEventType] = 'Month 6 Support plan Uploaded'							THEN WorkFlowEventEmployee_Skey END) AS Month6SupportplanUploadedEmployee_Skey
	, MAX(CASE WHEN ev.NineMonthReportUploaded		= 1						AND  [WorkFlowEventType] = '9 Month Report Uploaded'								THEN WorkFlowEventEmployee_Skey END) AS NineMonthReportUploadedEmployee_Skey

FROM 
	stg.DW_F_AtW_Case_Daily_Analysis_TEMP1 ev
		INNER JOIN DW.LNK_Work_Flow_Event_Analysis lnk_wfea
			ON ev.Case_Analysis_Skey = lnk_wfea.Case_Analysis_Skey
		INNER JOIN DW.D_Work_Flow_Event_Type dw_d_wfet
			ON dw_d_wfet.Work_Flow_Event_Type_Skey = lnk_wfea.WorkFlowEventType_Skey
GROUP BY
	  ev.SnapshotDate
	, ev.Case_Analysis_Skey


CREATE TABLE stg.DW_F_AtW_Case_Daily_Analysis_TEMP3
       WITH (distribution = hash(Case_Analysis_Skey), HEAP) 
AS

SELECT
	dw_d_dt.[Date_Skey]			AS SnapshotDate
  , dw_f_ca.[Case_Analysis_Skey]
FROM DW.F_Case_Analysis dw_f_ca
	CROSS JOIN DW.D_Date dw_d_dt
WHERE  
	dw_d_dt.Date_Skey > CAST(format(GETDATE(),'yyyyMMdd') AS INT)
	AND dw_d_dt.[Date] <= DATEADD(year,1,GETDATE())

CREATE TABLE stg.DW_F_AtW_Case_Daily_Analysis_TEMP4
        WITH (distribution = hash(Case_Analysis_Skey), HEAP) 
AS

SELECT	
	   TEMP3.[SnapshotDate]
      ,TEMP2.[Case_Analysis_Skey]
      ,TEMP2.[NewEnquiry]
      ,TEMP2.[ReferralCallRequired]
      ,TEMP2.[ReferralCallBackAttempt1]
      ,TEMP2.[ReferralCallBackAttempt2]
      ,TEMP2.[ReferralCallBackAttempt3]
      ,TEMP2.[LiveEnquiry]
	  ,TEMP2.[UnsuccessfulEnquiry]
      ,TEMP2.[SuccessfulEnquiry]
      ,TEMP2.[AwaitingReferral]
      ,TEMP2.[ReferralReceived]
      ,TEMP2.[EmailreferraltoDWP]
      ,TEMP2.[ReferralApproved]
      ,TEMP2.[ReferralUnsuccessful]
      ,TEMP2.[InitialContact]
      ,TEMP2.[AwaitingTelephoneAssessmentMeetingSchedule]
      ,TEMP2.[TelephoneAssessmentscheduled]
      ,TEMP2.[TelephoneAssessmentCompleted]
      ,TEMP2.[AwaitingSupportPlanmeetingscheduled]
      ,TEMP2.[Supportplanmeetingscheduled]
      ,TEMP2.[Supportplanmeetingcompleted]
      ,TEMP2.[Supportplansignedbycustomer]
      ,TEMP2.[SupportplanUploaded]
      ,TEMP2.[SupportplancompletedbutnotsubmittedtoDWP]
      ,TEMP2.[SupportplansubmittedtoDWP]
      ,TEMP2.[SupportPlanNotApprovedbyDWP]
      ,TEMP2.[AwaitingSupportPlanReSubmission]
      ,TEMP2.[SupportPlanReSubmitted]
      ,TEMP2.[SupportplanapprovedbyDWP]
      ,TEMP2.[SupportplanpaidbyDWP]
      ,TEMP2.[Month1updateoutstanding]
      ,TEMP2.[Month1updatecompleted]
	  ,TEMP2.[Month1BOTUpdateCompleted]
      ,TEMP2.[Month1updatesubmittedtoDWP]
      ,TEMP2.[Month2updateoutstanding]
      ,TEMP2.[Month2updatecompleted]
      ,TEMP2.[Month2BOTUpdateCompleted]
	  ,TEMP2.[Month2updatesubmittedtoDWP]
      ,TEMP2.[Month3updateoutstanding]
      ,TEMP2.[Month3updatecompleted]
      ,TEMP2.[Month3BOTUpdateCompleted]
	  ,TEMP2.[Month3updatesubmittedtoDWP]
      ,TEMP2.[Month4updateoutstanding]
      ,TEMP2.[Month4updatecompleted]
      ,TEMP2.[Month4BOTUpdateCompleted]
	  ,TEMP2.[Month4updatesubmittedtoDWP]
      ,TEMP2.[Month5updateoutstanding]
      ,TEMP2.[Month5updatecompleted]
      ,TEMP2.[Month5BOTUpdateCompleted]
	  ,TEMP2.[Month5updatesubmittedtoDWP]
      ,TEMP2.[Awaiting6MonthSupportPlanmeetingscheduled]
      ,TEMP2.[Month6Supportplanmeetingscheduled]
      ,TEMP2.[Month6Supportplanmeetingcompleted]
      ,TEMP2.[Month6Supportplansignedbycustomer]
      ,TEMP2.[Month6SupportplanUploaded]
      ,TEMP2.[Month6SupportplancompletedbutnotsubmittedtoDWP]
      ,TEMP2.[Month6SupportplansubmittedtoDWP]
	  ,TEMP2.[Month6SupportPlanNotApprovedbyDWP]
	  ,TEMP2.[AwaitingMonth6SupportPlanReSubmission]
	  ,TEMP2.[Month6SupportPlanReSubmitted]
      ,TEMP2.[Month6SupportplanapprovedbyDWP]
      ,TEMP2.[Month6SupportplanpaidbyDWP]
      ,TEMP2.[AwaitingTransferToBSC]
      ,TEMP2.[TransferredToBSC]
      ,TEMP2.[LightTouchEmailSentUnsuccessful]
      ,TEMP2.[LightTouchEmailSentSuccessful]
      ,TEMP2.[AwaitingMonth7Contact]
      ,TEMP2.[Month7ContactSuccessful]
      ,TEMP2.[Month7ContactUnsuccessful]
      ,TEMP2.[AwaitingMonth8Contact]
      ,TEMP2.[Month8ContactSuccessful]
      ,TEMP2.[Month8ContactUnsuccessful]
      ,TEMP2.[Awaiting9MonthReportmeetingscheduled]
      ,TEMP2.[NineMonthReportmeetingscheduled]
      ,TEMP2.[NineMonthReportmeetingcompleted]
      ,TEMP2.[NineMonthReportsignedbycustomer]
      ,TEMP2.[NineMonthReportUploaded]
      ,TEMP2.[NineMonthReportcompletedbutnotsubmittedtoDWP]
      ,TEMP2.[NineMonthReportsubmittedtoDWP]
	  ,TEMP2.[NineMonthReportNotApprovedbyDWP]
      ,TEMP2.[Awaiting9MonthReportReSubmission]
      ,TEMP2.[NineMonthReportReSubmitted]
      ,TEMP2.[NineMonthReportapprovedbyDWP]
      ,TEMP2.[NineMonthReportpaidbyDWP]
      ,TEMP2.[Rejected]
	  ,TEMP2.[MarketingCampaignAttempted]
	  ,TEMP2.[Month7ContactAttempted]
	  ,TEMP2.[Month8ContactAttempted]
	  ,TEMP2.[Month1UpdateSuccessful]
	  ,TEMP2.[Month2UpdateSuccessful]
	  ,TEMP2.[Month3UpdateSuccessful]
	  ,TEMP2.[Month4UpdateSuccessful]
	  ,TEMP2.[Month5UpdateSuccessful]

      ,TEMP2.[NewEnquiryCompletedWithinSLA]
      ,TEMP2.[ReferralCallRequiredCompletedWithinSLA]
      ,TEMP2.[ReferralCallBackAttempt1CompletedWithinSLA]
      ,TEMP2.[ReferralCallBackAttempt2CompletedWithinSLA]
      ,TEMP2.[ReferralCallBackAttempt3CompletedWithinSLA]
	  ,TEMP2.[LiveEnquiryCompletedWithinSLA]
      ,TEMP2.[UnsuccessfulEnquiryCompletedWithinSLA]
      ,TEMP2.[SuccessfulEnquiryCompletedWithinSLA]
      ,TEMP2.[AwaitingReferralCompletedWithinSLA]
      ,TEMP2.[ReferralReceivedCompletedWithinSLA]
      ,TEMP2.[EmailreferraltoDWPCompletedWithinSLA]
      ,TEMP2.[ReferralApprovedCompletedWithinSLA]
      ,TEMP2.[ReferralUnsuccessfulCompletedWithinSLA]
      ,TEMP2.[InitialContactCompletedWithinSLA]
      ,TEMP2.[AwaitingTelephoneAssessmentMeetingScheduleCompletedWithinSLA]
      ,TEMP2.[TelephoneAssessmentscheduledCompletedWithinSLA]
      ,TEMP2.[TelephoneAssessmentCompletedCompletedWithinSLA]
      ,TEMP2.[AwaitingSupportPlanmeetingscheduledCompletedWithinSLA]
      ,TEMP2.[SupportplanmeetingscheduledCompletedWithinSLA]
      ,TEMP2.[SupportplanmeetingcompletedCompletedWithinSLA]
      ,TEMP2.[SupportplansignedbycustomerCompletedWithinSLA]
      ,TEMP2.[SupportplanUploadedCompletedWithinSLA]
      ,TEMP2.[SupportplancompletedbutnotsubmittedtoDWPCompletedWithinSLA]
      ,TEMP2.[SupportplansubmittedtoDWPCompletedWithinSLA]
      ,TEMP2.[SupportPlanNotApprovedbyDWPCompletedWithinSLA]
      ,TEMP2.[AwaitingSupportPlanReSubmissionCompletedWithinSLA]
      ,TEMP2.[SupportPlanReSubmittedCompletedWithinSLA]
      ,TEMP2.[SupportplanapprovedbyDWPCompletedWithinSLA]
      ,TEMP2.[SupportplanpaidbyDWPCompletedWithinSLA]
      ,TEMP2.[Month1updateoutstandingCompletedWithinSLA]
      ,TEMP2.[Month1updatecompletedCompletedWithinSLA]
      ,TEMP2.[Month1BOTUpdateCompletedCompletedWithinSLA]
      ,TEMP2.[Month1updatesubmittedtoDWPCompletedWithinSLA]
      ,TEMP2.[Month2updateoutstandingCompletedWithinSLA]
      ,TEMP2.[Month2updatecompletedCompletedWithinSLA]
      ,TEMP2.[Month2BOTUpdateCompletedCompletedWithinSLA]
      ,TEMP2.[Month2updatesubmittedtoDWPCompletedWithinSLA]
      ,TEMP2.[Month3updateoutstandingCompletedWithinSLA]
      ,TEMP2.[Month3updatecompletedCompletedWithinSLA]
      ,TEMP2.[Month3BOTUpdateCompletedCompletedWithinSLA]
      ,TEMP2.[Month3updatesubmittedtoDWPCompletedWithinSLA]
      ,TEMP2.[Month4updateoutstandingCompletedWithinSLA]
      ,TEMP2.[Month4updatecompletedCompletedWithinSLA]
      ,TEMP2.[Month4BOTUpdateCompletedCompletedWithinSLA]
      ,TEMP2.[Month4updatesubmittedtoDWPCompletedWithinSLA]
      ,TEMP2.[Month5updateoutstandingCompletedWithinSLA]
      ,TEMP2.[Month5updatecompletedCompletedWithinSLA]
      ,TEMP2.[Month5BOTUpdateCompletedCompletedWithinSLA]
      ,TEMP2.[Month5updatesubmittedtoDWPCompletedWithinSLA]
      ,TEMP2.[Awaiting6MonthSupportPlanmeetingscheduledCompletedWithinSLA]
      ,TEMP2.[Month6SupportplanmeetingscheduledCompletedWithinSLA]
      ,TEMP2.[Month6SupportplanmeetingcompletedCompletedWithinSLA]
      ,TEMP2.[Month6SupportplansignedbycustomerCompletedWithinSLA]
      ,TEMP2.[Month6SupportplanUploadedCompletedWithinSLA]
      ,TEMP2.[Month6SupportplancompletedbutnotsubmittedtoDWPCompletedWithinSLA]
      ,TEMP2.[Month6SupportplansubmittedtoDWPCompletedWithinSLA]
      ,TEMP2.[Month6SupportPlanNotApprovedbyDWPCompletedWithinSLA]
      ,TEMP2.[AwaitingMonth6SupportPlanReSubmissionCompletedWithinSLA]
      ,TEMP2.[Month6SupportPlanReSubmittedCompletedWithinSLA]
      ,TEMP2.[Month6SupportplanapprovedbyDWPCompletedWithinSLA]
      ,TEMP2.[Month6SupportplanpaidbyDWPCompletedWithinSLA]
      ,TEMP2.[AwaitingTransferToBSCCompletedWithinSLA]
      ,TEMP2.[TransferredToBSCCompletedWithinSLA]
      ,TEMP2.[LightTouchEmailSentUnsuccessfulCompletedWithinSLA]
      ,TEMP2.[LightTouchEmailSentSuccessfulCompletedWithinSLA]
      ,TEMP2.[AwaitingMonth7ContactCompletedWithinSLA]
      ,TEMP2.[Month7ContactSuccessfulCompletedWithinSLA]
      ,TEMP2.[Month7ContactUnsuccessfulCompletedWithinSLA]
      ,TEMP2.[AwaitingMonth8ContactCompletedWithinSLA]
      ,TEMP2.[Month8ContactSuccessfulCompletedWithinSLA]
      ,TEMP2.[Month8ContactUnsuccessfulCompletedWithinSLA]
      ,TEMP2.[Awaiting9MonthReportmeetingscheduledCompletedWithinSLA]
      ,TEMP2.[NineMonthReportmeetingscheduledCompletedWithinSLA]
      ,TEMP2.[NineMonthReportmeetingcompletedCompletedWithinSLA]
      ,TEMP2.[NineMonthReportsignedbycustomerCompletedWithinSLA]
      ,TEMP2.[NineMonthReportUploadedCompletedWithinSLA]
      ,TEMP2.[NineMonthReportcompletedbutnotsubmittedtoDWPCompletedWithinSLA]
      ,TEMP2.[NineMonthReportsubmittedtoDWPCompletedWithinSLA]
      ,TEMP2.[NineMonthReportNotApprovedbyDWPCompletedWithinSLA]
      ,TEMP2.[Awaiting9MonthReportReSubmissionCompletedWithinSLA]
      ,TEMP2.[NineMonthReportReSubmittedCompletedWithinSLA]
      ,TEMP2.[NineMonthReportapprovedbyDWPCompletedWithinSLA]
      ,TEMP2.[NineMonthReportpaidbyDWPCompletedWithinSLA]
      ,TEMP2.[RejectedCompletedWithinSLA]
      ,TEMP2.[MarketingCampaignAttemptedCompletedWithinSLA]
      ,TEMP2.[Month7ContactAttemptedCompletedWithinSLA]
      ,TEMP2.[Month8ContactAttemptedCompletedWithinSLA]
      ,TEMP2.[Month1UpdateSuccessfulCompletedWithinSLA]
      ,TEMP2.[Month2UpdateSuccessfulCompletedWithinSLA]
      ,TEMP2.[Month3UpdateSuccessfulCompletedWithinSLA]
      ,TEMP2.[Month4UpdateSuccessfulCompletedWithinSLA]
      ,TEMP2.[Month5UpdateSuccessfulCompletedWithinSLA]

      ,TEMP2.[NewEnquiryOutsideSLA]
      ,TEMP2.[ReferralCallRequiredOutsideSLA]
      ,TEMP2.[ReferralCallBackAttempt1OutsideSLA]
      ,TEMP2.[ReferralCallBackAttempt2OutsideSLA]
      ,TEMP2.[ReferralCallBackAttempt3OutsideSLA]
      ,TEMP2.[LiveEnquiryOutsideSLA]
	  ,TEMP2.[UnsuccessfulEnquiryOutsideSLA]
      ,TEMP2.[SuccessfulEnquiryOutsideSLA]
      ,TEMP2.[AwaitingReferralOutsideSLA]
      ,TEMP2.[ReferralReceivedOutsideSLA]
      ,TEMP2.[EmailreferraltoDWPOutsideSLA]
      ,TEMP2.[ReferralApprovedOutsideSLA]
      ,TEMP2.[ReferralUnsuccessfulOutsideSLA]
      ,TEMP2.[InitialContactOutsideSLA]
      ,TEMP2.[AwaitingTelephoneAssessmentMeetingScheduleOutsideSLA]
      ,TEMP2.[TelephoneAssessmentscheduledOutsideSLA]
      ,TEMP2.[TelephoneAssessmentCompletedOutsideSLA]
      ,TEMP2.[AwaitingSupportPlanmeetingscheduledOutsideSLA]
      ,TEMP2.[SupportplanmeetingscheduledOutsideSLA]
      ,TEMP2.[SupportplanmeetingcompletedOutsideSLA]
      ,TEMP2.[SupportplansignedbycustomerOutsideSLA]
      ,TEMP2.[SupportplanUploadedOutsideSLA]
      ,TEMP2.[SupportplancompletedbutnotsubmittedtoDWPOutsideSLA]
      ,TEMP2.[SupportplansubmittedtoDWPOutsideSLA]
      ,TEMP2.[SupportPlanNotApprovedbyDWPOutsideSLA]
      ,TEMP2.[AwaitingSupportPlanReSubmissionOutsideSLA]
      ,TEMP2.[SupportPlanReSubmittedOutsideSLA]
      ,TEMP2.[SupportplanapprovedbyDWPOutsideSLA]
      ,TEMP2.[SupportplanpaidbyDWPOutsideSLA]
      ,TEMP2.[Month1updateoutstandingOutsideSLA]
      ,TEMP2.[Month1updatecompletedOutsideSLA]
      ,TEMP2.[Month1BOTUpdateCompletedOutsideSLA]
      ,TEMP2.[Month1updatesubmittedtoDWPOutsideSLA]
      ,TEMP2.[Month2updateoutstandingOutsideSLA]
      ,TEMP2.[Month2updatecompletedOutsideSLA]
      ,TEMP2.[Month2BOTUpdateCompletedOutsideSLA]
      ,TEMP2.[Month2updatesubmittedtoDWPOutsideSLA]
      ,TEMP2.[Month3updateoutstandingOutsideSLA]
      ,TEMP2.[Month3updatecompletedOutsideSLA]
      ,TEMP2.[Month3BOTUpdateCompletedOutsideSLA]
      ,TEMP2.[Month3updatesubmittedtoDWPOutsideSLA]
      ,TEMP2.[Month4updateoutstandingOutsideSLA]
      ,TEMP2.[Month4updatecompletedOutsideSLA]
      ,TEMP2.[Month4BOTUpdateCompletedOutsideSLA]
      ,TEMP2.[Month4updatesubmittedtoDWPOutsideSLA]
      ,TEMP2.[Month5updateoutstandingOutsideSLA]
      ,TEMP2.[Month5updatecompletedOutsideSLA]
      ,TEMP2.[Month5BOTUpdateCompletedOutsideSLA]
      ,TEMP2.[Month5updatesubmittedtoDWPOutsideSLA]
      ,TEMP2.[Awaiting6MonthSupportPlanmeetingscheduledOutsideSLA]
      ,TEMP2.[Month6SupportplanmeetingscheduledOutsideSLA]
      ,TEMP2.[Month6SupportplanmeetingcompletedOutsideSLA]
      ,TEMP2.[Month6SupportplansignedbycustomerOutsideSLA]
      ,TEMP2.[Month6SupportplanUploadedOutsideSLA]
      ,TEMP2.[Month6SupportplancompletedbutnotsubmittedtoDWPOutsideSLA]
      ,TEMP2.[Month6SupportplansubmittedtoDWPOutsideSLA]
      ,TEMP2.[Month6SupportPlanNotApprovedbyDWPOutsideSLA]
      ,TEMP2.[AwaitingMonth6SupportPlanReSubmissionOutsideSLA]
      ,TEMP2.[Month6SupportPlanReSubmittedOutsideSLA]
      ,TEMP2.[Month6SupportplanapprovedbyDWPOutsideSLA]
      ,TEMP2.[Month6SupportplanpaidbyDWPOutsideSLA]
      ,TEMP2.[AwaitingTransferToBSCOutsideSLA]
      ,TEMP2.[TransferredToBSCOutsideSLA]
      ,TEMP2.[LightTouchEmailSentUnsuccessfulOutsideSLA]
      ,TEMP2.[LightTouchEmailSentSuccessfulOutsideSLA]
      ,TEMP2.[AwaitingMonth7ContactOutsideSLA]
      ,TEMP2.[Month7ContactSuccessfulOutsideSLA]
      ,TEMP2.[Month7ContactUnsuccessfulOutsideSLA]
      ,TEMP2.[AwaitingMonth8ContactOutsideSLA]
      ,TEMP2.[Month8ContactSuccessfulOutsideSLA]
      ,TEMP2.[Month8ContactUnsuccessfulOutsideSLA]
      ,TEMP2.[Awaiting9MonthReportmeetingscheduledOutsideSLA]
      ,TEMP2.[NineMonthReportmeetingscheduledOutsideSLA]
      ,TEMP2.[NineMonthReportmeetingcompletedOutsideSLA]
      ,TEMP2.[NineMonthReportsignedbycustomerOutsideSLA]
      ,TEMP2.[NineMonthReportUploadedOutsideSLA]
      ,TEMP2.[NineMonthReportcompletedbutnotsubmittedtoDWPOutsideSLA]
      ,TEMP2.[NineMonthReportsubmittedtoDWPOutsideSLA]
      ,TEMP2.[NineMonthReportNotApprovedbyDWPOutsideSLA]
      ,TEMP2.[Awaiting9MonthReportReSubmissionOutsideSLA]
      ,TEMP2.[NineMonthReportReSubmittedOutsideSLA]
      ,TEMP2.[NineMonthReportapprovedbyDWPOutsideSLA]
      ,TEMP2.[NineMonthReportpaidbyDWPOutsideSLA]
      ,TEMP2.[RejectedOutsideSLA]
      ,TEMP2.[MarketingCampaignAttemptedCompletedOutsideSLA]
      ,TEMP2.[Month7ContactAttemptedCompletedOutsideSLA]
      ,TEMP2.[Month8ContactAttemptedCompletedOutsideSLA]
      ,TEMP2.[Month1UpdateSuccessfulCompletedOutsideSLA]
      ,TEMP2.[Month2UpdateSuccessfulCompletedOutsideSLA]
      ,TEMP2.[Month3UpdateSuccessfulCompletedOutsideSLA]
      ,TEMP2.[Month4UpdateSuccessfulCompletedOutsideSLA]
      ,TEMP2.[Month5UpdateSuccessfulCompletedOutsideSLA]

      ,TEMP2.[NewEnquiryOverdue]
      ,TEMP2.[ReferralCallRequiredOverdue]
      ,TEMP2.[ReferralCallBackAttempt1Overdue]
      ,TEMP2.[ReferralCallBackAttempt2Overdue]
      ,TEMP2.[ReferralCallBackAttempt3Overdue]
	  ,TEMP2.[LiveEnquiryOverdue]
      ,TEMP2.[UnsuccessfulEnquiryOverdue]
      ,TEMP2.[SuccessfulEnquiryOverdue]
      ,TEMP2.[AwaitingReferralOverdue]
      ,TEMP2.[ReferralReceivedOverdue]
      ,TEMP2.[EmailreferraltoDWPOverdue]
      ,TEMP2.[ReferralApprovedOverdue]
      ,TEMP2.[ReferralUnsuccessfulOverdue]
      ,TEMP2.[InitialContactOverdue]
      ,TEMP2.[AwaitingTelephoneAssessmentMeetingScheduleOverdue]
      ,TEMP2.[TelephoneAssessmentscheduledOverdue]
      ,TEMP2.[TelephoneAssessmentCompletedOverdue]
      ,TEMP2.[AwaitingSupportPlanmeetingscheduledOverdue]
      ,TEMP2.[SupportplanmeetingscheduledOverdue]
      ,TEMP2.[SupportplanmeetingcompletedOverdue]
      ,TEMP2.[SupportplansignedbycustomerOverdue]
      ,TEMP2.[SupportplanUploadedOverdue]
      ,TEMP2.[SupportplancompletedbutnotsubmittedtoDWPOverdue]
      ,TEMP2.[SupportplansubmittedtoDWPOverdue]
      ,TEMP2.[SupportPlanNotApprovedbyDWPOverdue]
      ,TEMP2.[AwaitingSupportPlanReSubmissionOverdue]
      ,TEMP2.[SupportPlanReSubmittedOverdue]
      ,TEMP2.[SupportplanapprovedbyDWPOverdue]
      ,TEMP2.[SupportplanpaidbyDWPOverdue]
      ,TEMP2.[Month1updateoutstandingOverdue]
      ,TEMP2.[Month1updatecompletedOverdue]
      ,TEMP2.[Month1BOTUpdateCompletedOverdue]
      ,TEMP2.[Month1updatesubmittedtoDWPOverdue]
      ,TEMP2.[Month2updateoutstandingOverdue]
      ,TEMP2.[Month2updatecompletedOverdue]
      ,TEMP2.[Month2BOTUpdateCompletedOverdue]
      ,TEMP2.[Month2updatesubmittedtoDWPOverdue]
      ,TEMP2.[Month3updateoutstandingOverdue]
      ,TEMP2.[Month3updatecompletedOverdue]
      ,TEMP2.[Month3BOTUpdateCompletedOverdue]
      ,TEMP2.[Month3updatesubmittedtoDWPOverdue]
      ,TEMP2.[Month4updateoutstandingOverdue]
      ,TEMP2.[Month4updatecompletedOverdue]
      ,TEMP2.[Month4BOTUpdateCompletedOverdue]
      ,TEMP2.[Month4updatesubmittedtoDWPOverdue]
      ,TEMP2.[Month5updateoutstandingOverdue]
      ,TEMP2.[Month5updatecompletedOverdue]
      ,TEMP2.[Month5BOTUpdateCompletedOverdue]
      ,TEMP2.[Month5updatesubmittedtoDWPOverdue]
      ,TEMP2.[Awaiting6MonthSupportPlanmeetingscheduledOverdue]
      ,TEMP2.[Month6SupportplanmeetingscheduledOverdue]
      ,TEMP2.[Month6SupportplanmeetingcompletedOverdue]
      ,TEMP2.[Month6SupportplansignedbycustomerOverdue]
      ,TEMP2.[Month6SupportplanUploadedOverdue]
      ,TEMP2.[Month6SupportplancompletedbutnotsubmittedtoDWPOverdue]
      ,TEMP2.[Month6SupportplansubmittedtoDWPOverdue]
      ,TEMP2.[Month6SupportPlanNotApprovedbyDWPOverdue]
      ,TEMP2.[AwaitingMonth6SupportPlanReSubmissionOverdue]
      ,TEMP2.[Month6SupportPlanReSubmittedOverdue]
      ,TEMP2.[Month6SupportplanapprovedbyDWPOverdue]
      ,TEMP2.[Month6SupportplanpaidbyDWPOverdue]
      ,TEMP2.[AwaitingTransferToBSCOverdue]
      ,TEMP2.[TransferredToBSCOverdue]
      ,TEMP2.[LightTouchEmailSentUnsuccessfulOverdue]
      ,TEMP2.[LightTouchEmailSentSuccessfulOverdue]
      ,TEMP2.[AwaitingMonth7ContactOverdue]
      ,TEMP2.[Month7ContactSuccessfulOverdue]
      ,TEMP2.[Month7ContactUnsuccessfulOverdue]
      ,TEMP2.[AwaitingMonth8ContactOverdue]
      ,TEMP2.[Month8ContactSuccessfulOverdue]
      ,TEMP2.[Month8ContactUnsuccessfulOverdue]
      ,TEMP2.[Awaiting9MonthReportmeetingscheduledOverdue]
      ,TEMP2.[NineMonthReportmeetingscheduledOverdue]
      ,TEMP2.[NineMonthReportmeetingcompletedOverdue]
      ,TEMP2.[NineMonthReportsignedbycustomerOverdue]
      ,TEMP2.[NineMonthReportUploadedOverdue]
      ,TEMP2.[NineMonthReportcompletedbutnotsubmittedtoDWPOverdue]
      ,TEMP2.[NineMonthReportsubmittedtoDWPOverdue]
      ,TEMP2.[NineMonthReportNotApprovedbyDWPOverdue]
      ,TEMP2.[Awaiting9MonthReportReSubmissionOverdue]
      ,TEMP2.[NineMonthReportReSubmittedOverdue]
      ,TEMP2.[NineMonthReportapprovedbyDWPOverdue]
      ,TEMP2.[NineMonthReportpaidbyDWPOverdue]
      ,TEMP2.[RejectedOverdue]
      ,TEMP2.[MarketingCampaignAttemptedOverdue]
      ,TEMP2.[Month7ContactAttemptedOverdue]
      ,TEMP2.[Month8ContactAttemptedOverdue]
      ,TEMP2.[Month1UpdateSuccessfulOverdue]
      ,TEMP2.[Month2UpdateSuccessfulOverdue]
      ,TEMP2.[Month3UpdateSuccessfulOverdue]
      ,TEMP2.[Month4UpdateSuccessfulOverdue]
      ,TEMP2.[Month5UpdateSuccessfulOverdue]

	  ,TEMP2.[SupportplanUploadedEmployee_Skey]
	  ,TEMP2.[Month6SupportplanUploadedEmployee_Skey]
	  ,TEMP2.[NineMonthReportUploadedEmployee_Skey]

FROM 
	stg.DW_F_AtW_Case_Daily_Analysis_TEMP2 TEMP2
		INNER JOIN stg.DW_F_AtW_Case_Daily_Analysis_TEMP3 TEMP3
			ON TEMP2.Case_Analysis_Skey = TEMP3.Case_Analysis_Skey
WHERE 
	TEMP2.SnapshotDate = CAST(format(GETDATE(),'yyyyMMdd') AS INT)

UNION ALL

SELECT * 
FROM stg.DW_F_AtW_Case_Daily_Analysis_TEMP2 TEMP2

CREATE TABLE stg.DW_F_AtW_Case_Daily_Analysis_TEMP5
        WITH (clustered columnstore index, distribution = hash(Case_Analysis_Skey)) 
AS

SELECT *
FROM DW.F_AtW_Case_Daily_Analysis
WHERE
	Date_Skey < @LoadDate

UNION ALL

SELECT
	  SLAs.Case_Analysis_Skey
	, SLAs.SnapshotDate															AS Date_Skey
	, dw_lnk_wfs.Stage_Skey														AS Historic_Stage_Skey
	, COALESCE(dw_cst.Case_Status_Skey, -1)										AS Historic_Case_Status_Skey
	, COALESCE(CAST(format(ds_case_PIT.CaseClosedDate,'yyyyMMdd') AS INT), -1)	AS Historic_Case_Closed_Skey
	, CASE 
		WHEN dw_cst.[CaseStatus] = 'Suspended' 
		THEN 1 
		ELSE 0
	  END AS  Historic_SuspendedCount
	, CASE 
		WHEN dw_cst.[CaseStatus] IN ('New Referral','Active Support','Enquiry') 
		THEN 1 
		ELSE 0
	  END AS Historic_ActiveCount
	, ds_case_PIT.AttritionCount												AS Historic_AttritionCount
	, ds_case_PIT.AttritionHistoryCount											AS Historic_AttritionHistoryCount
	, ds_case_PIT.AttritionDisengagedCount										AS Historic_AttritionDisengagedCount
	, ds_case_PIT.AttritionDisengagedHistoryCount								AS Historic_AttritionDisengagedHistoryCount
	, ds_case_PIT.AttritionLeftJobCount											AS Historic_AttritionLeftJobCount
	, ds_case_PIT.AttritionLeftJobHistoryCount									AS Historic_AttritionLeftJobHistoryCount
	, ds_case_PIT.AttritionCovidCount											AS Historic_AttritionCovidCount
	, ds_case_PIT.AttritionCovidHistoryCount									AS Historic_AttritionCovidHistoryCount

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
    , dw_f_ca.[CaseCount]
    , dw_f_ca.[CurrentStage_Skey]
    , dw_f_ca.[SuspendedCount]
	, dw_f_ca.[ActiveCount]

    , SLAs.[NewEnquiry]
    , SLAs.[ReferralCallRequired]
    , SLAs.[ReferralCallBackAttempt1]
    , SLAs.[ReferralCallBackAttempt2]
    , SLAs.[ReferralCallBackAttempt3]
	, SLAs.[LiveEnquiry]
    , SLAs.[UnsuccessfulEnquiry]
    , SLAs.[SuccessfulEnquiry]
    , SLAs.[AwaitingReferral]
    , SLAs.[ReferralReceived]
    , SLAs.[EmailreferraltoDWP]
    , SLAs.[ReferralApproved]
    , SLAs.[ReferralUnsuccessful]
    , SLAs.[InitialContact]
    , SLAs.[AwaitingTelephoneAssessmentMeetingSchedule]
    , SLAs.[TelephoneAssessmentscheduled]
    , SLAs.[TelephoneAssessmentCompleted]
    , SLAs.[AwaitingSupportPlanmeetingscheduled]
    , SLAs.[Supportplanmeetingscheduled]
    , SLAs.[Supportplanmeetingcompleted]
    , SLAs.[Supportplansignedbycustomer]
    , SLAs.[SupportplanUploaded]
    , SLAs.[SupportplancompletedbutnotsubmittedtoDWP]
    , SLAs.[SupportplansubmittedtoDWP]
    , SLAs.[SupportPlanNotApprovedbyDWP]
    , SLAs.[AwaitingSupportPlanReSubmission]
    , SLAs.[SupportPlanReSubmitted]
    , SLAs.[SupportplanapprovedbyDWP]
    , SLAs.[SupportplanpaidbyDWP]
    , SLAs.[Month1updateoutstanding]
    , SLAs.[Month1updatecompleted]
    , SLAs.[Month1BOTUpdateCompleted]
    , SLAs.[Month1updatesubmittedtoDWP]
    , SLAs.[Month2updateoutstanding]
    , SLAs.[Month2updatecompleted]
    , SLAs.[Month2BOTUpdateCompleted]
    , SLAs.[Month2updatesubmittedtoDWP]
    , SLAs.[Month3updateoutstanding]
    , SLAs.[Month3updatecompleted]
    , SLAs.[Month3BOTUpdateCompleted]
    , SLAs.[Month3updatesubmittedtoDWP]
    , SLAs.[Month4updateoutstanding]
    , SLAs.[Month4updatecompleted]
    , SLAs.[Month4BOTUpdateCompleted]
    , SLAs.[Month4updatesubmittedtoDWP]
    , SLAs.[Month5updateoutstanding]
    , SLAs.[Month5updatecompleted]
    , SLAs.[Month5BOTUpdateCompleted]
    , SLAs.[Month5updatesubmittedtoDWP]
    , SLAs.[Awaiting6MonthSupportPlanmeetingscheduled]
    , SLAs.[Month6Supportplanmeetingscheduled]
    , SLAs.[Month6Supportplanmeetingcompleted]
    , SLAs.[Month6Supportplansignedbycustomer]
    , SLAs.[Month6SupportplanUploaded]
    , SLAs.[Month6SupportplancompletedbutnotsubmittedtoDWP]
    , SLAs.[Month6SupportplansubmittedtoDWP]
    , SLAs.[Month6SupportPlanNotApprovedbyDWP]
    , SLAs.[AwaitingMonth6SupportPlanReSubmission]
    , SLAs.[Month6SupportPlanReSubmitted]
    , SLAs.[Month6SupportplanapprovedbyDWP]
    , SLAs.[Month6SupportplanpaidbyDWP]
    , SLAs.[AwaitingTransferToBSC]
    , SLAs.[TransferredToBSC]
    , SLAs.[LightTouchEmailSentUnsuccessful]
    , SLAs.[LightTouchEmailSentSuccessful]
    , SLAs.[AwaitingMonth7Contact]
    , SLAs.[Month7ContactSuccessful]
    , SLAs.[Month7ContactUnsuccessful]
    , SLAs.[AwaitingMonth8Contact]
    , SLAs.[Month8ContactSuccessful]
    , SLAs.[Month8ContactUnsuccessful]
    , SLAs.[Awaiting9MonthReportmeetingscheduled]
    , SLAs.[NineMonthReportmeetingscheduled]
    , SLAs.[NineMonthReportmeetingcompleted]
    , SLAs.[NineMonthReportsignedbycustomer]
    , SLAs.[NineMonthReportUploaded]
    , SLAs.[NineMonthReportcompletedbutnotsubmittedtoDWP]
    , SLAs.[NineMonthReportsubmittedtoDWP]
    , SLAs.[NineMonthReportNotApprovedbyDWP]
    , SLAs.[Awaiting9MonthReportReSubmission]
    , SLAs.[NineMonthReportReSubmitted]
    , SLAs.[NineMonthReportapprovedbyDWP]
    , SLAs.[NineMonthReportpaidbyDWP]
    , SLAs.[Rejected]
    , SLAs.[MarketingCampaignAttempted]
    , SLAs.[Month7ContactAttempted]
    , SLAs.[Month8ContactAttempted]
    , SLAs.[Month1UpdateSuccessful]
    , SLAs.[Month2UpdateSuccessful]
    , SLAs.[Month3UpdateSuccessful]
    , SLAs.[Month4UpdateSuccessful]
    , SLAs.[Month5UpdateSuccessful]

    , SLAs.[NewEnquiryCompletedWithinSLA]
    , SLAs.[ReferralCallRequiredCompletedWithinSLA]
    , SLAs.[ReferralCallBackAttempt1CompletedWithinSLA]
    , SLAs.[ReferralCallBackAttempt2CompletedWithinSLA]
    , SLAs.[ReferralCallBackAttempt3CompletedWithinSLA]
    , SLAs.[LiveEnquiryCompletedWithinSLA]
	, SLAs.[UnsuccessfulEnquiryCompletedWithinSLA]
    , SLAs.[SuccessfulEnquiryCompletedWithinSLA]
    , SLAs.[AwaitingReferralCompletedWithinSLA]
    , SLAs.[ReferralReceivedCompletedWithinSLA]
    , SLAs.[EmailreferraltoDWPCompletedWithinSLA]
    , SLAs.[ReferralApprovedCompletedWithinSLA]
    , SLAs.[ReferralUnsuccessfulCompletedWithinSLA]
    , SLAs.[InitialContactCompletedWithinSLA]
    , SLAs.[AwaitingTelephoneAssessmentMeetingScheduleCompletedWithinSLA]
    , SLAs.[TelephoneAssessmentscheduledCompletedWithinSLA]
    , SLAs.[TelephoneAssessmentCompletedCompletedWithinSLA]
    , SLAs.[AwaitingSupportPlanmeetingscheduledCompletedWithinSLA]
    , SLAs.[SupportplanmeetingscheduledCompletedWithinSLA]
    , SLAs.[SupportplanmeetingcompletedCompletedWithinSLA]
    , SLAs.[SupportplansignedbycustomerCompletedWithinSLA]
    , SLAs.[SupportplanUploadedCompletedWithinSLA]
    , SLAs.[SupportplancompletedbutnotsubmittedtoDWPCompletedWithinSLA]
    , SLAs.[SupportplansubmittedtoDWPCompletedWithinSLA]
    , SLAs.[SupportPlanNotApprovedbyDWPCompletedWithinSLA]
    , SLAs.[AwaitingSupportPlanReSubmissionCompletedWithinSLA]
    , SLAs.[SupportPlanReSubmittedCompletedWithinSLA]
    , SLAs.[SupportplanapprovedbyDWPCompletedWithinSLA]
    , SLAs.[SupportplanpaidbyDWPCompletedWithinSLA]
    , SLAs.[Month1updateoutstandingCompletedWithinSLA]
    , SLAs.[Month1updatecompletedCompletedWithinSLA]
    , SLAs.[Month1BOTUpdateCompletedCompletedWithinSLA]
    , SLAs.[Month1updatesubmittedtoDWPCompletedWithinSLA]
    , SLAs.[Month2updateoutstandingCompletedWithinSLA]
    , SLAs.[Month2updatecompletedCompletedWithinSLA]
    , SLAs.[Month2BOTUpdateCompletedCompletedWithinSLA]
    , SLAs.[Month2updatesubmittedtoDWPCompletedWithinSLA]
    , SLAs.[Month3updateoutstandingCompletedWithinSLA]
    , SLAs.[Month3updatecompletedCompletedWithinSLA]
    , SLAs.[Month3BOTUpdateCompletedCompletedWithinSLA]
    , SLAs.[Month3updatesubmittedtoDWPCompletedWithinSLA]
    , SLAs.[Month4updateoutstandingCompletedWithinSLA]
    , SLAs.[Month4updatecompletedCompletedWithinSLA]
    , SLAs.[Month4BOTUpdateCompletedCompletedWithinSLA]
    , SLAs.[Month4updatesubmittedtoDWPCompletedWithinSLA]
    , SLAs.[Month5updateoutstandingCompletedWithinSLA]
    , SLAs.[Month5updatecompletedCompletedWithinSLA]
    , SLAs.[Month5BOTUpdateCompletedCompletedWithinSLA]
    , SLAs.[Month5updatesubmittedtoDWPCompletedWithinSLA]
    , SLAs.[Awaiting6MonthSupportPlanmeetingscheduledCompletedWithinSLA]
    , SLAs.[Month6SupportplanmeetingscheduledCompletedWithinSLA]
    , SLAs.[Month6SupportplanmeetingcompletedCompletedWithinSLA]
    , SLAs.[Month6SupportplansignedbycustomerCompletedWithinSLA]
    , SLAs.[Month6SupportplanUploadedCompletedWithinSLA]
    , SLAs.[Month6SupportplancompletedbutnotsubmittedtoDWPCompletedWithinSLA]
    , SLAs.[Month6SupportplansubmittedtoDWPCompletedWithinSLA]
    , SLAs.[Month6SupportPlanNotApprovedbyDWPCompletedWithinSLA]
    , SLAs.[AwaitingMonth6SupportPlanReSubmissionCompletedWithinSLA]
    , SLAs.[Month6SupportPlanReSubmittedCompletedWithinSLA]
    , SLAs.[Month6SupportplanapprovedbyDWPCompletedWithinSLA]
    , SLAs.[Month6SupportplanpaidbyDWPCompletedWithinSLA]
    , SLAs.[AwaitingTransferToBSCCompletedWithinSLA]
    , SLAs.[TransferredToBSCCompletedWithinSLA]
    , SLAs.[LightTouchEmailSentUnsuccessfulCompletedWithinSLA]
    , SLAs.[LightTouchEmailSentSuccessfulCompletedWithinSLA]
    , SLAs.[AwaitingMonth7ContactCompletedWithinSLA]
    , SLAs.[Month7ContactSuccessfulCompletedWithinSLA]
    , SLAs.[Month7ContactUnsuccessfulCompletedWithinSLA]
    , SLAs.[AwaitingMonth8ContactCompletedWithinSLA]
    , SLAs.[Month8ContactSuccessfulCompletedWithinSLA]
    , SLAs.[Month8ContactUnsuccessfulCompletedWithinSLA]
    , SLAs.[Awaiting9MonthReportmeetingscheduledCompletedWithinSLA]
    , SLAs.[NineMonthReportmeetingscheduledCompletedWithinSLA]
    , SLAs.[NineMonthReportmeetingcompletedCompletedWithinSLA]
    , SLAs.[NineMonthReportsignedbycustomerCompletedWithinSLA]
    , SLAs.[NineMonthReportUploadedCompletedWithinSLA]
    , SLAs.[NineMonthReportcompletedbutnotsubmittedtoDWPCompletedWithinSLA]
    , SLAs.[NineMonthReportsubmittedtoDWPCompletedWithinSLA]
    , SLAs.[NineMonthReportNotApprovedbyDWPCompletedWithinSLA]
    , SLAs.[Awaiting9MonthReportReSubmissionCompletedWithinSLA]
    , SLAs.[NineMonthReportReSubmittedCompletedWithinSLA]
    , SLAs.[NineMonthReportapprovedbyDWPCompletedWithinSLA]
    , SLAs.[NineMonthReportpaidbyDWPCompletedWithinSLA]
    , SLAs.[RejectedCompletedWithinSLA]
    , SLAs.[MarketingCampaignAttemptedCompletedWithinSLA]
    , SLAs.[Month7ContactAttemptedCompletedWithinSLA]
    , SLAs.[Month8ContactAttemptedCompletedWithinSLA]
    , SLAs.[Month1UpdateSuccessfulCompletedWithinSLA]
    , SLAs.[Month2UpdateSuccessfulCompletedWithinSLA]
    , SLAs.[Month3UpdateSuccessfulCompletedWithinSLA]
    , SLAs.[Month4UpdateSuccessfulCompletedWithinSLA]
    , SLAs.[Month5UpdateSuccessfulCompletedWithinSLA]

    , SLAs.[NewEnquiryOutsideSLA]
    , SLAs.[ReferralCallRequiredOutsideSLA]
    , SLAs.[ReferralCallBackAttempt1OutsideSLA]
    , SLAs.[ReferralCallBackAttempt2OutsideSLA]
    , SLAs.[ReferralCallBackAttempt3OutsideSLA]
    , SLAs.[LiveEnquiryOutsideSLA]
	, SLAs.[UnsuccessfulEnquiryOutsideSLA]
    , SLAs.[SuccessfulEnquiryOutsideSLA]
    , SLAs.[AwaitingReferralOutsideSLA]
    , SLAs.[ReferralReceivedOutsideSLA]
    , SLAs.[EmailreferraltoDWPOutsideSLA]
    , SLAs.[ReferralApprovedOutsideSLA]
    , SLAs.[ReferralUnsuccessfulOutsideSLA]
    , SLAs.[InitialContactOutsideSLA]
    , SLAs.[AwaitingTelephoneAssessmentMeetingScheduleOutsideSLA]
    , SLAs.[TelephoneAssessmentscheduledOutsideSLA]
    , SLAs.[TelephoneAssessmentCompletedOutsideSLA]
    , SLAs.[AwaitingSupportPlanmeetingscheduledOutsideSLA]
    , SLAs.[SupportplanmeetingscheduledOutsideSLA]
    , SLAs.[SupportplanmeetingcompletedOutsideSLA]
    , SLAs.[SupportplansignedbycustomerOutsideSLA]
    , SLAs.[SupportplanUploadedOutsideSLA]
    , SLAs.[SupportplancompletedbutnotsubmittedtoDWPOutsideSLA]
    , SLAs.[SupportplansubmittedtoDWPOutsideSLA]
    , SLAs.[SupportPlanNotApprovedbyDWPOutsideSLA]
    , SLAs.[AwaitingSupportPlanReSubmissionOutsideSLA]
    , SLAs.[SupportPlanReSubmittedOutsideSLA]
    , SLAs.[SupportplanapprovedbyDWPOutsideSLA]
    , SLAs.[SupportplanpaidbyDWPOutsideSLA]
    , SLAs.[Month1updateoutstandingOutsideSLA]
    , SLAs.[Month1updatecompletedOutsideSLA]
    , SLAs.[Month1BOTUpdateCompletedOutsideSLA]
    , SLAs.[Month1updatesubmittedtoDWPOutsideSLA]
    , SLAs.[Month2updateoutstandingOutsideSLA]
    , SLAs.[Month2updatecompletedOutsideSLA]
    , SLAs.[Month2BOTUpdateCompletedOutsideSLA]
    , SLAs.[Month2updatesubmittedtoDWPOutsideSLA]
    , SLAs.[Month3updateoutstandingOutsideSLA]
    , SLAs.[Month3updatecompletedOutsideSLA]
    , SLAs.[Month3BOTUpdateCompletedOutsideSLA]
    , SLAs.[Month3updatesubmittedtoDWPOutsideSLA]
    , SLAs.[Month4updateoutstandingOutsideSLA]
    , SLAs.[Month4updatecompletedOutsideSLA]
    , SLAs.[Month4BOTUpdateCompletedOutsideSLA]
    , SLAs.[Month4updatesubmittedtoDWPOutsideSLA]
    , SLAs.[Month5updateoutstandingOutsideSLA]
    , SLAs.[Month5updatecompletedOutsideSLA]
    , SLAs.[Month5BOTUpdateCompletedOutsideSLA]
    , SLAs.[Month5updatesubmittedtoDWPOutsideSLA]
    , SLAs.[Awaiting6MonthSupportPlanmeetingscheduledOutsideSLA]
    , SLAs.[Month6SupportplanmeetingscheduledOutsideSLA]
    , SLAs.[Month6SupportplanmeetingcompletedOutsideSLA]
    , SLAs.[Month6SupportplansignedbycustomerOutsideSLA]
    , SLAs.[Month6SupportplanUploadedOutsideSLA]
    , SLAs.[Month6SupportplancompletedbutnotsubmittedtoDWPOutsideSLA]
    , SLAs.[Month6SupportplansubmittedtoDWPOutsideSLA]
    , SLAs.[Month6SupportPlanNotApprovedbyDWPOutsideSLA]
    , SLAs.[AwaitingMonth6SupportPlanReSubmissionOutsideSLA]
    , SLAs.[Month6SupportPlanReSubmittedOutsideSLA]
    , SLAs.[Month6SupportplanapprovedbyDWPOutsideSLA]
    , SLAs.[Month6SupportplanpaidbyDWPOutsideSLA]
    , SLAs.[AwaitingTransferToBSCOutsideSLA]
    , SLAs.[TransferredToBSCOutsideSLA]
    , SLAs.[LightTouchEmailSentUnsuccessfulOutsideSLA]
    , SLAs.[LightTouchEmailSentSuccessfulOutsideSLA]
    , SLAs.[AwaitingMonth7ContactOutsideSLA]
    , SLAs.[Month7ContactSuccessfulOutsideSLA]
    , SLAs.[Month7ContactUnsuccessfulOutsideSLA]
    , SLAs.[AwaitingMonth8ContactOutsideSLA]
    , SLAs.[Month8ContactSuccessfulOutsideSLA]
    , SLAs.[Month8ContactUnsuccessfulOutsideSLA]
    , SLAs.[Awaiting9MonthReportmeetingscheduledOutsideSLA]
    , SLAs.[NineMonthReportmeetingscheduledOutsideSLA]
    , SLAs.[NineMonthReportmeetingcompletedOutsideSLA]
    , SLAs.[NineMonthReportsignedbycustomerOutsideSLA]
    , SLAs.[NineMonthReportUploadedOutsideSLA]
    , SLAs.[NineMonthReportcompletedbutnotsubmittedtoDWPOutsideSLA]
    , SLAs.[NineMonthReportsubmittedtoDWPOutsideSLA]
    , SLAs.[NineMonthReportNotApprovedbyDWPOutsideSLA]
    , SLAs.[Awaiting9MonthReportReSubmissionOutsideSLA]
    , SLAs.[NineMonthReportReSubmittedOutsideSLA]
    , SLAs.[NineMonthReportapprovedbyDWPOutsideSLA]
    , SLAs.[NineMonthReportpaidbyDWPOutsideSLA]
    , SLAs.[RejectedOutsideSLA]
    , SLAs.[MarketingCampaignAttemptedCompletedOutsideSLA]
    , SLAs.[Month7ContactAttemptedCompletedOutsideSLA]
    , SLAs.[Month8ContactAttemptedCompletedOutsideSLA]
    , SLAs.[Month1UpdateSuccessfulCompletedOutsideSLA]
    , SLAs.[Month2UpdateSuccessfulCompletedOutsideSLA]
    , SLAs.[Month3UpdateSuccessfulCompletedOutsideSLA]
    , SLAs.[Month4UpdateSuccessfulCompletedOutsideSLA]
    , SLAs.[Month5UpdateSuccessfulCompletedOutsideSLA]

    , SLAs.[NewEnquiryOverdue]
    , SLAs.[ReferralCallRequiredOverdue]
    , SLAs.[ReferralCallBackAttempt1Overdue]
    , SLAs.[ReferralCallBackAttempt2Overdue]
    , SLAs.[ReferralCallBackAttempt3Overdue]
    , SLAs.[LiveEnquiryOverdue]
	, SLAs.[UnsuccessfulEnquiryOverdue]
    , SLAs.[SuccessfulEnquiryOverdue]
    , SLAs.[AwaitingReferralOverdue]
    , SLAs.[ReferralReceivedOverdue]
    , SLAs.[EmailreferraltoDWPOverdue]
    , SLAs.[ReferralApprovedOverdue]
    , SLAs.[ReferralUnsuccessfulOverdue]
    , SLAs.[InitialContactOverdue]
    , SLAs.[AwaitingTelephoneAssessmentMeetingScheduleOverdue]
    , SLAs.[TelephoneAssessmentscheduledOverdue]
    , SLAs.[TelephoneAssessmentCompletedOverdue]
    , SLAs.[AwaitingSupportPlanmeetingscheduledOverdue]
    , SLAs.[SupportplanmeetingscheduledOverdue]
    , SLAs.[SupportplanmeetingcompletedOverdue]
    , SLAs.[SupportplansignedbycustomerOverdue]
    , SLAs.[SupportplanUploadedOverdue]
    , SLAs.[SupportplancompletedbutnotsubmittedtoDWPOverdue]
    , SLAs.[SupportplansubmittedtoDWPOverdue]
    , SLAs.[SupportPlanNotApprovedbyDWPOverdue]
    , SLAs.[AwaitingSupportPlanReSubmissionOverdue]
    , SLAs.[SupportPlanReSubmittedOverdue]
    , SLAs.[SupportplanapprovedbyDWPOverdue]
    , SLAs.[SupportplanpaidbyDWPOverdue]
    , SLAs.[Month1updateoutstandingOverdue]
    , SLAs.[Month1updatecompletedOverdue]
    , SLAs.[Month1BOTUpdateCompletedOverdue]
    , SLAs.[Month1updatesubmittedtoDWPOverdue]
    , SLAs.[Month2updateoutstandingOverdue]
    , SLAs.[Month2updatecompletedOverdue]
    , SLAs.[Month2BOTUpdateCompletedOverdue]
    , SLAs.[Month2updatesubmittedtoDWPOverdue]
    , SLAs.[Month3updateoutstandingOverdue]
    , SLAs.[Month3updatecompletedOverdue]
    , SLAs.[Month3BOTUpdateCompletedOverdue]
    , SLAs.[Month3updatesubmittedtoDWPOverdue]
    , SLAs.[Month4updateoutstandingOverdue]
    , SLAs.[Month4updatecompletedOverdue]
    , SLAs.[Month4BOTUpdateCompletedOverdue]
    , SLAs.[Month4updatesubmittedtoDWPOverdue]
    , SLAs.[Month5updateoutstandingOverdue]
    , SLAs.[Month5updatecompletedOverdue]
    , SLAs.[Month5BOTUpdateCompletedOverdue]
    , SLAs.[Month5updatesubmittedtoDWPOverdue]
    , SLAs.[Awaiting6MonthSupportPlanmeetingscheduledOverdue]
    , SLAs.[Month6SupportplanmeetingscheduledOverdue]
    , SLAs.[Month6SupportplanmeetingcompletedOverdue]
    , SLAs.[Month6SupportplansignedbycustomerOverdue]
    , SLAs.[Month6SupportplanUploadedOverdue]
    , SLAs.[Month6SupportplancompletedbutnotsubmittedtoDWPOverdue]
    , SLAs.[Month6SupportplansubmittedtoDWPOverdue]
    , SLAs.[Month6SupportPlanNotApprovedbyDWPOverdue]
    , SLAs.[AwaitingMonth6SupportPlanReSubmissionOverdue]
    , SLAs.[Month6SupportPlanReSubmittedOverdue]
    , SLAs.[Month6SupportplanapprovedbyDWPOverdue]
    , SLAs.[Month6SupportplanpaidbyDWPOverdue]
    , SLAs.[AwaitingTransferToBSCOverdue]
    , SLAs.[TransferredToBSCOverdue]
    , SLAs.[LightTouchEmailSentUnsuccessfulOverdue]
    , SLAs.[LightTouchEmailSentSuccessfulOverdue]
    , SLAs.[AwaitingMonth7ContactOverdue]
    , SLAs.[Month7ContactSuccessfulOverdue]
    , SLAs.[Month7ContactUnsuccessfulOverdue]
    , SLAs.[AwaitingMonth8ContactOverdue]
    , SLAs.[Month8ContactSuccessfulOverdue]
    , SLAs.[Month8ContactUnsuccessfulOverdue]
    , SLAs.[Awaiting9MonthReportmeetingscheduledOverdue]
    , SLAs.[NineMonthReportmeetingscheduledOverdue]
    , SLAs.[NineMonthReportmeetingcompletedOverdue]
    , SLAs.[NineMonthReportsignedbycustomerOverdue]
    , SLAs.[NineMonthReportUploadedOverdue]
    , SLAs.[NineMonthReportcompletedbutnotsubmittedtoDWPOverdue]
    , SLAs.[NineMonthReportsubmittedtoDWPOverdue]
    , SLAs.[NineMonthReportNotApprovedbyDWPOverdue]
    , SLAs.[Awaiting9MonthReportReSubmissionOverdue]
    , SLAs.[NineMonthReportReSubmittedOverdue]
    , SLAs.[NineMonthReportapprovedbyDWPOverdue]
    , SLAs.[NineMonthReportpaidbyDWPOverdue]
    , SLAs.[RejectedOverdue]
    , SLAs.[MarketingCampaignAttemptedOverdue]
    , SLAs.[Month7ContactAttemptedOverdue]
    , SLAs.[Month8ContactAttemptedOverdue]
    , SLAs.[Month1UpdateSuccessfulOverdue]
    , SLAs.[Month2UpdateSuccessfulOverdue]
    , SLAs.[Month3UpdateSuccessfulOverdue]
    , SLAs.[Month4UpdateSuccessfulOverdue]
    , SLAs.[Month5UpdateSuccessfulOverdue]

	, SLAs.[SupportplanUploadedEmployee_Skey]
	, SLAs.[Month6SupportplanUploadedEmployee_Skey]
	, SLAs.[NineMonthReportUploadedEmployee_Skey]
FROM
	DW.F_Case_Analysis dw_f_ca
	INNER JOIN  stg.DW_F_AtW_Case_Daily_Analysis_TEMP4 SLAs
		ON dw_f_ca.Case_Analysis_Skey = SLAs.Case_Analysis_Skey 
	LEFT JOIN DW.LNK_Work_Flow_Stages dw_lnk_wfs 
			INNER JOIN DW.D_Date dw_d_st_dt ON dw_lnk_wfs.WorkFlowStartDate_Skey = dw_d_st_dt.Date_Skey
			INNER JOIN DW.D_Date dw_d_end_dt ON dw_lnk_wfs.WorkFlowEndDate_Skey = dw_d_end_dt.Date_Skey
			INNER JOIN DW.D_Time dw_d_st_tm ON dw_lnk_wfs.WorkFlowStartTime_Skey = dw_d_st_tm.Time_Skey
			INNER JOIN DW.D_Time dw_d_end_tm ON dw_lnk_wfs.WorkFlowEndTime_Skey = dw_d_end_tm.Time_Skey
		ON SLAs.Case_Analysis_Skey  = dw_lnk_wfs.Case_Analysis_Skey
		AND CONVERT(datetime, CAST(SLAs.SnapshotDate AS CHAR(8)), 101) + '23:59:59' 
			BETWEEN CAST(dw_d_st_dt.[Date] AS DATETIME) + CAST(dw_d_st_tm.[Time] AS DATETIME) AND CAST(dw_d_end_dt.[Date] AS DATETIME) + CAST(dw_d_end_tm.[Time] AS DATETIME)
	INNER JOIN DW.D_Case dw_case ON dw_f_ca.Case_Skey = dw_case.Case_Skey
	INNER JOIN DS.[Cases] ds_case ON ds_case.CaseID = dw_case.CaseBusKey
	LEFT JOIN 
		(SELECT 
		  ds_case_PIT.CaseBusKey
		, ds_case_PIT.CaseStatusID 
		, ds_case_PIT.CaseClosedDate
		, ds_case_PIT.AttritionCount					
		, ds_case_PIT.AttritionHistoryCount				
		, ds_case_PIT.AttritionDisengagedCount			
		, ds_case_PIT.AttritionDisengagedHistoryCount	
		, ds_case_PIT.AttritionLeftJobCount				
		, ds_case_PIT.AttritionLeftJobHistoryCount		
		, ds_case_PIT.AttritionCovidCount				
		, ds_case_PIT.AttritionCovidHistoryCount	
		, ds_case_PIT.Sys_LoadDate
		, ds_case_PIT.Sys_LoadExpiryDate
	    , MIN(Sys_LoadDate) OVER (PARTITION BY CaseReferenceKey) AS FirstRowLoadDate
			  --, MIN(Sys_LoadExpiryDate) OVER (PARTITION BY CaseReferenceKey) AS FirstRowLoadExpiryDate
			  , ROW_NUMBER() OVER (PARTITION BY CaseReferenceKey ORDER BY Sys_LoadDate ASC) AS  rn
		 FROM DS.[Cases] ds_case_PIT 
		 )	ds_case_PIT 
			ON ds_case.CaseBusKey = ds_case_PIT.CaseBusKey  -- Get the relevant case record at that Point in Time. Used 23:59:59 to get the final point on the snapshot day. --
			AND 1 =
			 CASE WHEN (CONVERT(datetime, CAST(SLAs.SnapshotDate AS CHAR(8)), 101) + '23:59:59' < ds_case_PIT.FirstRowLoadDate AND (ds_case_PIT.rn = 1)) THEN 1
				WHEN	
				((CONVERT(datetime, CAST(SLAs.SnapshotDate AS CHAR(8)), 101) + '23:59:59' >= ds_case_PIT.FirstRowLoadDate) 
			   AND (CONVERT(datetime, CAST(SLAs.SnapshotDate AS CHAR(8)), 101) + '23:59:59' BETWEEN ds_case_PIT.Sys_LoadDate AND ds_case_PIT.Sys_LoadExpiryDate) ) THEN 1
			END
		LEFT JOIN DW.D_Case_Status dw_cst ON dw_cst.CaseStatusBusKey = ds_case_PIT.CaseStatusID

-- Create NOT NULL constraint on temp
--alter table stg.DW_F_AtW_Case_Daily_Analysis_TEMP
--ALTER COLUMN Work_Flow_Events_Skey INT NOT NULL

-- Create primary key on temp
---alter table stg.DW_F_AtW_Case_Daily_Analysis_TEMP
--ADD CONSTRAINT PK_DW_F_AtW_Case_Daily_Analysis PRIMARY KEY NONCLUSTERED (Work_Flow_Events_Skey) NOT ENFORCED

---- Switch table contents replacing target with temp.

ALTER TABLE DW.F_AtW_Case_Daily_Analysis           switch to OLD.DW_F_AtW_Case_Daily_Analysis with (truncate_target=on);
ALTER TABLE stg.DW_F_AtW_Case_Daily_Analysis_TEMP5 switch to DW.F_AtW_Case_Daily_Analysis     with (truncate_target=on);

DROP TABLE stg.DW_F_AtW_Case_Daily_Analysis_TEMP;
DROP TABLE stg.DW_F_AtW_Case_Daily_Analysis_TEMP1;
DROP TABLE stg.DW_F_AtW_Case_Daily_Analysis_TEMP2;
DROP TABLE stg.DW_F_AtW_Case_Daily_Analysis_TEMP3;
DROP TABLE stg.DW_F_AtW_Case_Daily_Analysis_TEMP4;
DROP TABLE stg.DW_F_AtW_Case_Daily_Analysis_TEMP5;

UPDATE ELT.Load_Control_Table
SET Load_Date = CAST(DATEADD(d,-7,GETDATE()) AS DATE)
WHERE TableName = 'DW.F_AtW_Case_Daily_Analysis';

---- Force replication of table.
--select COUNT(*) from DW.[F_AtW_Case_Daily_Analysis] order by 1;


--drop table DW.F_AtW_Case_Daily_Analysis
--drop table OLD.DW_F_AtW_Case_Daily_Analysis

--CREATE TABLE DW.F_AtW_Case_Daily_Analysis
--        WITH (clustered columnstore index, distribution = hash(Case_Analysis_Skey)) 
--AS
--select * from stg.DW_F_AtW_Case_Daily_Analysis_TEMP5 WHERE 1=0

--CREATE TABLE OLD.DW_F_AtW_Case_Daily_Analysis
--        WITH (clustered columnstore index, distribution = hash(Case_Analysis_Skey)) 
--AS
--select * from stg.DW_F_AtW_Case_Daily_Analysis_TEMP5 WHERE 1=0