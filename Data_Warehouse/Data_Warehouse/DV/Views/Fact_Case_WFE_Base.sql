CREATE VIEW [DV].[Fact_Case_WFE_Base] AS SELECT
        [CaseHash]
       ,SUM(CASE WHEN WorkFlowEventName = 'Initial Contact' and f_wfea.EventDate  <> -1	THEN 1 END)										AS Sum_Initial_Contact
	   ,MIN(CASE WHEN WorkFlowEventName = 'Initial Contact'	and f_wfea.EventDate  <> -1 THEN f_wfea.EventDate END)						AS First_Initial_Contact
       ,MAX(CASE WHEN WorkFlowEventName = 'Initial Contact'	and f_wfea.EventDate  <> -1 THEN f_wfea.EventDate END)						AS Last_Initial_Contact
	   ,MIN(CASE WHEN WorkFlowEventName = 'Initial Contact' THEN EventEstimatedStartDate END)											AS Initial_Contact_EstimatedStartDate_Skey
	   ,MIN(CASE WHEN WorkFlowEventName = 'Initial Contact' THEN EventEstimatedEndDate END)												AS Initial_Contact_EstimatedEndDate_Skey
	   ,COUNT ( DISTINCT (CASE WHEN WorkFlowEventName = 'Initial Contact' and f_wfea.EventDate  <> -1 THEN	[CaseHash]   END))			AS Is_Initial_Contact

	   ,SUM(CASE WHEN WorkFlowEventName = 'PRaP Referral' and f_wfea.EventDate  <> -1	THEN 1 END)										AS Sum_PRaP_Referral
	   ,MIN(CASE WHEN WorkFlowEventName = 'PRaP Referral' and f_wfea.EventDate  <> -1	THEN f_wfea.EventDate END)						AS First_PRaP_Referral
       ,MAX(CASE WHEN WorkFlowEventName = 'PRaP Referral' and f_wfea.EventDate  <> -1	THEN f_wfea.EventDate END)						AS Last_PRaP_Referral
	   ,MIN(CASE WHEN WorkFlowEventName = 'PRaP Referral' THEN EventEstimatedStartDate END)												AS PRaP_Referral_EstimatedStartDate_Skey
	   ,MIN(CASE WHEN WorkFlowEventName = 'PRaP Referral' THEN EventEstimatedEndDate END)												AS PRaP_Referral_EstimatedEndDate_Skey
	   ,COUNT ( DISTINCT (CASE WHEN WorkFlowEventName = 'PRaP Referral' and f_wfea.EventDate  <> -1 THEN	[CaseHash]   END))			AS Is_PRaP_Referral

	   ,SUM(CASE WHEN WorkFlowEventName = 'Job Start Added' and f_wfea.EventDate  <> -1	THEN 1 END)										AS Sum_Job_Start_Added
	   ,MIN(CASE WHEN WorkFlowEventName = 'Job Start Added'	and f_wfea.EventDate  <> -1 THEN f_wfea.EventDate END)						AS First_Job_Start_Added
       ,MAX(CASE WHEN WorkFlowEventName = 'Job Start Added'	and f_wfea.EventDate  <> -1 THEN f_wfea.EventDate END)						AS Last_Job_Start_Added
	   ,MIN(CASE WHEN WorkFlowEventName = 'Job Start Added' THEN EventEstimatedStartDate END)											AS Job_Start_Added_EstimatedStartDate_Skey
	   ,MIN(CASE WHEN WorkFlowEventName = 'Job Start Added' THEN EventEstimatedEndDate END)												AS Job_Start_Added_EstimatedEndDate_Skey
	   ,COUNT ( DISTINCT (CASE WHEN WorkFlowEventName = 'Job Start Added' and f_wfea.EventDate  <> -1 THEN	[CaseHash]   END))			AS Is_Job_Start_Added

	   ,SUM(CASE WHEN WorkFlowEventName = 'Job Start Verified' and f_wfea.EventDate  <> -1 THEN 1 END)									AS Sum_Job_Start_Verified
	   ,MIN(CASE WHEN WorkFlowEventName = 'Job Start Verified' and f_wfea.EventDate  <> -1 THEN f_wfea.EventDate END)					AS First_Job_Start_Verified
       ,MAX(CASE WHEN WorkFlowEventName = 'Job Start Verified' and f_wfea.EventDate  <> -1 THEN f_wfea.EventDate END)					AS Last_Job_Start_Verified
	   ,MIN(CASE WHEN WorkFlowEventName = 'Job Start Verified' THEN EventEstimatedStartDate END)										AS Job_Start_Verified_EstimatedStartDate_Skey
	   ,MIN(CASE WHEN WorkFlowEventName = 'Job Start Verified' THEN EventEstimatedEndDate END)											AS Job_Start_Verified_EstimatedEndDate_Skey
	   ,COUNT ( DISTINCT (CASE WHEN WorkFlowEventName = 'Job Start Verified' and f_wfea.EventDate  <> -1 THEN	[CaseHash]   END))		AS Is_Job_Start_Verified

	   ,SUM(CASE WHEN WorkFlowEventName = 'Job Start Date' and f_wfea.EventDate  <> -1	THEN 1 END)										AS Sum_Job_Start_Date
	   ,MIN(CASE WHEN WorkFlowEventName = 'Job Start Date'	and f_wfea.EventDate  <> -1 THEN f_wfea.EventDate END)						AS First_Job_Start_Date
       ,MAX(CASE WHEN WorkFlowEventName = 'Job Start Date'	and f_wfea.EventDate  <> -1 THEN f_wfea.EventDate END)						AS Last_Job_Start_Date
	   ,MIN(CASE WHEN WorkFlowEventName = 'Job Start Date' THEN EventEstimatedStartDate END)											AS Job_Start_Date_EstimatedStartDate_Skey
	   ,MIN(CASE WHEN WorkFlowEventName = 'Job Start Date' THEN EventEstimatedEndDate END)												AS Job_Start_Date_EstimatedEndDate_Skey
	   ,COUNT ( DISTINCT (CASE WHEN WorkFlowEventName = 'Job Start Date' and f_wfea.EventDate  <> -1 THEN	[CaseHash]   END))			AS Is_Job_Start_Date

       ,SUM(CASE WHEN WorkFlowEventName = 'Action Plan' and f_wfea.EventDate  <> -1 THEN 1 END)											AS Sum_Action_Plan
       ,MIN(CASE WHEN WorkFlowEventName = 'Action Plan' and f_wfea.EventDate  <> -1 THEN f_wfea.EventDate END)							AS First_Action_Plan
       ,MAX(CASE WHEN WorkFlowEventName = 'Action Plan' and f_wfea.EventDate  <> -1 THEN f_wfea.EventDate END)							AS Last_Action_Plan
	   ,MIN(CASE WHEN WorkFlowEventName = 'Action Plan' THEN EventEstimatedStartDate END)												AS Action_Plan_EstimatedStartDate_Skey
	   ,MIN(CASE WHEN WorkFlowEventName = 'Action Plan' THEN EventEstimatedEndDate END)													AS Action_Plan_EstimatedEndDate_Skey
       ,COUNT ( DISTINCT (CASE WHEN WorkFlowEventName = 'Action Plan' and f_wfea.EventDate  <> -1 THEN [CaseHash]   END))				AS Is_Action_Plan

       ,SUM(CASE WHEN WorkFlowEventName = 'Earnings' and f_wfea.EventDate  <> -1 THEN 1 END)											AS Sum_Earnings
       ,MIN(CASE WHEN WorkFlowEventName = 'Earnings' and f_wfea.EventDate  <> -1 THEN f_wfea.EventDate END)								AS First_Earnings
       ,MAX(CASE WHEN WorkFlowEventName = 'Earnings' and f_wfea.EventDate  <> -1 THEN f_wfea.EventDate END)								AS Last_Earnings
	   ,MIN(CASE WHEN WorkFlowEventName = 'Earnings' THEN EventEstimatedStartDate END)													AS Earnings_EstimatedStartDate_Skey
	   ,MIN(CASE WHEN WorkFlowEventName = 'Earnings' THEN EventEstimatedEndDate END)													AS Earnings_EstimatedEndDate_Skey
       ,COUNT ( DISTINCT (CASE WHEN WorkFlowEventName = 'Earnings' and f_wfea.EventDate  <> -1 THEN [CaseHash]   END))					AS Is_Earnings

       ,SUM(CASE WHEN WorkFlowEventName = 'First Contact' and f_wfea.EventDate  <> -1 THEN 1 END)										AS Sum_First_Contact
       ,MIN(CASE WHEN WorkFlowEventName = 'First Contact' and f_wfea.EventDate  <> -1 THEN f_wfea.EventDate END)						AS First_First_Contact
       ,MAX(CASE WHEN WorkFlowEventName = 'First Contact' and f_wfea.EventDate  <> -1 THEN f_wfea.EventDate END)						AS Last_First_Contact
	   ,MIN(CASE WHEN WorkFlowEventName = 'First Contact' THEN EventEstimatedStartDate END)												AS First_Contact_EstimatedStartDate_Skey
	   ,MIN(CASE WHEN WorkFlowEventName = 'First Contact' THEN EventEstimatedEndDate END)												AS First_Contact_EstimatedEndDate_Skey
       ,COUNT ( DISTINCT (CASE WHEN WorkFlowEventName = 'First Contact' and f_wfea.EventDate  <> -1 THEN [CaseHash]   END))				AS Is_First_Contact

       ,SUM(CASE WHEN WorkFlowEventName = 'In Work Action Plan' and f_wfea.EventDate  <> -1 THEN 1 END)									AS Sum_In_Work_Action_Plan
       ,MIN(CASE WHEN WorkFlowEventName = 'In Work Action Plan' and f_wfea.EventDate  <> -1 THEN f_wfea.EventDate END)					AS First_In_Work_Action_Plan
       ,MAX(CASE WHEN WorkFlowEventName = 'In Work Action Plan' and f_wfea.EventDate  <> -1 THEN f_wfea.EventDate END)					AS Last_In_Work_Action_Plan
	   ,MIN(CASE WHEN WorkFlowEventName = 'In Work Action Plan' THEN EventEstimatedStartDate END)										AS In_Work_Action_Plan_EstimatedStartDate_Skey
	   ,MIN(CASE WHEN WorkFlowEventName = 'In Work Action Plan' THEN EventEstimatedEndDate END)											AS In_Work_Action_Plan_EstimatedEndDate_Skey
       ,COUNT ( DISTINCT (CASE WHEN WorkFlowEventName = 'In Work Action Plan' and f_wfea.EventDate  <> -1 THEN [CaseHash]   END))		AS Is_In_Work_Action_Plan

       ,SUM(CASE WHEN WorkFlowEventName = 'Initial Appointment' and f_wfea.EventDate  <> -1 THEN 1 END)									AS Sum_Initial_Appointment
       ,MIN(CASE WHEN WorkFlowEventName = 'Initial Appointment' and f_wfea.EventDate  <> -1 THEN f_wfea.EventDate END)					AS First_Initial_Appointment
       ,MAX(CASE WHEN WorkFlowEventName = 'Initial Appointment' and f_wfea.EventDate  <> -1 THEN f_wfea.EventDate END)					AS Last_Initial_Appointment
	   ,MIN(CASE WHEN WorkFlowEventName = 'Initial Appointment' THEN EventEstimatedStartDate END)										AS Initial_Appointment_EstimatedStartDate_Skey
	   ,MIN(CASE WHEN WorkFlowEventName = 'Initial Appointment' THEN EventEstimatedEndDate END)											AS Initial_Appointment_EstimatedEndDate_Skey
       ,COUNT ( DISTINCT (CASE WHEN WorkFlowEventName = 'Initial Appointment' and f_wfea.EventDate  <> -1 THEN [CaseHash]   END))		AS Is_Initial_Appointment

       ,SUM(CASE WHEN WorkFlowEventName = 'Interview' and f_wfea.EventDate  <> -1 THEN 1 END)											AS Sum_Interview
       ,MIN(CASE WHEN WorkFlowEventName = 'Interview' and f_wfea.EventDate  <> -1 THEN f_wfea.EventDate END)							AS First_Interview
       ,MAX(CASE WHEN WorkFlowEventName = 'Interview' and f_wfea.EventDate  <> -1 THEN f_wfea.EventDate END)							AS Last_Interview
	   ,MIN(CASE WHEN WorkFlowEventName = 'Interview' THEN EventEstimatedStartDate END)													AS Interview_EstimatedStartDate_Skey
	   ,MIN(CASE WHEN WorkFlowEventName = 'Interview' THEN EventEstimatedEndDate END)													AS Interview_EstimatedEndDate_Skey
       ,COUNT ( DISTINCT (CASE WHEN WorkFlowEventName = 'Interview' and f_wfea.EventDate  <> -1 THEN [CaseHash]   END))					AS Is_Interview

       ,SUM(CASE WHEN WorkFlowEventName = 'Job Start' and f_wfea.EventDate  <> -1 THEN 1 END)											AS Sum_Job_Start
       ,MIN(CASE WHEN WorkFlowEventName = 'Job Start' and f_wfea.EventDate  <> -1 THEN f_wfea.EventDate END)							AS First_Job_Start
       ,MAX(CASE WHEN WorkFlowEventName = 'Job Start' and f_wfea.EventDate  <> -1 THEN f_wfea.EventDate END)							AS Last_Job_Start
	   ,MIN(CASE WHEN WorkFlowEventName = 'Job Start' THEN EventEstimatedStartDate END)													AS Job_Start_EstimatedStartDate_Skey
	   ,MIN(CASE WHEN WorkFlowEventName = 'Job Start' THEN EventEstimatedEndDate END)													AS Job_Start_EstimatedEndDate_Skey
       ,COUNT ( DISTINCT (CASE WHEN WorkFlowEventName = 'Job Start' and f_wfea.EventDate  <> -1 THEN [CaseHash]   END))					AS Is_Job_Start

       ,SUM(CASE WHEN WorkFlowEventName = 'Missed Appointments' and f_wfea.EventDate  <> -1 THEN 1 END)									AS Sum_Missed_Appointments
       ,MIN(CASE WHEN WorkFlowEventName = 'Missed Appointments' and f_wfea.EventDate  <> -1 THEN f_wfea.EventDate END)					AS First_Missed_Appointments
       ,MAX(CASE WHEN WorkFlowEventName = 'Missed Appointments' and f_wfea.EventDate  <> -1 THEN f_wfea.EventDate END)					AS Last_Missed_Appointments
	   ,MIN(CASE WHEN WorkFlowEventName = 'Missed Appointments' THEN EventEstimatedStartDate END)										AS Missed_Appointments_EstimatedStartDate_Skey
	   ,MIN(CASE WHEN WorkFlowEventName = 'Missed Appointments' THEN EventEstimatedEndDate END)											AS Missed_Appointments_EstimatedEndDate_Skey
       ,COUNT ( DISTINCT (CASE WHEN WorkFlowEventName = 'Missed Appointments' and f_wfea.EventDate  <> -1 THEN [CaseHash]   END))		AS Is_Missed_Appointments

       ,SUM(CASE WHEN WorkFlowEventName = 'Offer Accepted' and f_wfea.EventDate  <> -1 THEN 1 END)										AS Sum_Offer_Accepted
       ,MIN(CASE WHEN WorkFlowEventName = 'Offer Accepted' and f_wfea.EventDate  <> -1 THEN f_wfea.EventDate END)						AS First_Offer_Accepted
       ,MAX(CASE WHEN WorkFlowEventName = 'Offer Accepted' and f_wfea.EventDate  <> -1 THEN f_wfea.EventDate END)						AS Last_Offer_Accepted
	   ,MIN(CASE WHEN WorkFlowEventName = 'Offer Accepted' THEN EventEstimatedStartDate END)											AS Offer_Accepted_EstimatedStartDate_Skey
	   ,MIN(CASE WHEN WorkFlowEventName = 'Offer Accepted' THEN EventEstimatedEndDate END)												AS Offer_Accepted_EstimatedEndDate_Skey
       ,COUNT ( DISTINCT (CASE WHEN WorkFlowEventName = 'Offer Accepted' and f_wfea.EventDate  <> -1 THEN [CaseHash]   END))			AS Is_Offer_Accepted

       ,SUM(CASE WHEN WorkFlowEventName = 'Programme Exit' and f_wfea.EventDate  <> -1 THEN 1 END)										AS Sum_Programme_Exit
       ,MIN(CASE WHEN WorkFlowEventName = 'Programme Exit' and f_wfea.EventDate  <> -1 THEN f_wfea.EventDate END)						AS First_Programme_Exit
       ,MAX(CASE WHEN WorkFlowEventName = 'Programme Exit' and f_wfea.EventDate  <> -1 THEN f_wfea.EventDate END)						AS Last_Programme_Exit
	   ,MIN(CASE WHEN WorkFlowEventName = 'Programme Exit' THEN EventEstimatedStartDate END)											AS Programme_Exit_EstimatedStartDate_Skey
	   ,MIN(CASE WHEN WorkFlowEventName = 'Programme Exit' THEN EventEstimatedEndDate END)												AS Programme_Exit_EstimatedEndDate_Skey
       ,COUNT ( DISTINCT (CASE WHEN WorkFlowEventName = 'Programme Exit' and f_wfea.EventDate  <> -1 THEN [CaseHash]   END))			AS Is_Programme_Exit

       ,SUM(CASE WHEN WorkFlowEventName = 'Programme Start' and f_wfea.EventDate  <> -1 THEN 1 END)										AS Sum_Programme_Start
       ,MIN(CASE WHEN WorkFlowEventName = 'Programme Start' and f_wfea.EventDate  <> -1 THEN f_wfea.EventDate END)						AS First_Programme_Start
       ,MAX(CASE WHEN WorkFlowEventName = 'Programme Start' and f_wfea.EventDate  <> -1 THEN f_wfea.EventDate END)						AS Last_Programme_Start
	   ,MIN(CASE WHEN WorkFlowEventName = 'Programme Start' THEN EventEstimatedStartDate END)											AS Programme_Start_EstimatedStartDate_Skey
	   ,MIN(CASE WHEN WorkFlowEventName = 'Programme Start' THEN EventEstimatedEndDate END)												AS Programme_Start_EstimatedEndDate_Skey
       ,COUNT ( DISTINCT (CASE WHEN WorkFlowEventName = 'Programme Start' and f_wfea.EventDate  <> -1 THEN [CaseHash]   END))			AS Is_Programme_Start

       ,SUM(CASE WHEN WorkFlowEventName = 'Referral Documents' and f_wfea.EventDate  <> -1 THEN 1 END)									AS Sum_Referral_Documents
       ,MIN(CASE WHEN WorkFlowEventName = 'Referral Documents' and f_wfea.EventDate  <> -1 THEN f_wfea.EventDate END)					AS First_Referral_Documents
       ,MAX(CASE WHEN WorkFlowEventName = 'Referral Documents' and f_wfea.EventDate  <> -1 THEN f_wfea.EventDate END)					AS Last_Referral_Documents
	   ,MIN(CASE WHEN WorkFlowEventName = 'Referral Documents' THEN EventEstimatedStartDate END)										AS Referral_Documents_EstimatedStartDate_Skey
	   ,MIN(CASE WHEN WorkFlowEventName = 'Referral Documents' THEN EventEstimatedEndDate END)											AS Referral_Documents_EstimatedEndDate_Skey
       ,COUNT ( DISTINCT (CASE WHEN WorkFlowEventName = 'Referral Documents' and f_wfea.EventDate  <> -1 THEN [CaseHash]   END))		AS Is_Referral_Documents

       ,SUM(CASE WHEN WorkFlowEventName = 'Submission' and f_wfea.EventDate  <> -1 THEN 1 END)											AS Sum_Submission
       ,MIN(CASE WHEN WorkFlowEventName = 'Submission' and f_wfea.EventDate  <> -1 THEN f_wfea.EventDate END)							AS First_Submission
       ,MAX(CASE WHEN WorkFlowEventName = 'Submission' and f_wfea.EventDate  <> -1 THEN f_wfea.EventDate END)							AS Last_Submission
	   ,MIN(CASE WHEN WorkFlowEventName = 'Submission' THEN EventEstimatedStartDate END)												AS Submission_EstimatedStartDate_Skey
	   ,MIN(CASE WHEN WorkFlowEventName = 'Submission' THEN EventEstimatedEndDate END)													AS Submission_EstimatedEndDate_Skey
       ,COUNT ( DISTINCT (CASE WHEN WorkFlowEventName = 'Submission' and f_wfea.EventDate  <> -1 THEN [CaseHash]   END))				AS Is_Submission

       ,SUM(CASE WHEN WorkFlowEventName = 'Unknown' and f_wfea.EventDate  <> -1 THEN 1 END)												AS Sum_Unknown
       ,MIN(CASE WHEN WorkFlowEventName = 'Unknown' and f_wfea.EventDate  <> -1 THEN f_wfea.EventDate END)								AS First_Unknown
       ,MAX(CASE WHEN WorkFlowEventName = 'Unknown' and f_wfea.EventDate  <> -1 THEN f_wfea.EventDate END)								AS Last_Unknown
	   ,MIN(CASE WHEN WorkFlowEventName = 'Unknown' THEN EventEstimatedStartDate END)													AS Unknown_EstimatedStartDate_Skey
	   ,MIN(CASE WHEN WorkFlowEventName = 'Unknown' THEN EventEstimatedEndDate END)														AS Unknown_EstimatedEndDate_Skey
       ,COUNT ( DISTINCT (CASE WHEN WorkFlowEventName = 'Unknown' and f_wfea.EventDate  <> -1 THEN [CaseHash]   END))					AS Is_Unknown

       ,SUM(CASE WHEN WorkFlowEventName = 'Welcome Pack' and f_wfea.EventDate  <> -1 THEN 1 END)										AS Sum_Welcome_Pack
       ,MIN(CASE WHEN WorkFlowEventName = 'Welcome Pack' and f_wfea.EventDate  <> -1 THEN f_wfea.EventDate END)							AS First_Welcome_Pack
       ,MAX(CASE WHEN WorkFlowEventName = 'Welcome Pack' and f_wfea.EventDate  <> -1 THEN f_wfea.EventDate END)							AS Last_Welcome_Pack
	   ,MIN(CASE WHEN WorkFlowEventName = 'Welcome Pack' THEN EventEstimatedStartDate END)												AS Welcome_Pack_EstimatedStartDate_Skey
	   ,MIN(CASE WHEN WorkFlowEventName = 'Welcome Pack' THEN EventEstimatedEndDate END)												AS Welcome_Pack_EstimatedEndDate_Skey
       ,COUNT ( DISTINCT (CASE WHEN WorkFlowEventName = 'Welcome Pack' and f_wfea.EventDate  <> -1 THEN [CaseHash]   END))				AS Is_Welcome_Pack

       ,SUM(CASE WHEN WorkFlowEventName = 'Work First Appraisal' and f_wfea.EventDate  <> -1 THEN 1 END)								AS Sum_Work_First_Appraisal
       ,MIN(CASE WHEN WorkFlowEventName = 'Work First Appraisal' and f_wfea.EventDate  <> -1 THEN f_wfea.EventDate END)					AS First_Work_First_Appraisal
       ,MAX(CASE WHEN WorkFlowEventName = 'Work First Appraisal' and f_wfea.EventDate  <> -1 THEN f_wfea.EventDate END)					AS Last_Work_First_Appraisal
	   ,MIN(CASE WHEN WorkFlowEventName = 'Work First Appraisal' THEN EventEstimatedStartDate END)										AS Work_First_Appraisal_EstimatedStartDate_Skey
	   ,MIN(CASE WHEN WorkFlowEventName = 'Work First Appraisal' THEN EventEstimatedEndDate END)										AS Work_First_Appraisal_EstimatedEndDate_Skey
       ,COUNT ( DISTINCT (CASE WHEN WorkFlowEventName = 'Work First Appraisal' and f_wfea.EventDate  <> -1 THEN [CaseHash]   END))		AS Is_Work_First_Appraisal

       ,SUM(CASE WHEN WorkFlowEventName = 'Workplace Plan Appointment' and f_wfea.EventDate  <> -1 THEN 1 END)							AS Sum_Workplace_Plan_Appointment
       ,MIN(CASE WHEN WorkFlowEventName = 'Workplace Plan Appointment' and f_wfea.EventDate  <> -1 THEN f_wfea.EventDate END)			AS First_Workplace_Plan_Appointment
       ,MAX(CASE WHEN WorkFlowEventName = 'Workplace Plan Appointment' and f_wfea.EventDate  <> -1 THEN f_wfea.EventDate END)			AS Last_Workplace_Plan_Appointment
	   ,MIN(CASE WHEN WorkFlowEventName = 'Workplace Plan Appointment' THEN EventEstimatedStartDate END)								AS Workplace_Plan_Appointment_EstimatedStartDate_Skey
	   ,MIN(CASE WHEN WorkFlowEventName = 'Workplace Plan Appointment' THEN EventEstimatedEndDate END)									AS Workplace_Plan_Appointment_EstimatedEndDate_Skey
       ,COUNT ( DISTINCT (CASE WHEN WorkFlowEventName = 'Workplace Plan Appointment' and f_wfea.EventDate  <> -1 THEN [CaseHash] END))	AS Is_Workplace_Plan_Appointment
  FROM [DV].[Fact_WorkFlowEvents] f_wfea
	INNER JOIN [DV].[Dimension_WorkFlowEventType] d_wfet
			ON f_wfea.[WorkFlowEventTypeHash] = d_wfet.[WorkFlowEventTypeHash]
  GROUP BY
      [CaseHash];
GO

