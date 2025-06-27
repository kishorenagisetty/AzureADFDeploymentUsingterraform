CREATE VIEW [DV].[Fact_Case]
AS 

SELECT distinct 
	FCB.CaseHash
    , fcb.RecordSource
    , fcb.ParticipantHash
    , fcb.EmployeeHash
    , fcb.ReferralHash
    , fcb.ProgrammeHash
    , fcb.DeliverySiteHash
    , fcb.RequestorHash
    , fcb.CaseStatusHash
    , fcb.ReferralStatusHash
    , fcb.ReferralDateKey
    , StartDateKey
    , StartVerifiedDateKey
    , LeaveDateKey
    , ProjectedLeaveDateKey
    , ReportDateKey
    , ReferalSLADate
    , IsStart
    , IsDNS
    , IsLiveReferral
    , JobOutcomeOneIsPaidFlag
	, JobOutcomeOneIsPaidFlag_DWP
    , JobOutcomeOneIsPaidDate
	, Sum_Initial_Contact
	, First_Initial_Contact
	, Last_Initial_Contact
	, Initial_Contact_EstimatedStartDate_Skey
	, Initial_Contact_EstimatedEndDate_Skey
	, Is_Initial_Contact
	, Sum_PRaP_Referral
	, First_PRaP_Referral
	, Last_PRaP_Referral
	, PRaP_Referral_EstimatedStartDate_Skey
	, PRaP_Referral_EstimatedEndDate_Skey
	, Is_PRaP_Referral
	, Sum_Job_Start_Added
	, First_Job_Start_Added
	, Last_Job_Start_Added
	, Job_Start_Added_EstimatedStartDate_Skey
	, Job_Start_Added_EstimatedEndDate_Skey
	, Is_Job_Start_Added  
	, Sum_Job_Start_Verified
	, First_Job_Start_Verified
	, Last_Job_Start_Verified
	, Job_Start_Verified_EstimatedStartDate_Skey
	, Job_Start_Verified_EstimatedEndDate_Skey
	, Is_Job_Start_Verified
	, Sum_Job_Start_Date
	, First_Job_Start_Date
	, Last_Job_Start_Date
	, Job_Start_Date_EstimatedStartDate_Skey
	, Job_Start_Date_EstimatedEndDate_Skey
	, Is_Job_Start_Date
	, Sum_Action_Plan
	, First_Action_Plan
	, Last_Action_Plan
	, Action_Plan_EstimatedStartDate_Skey
	, Action_Plan_EstimatedEndDate_Skey
	, Is_Action_Plan
	, Sum_Earnings
	, First_Earnings
	, Last_Earnings
	, Earnings_EstimatedStartDate_Skey
	, Earnings_EstimatedEndDate_Skey
	, Is_Earnings
	, Sum_First_Contact
	, First_First_Contact
	, Last_First_Contact
	, First_Contact_EstimatedStartDate_Skey
	, First_Contact_EstimatedEndDate_Skey
	, Is_First_Contact
	, Sum_In_Work_Action_Plan
	, First_In_Work_Action_Plan
	, Last_In_Work_Action_Plan
	, In_Work_Action_Plan_EstimatedStartDate_Skey
	, In_Work_Action_Plan_EstimatedEndDate_Skey
	, Is_In_Work_Action_Plan
	, Sum_Initial_Appointment
	, First_Initial_Appointment
	, Last_Initial_Appointment
	, Initial_Appointment_EstimatedStartDate_Skey
	, Initial_Appointment_EstimatedEndDate_Skey
	, Is_Initial_Appointment
	, Sum_Interview
	, First_Interview
	, Last_Interview
	, Interview_EstimatedStartDate_Skey
	, Interview_EstimatedEndDate_Skey
	, Is_Interview
	, Sum_Job_Start
	, First_Job_Start
	, Last_Job_Start
	, Job_Start_EstimatedStartDate_Skey
	, Job_Start_EstimatedEndDate_Skey
	, Is_Job_Start
	, Sum_Missed_Appointments
	, First_Missed_Appointments
	, Last_Missed_Appointments
	, Missed_Appointments_EstimatedStartDate_Skey
	, Missed_Appointments_EstimatedEndDate_Skey
	, Is_Missed_Appointments
	, Sum_Offer_Accepted
	, First_Offer_Accepted
	, Last_Offer_Accepted
	, Offer_Accepted_EstimatedStartDate_Skey
	, Offer_Accepted_EstimatedEndDate_Skey
	, Is_Offer_Accepted
	, Sum_Programme_Exit
	, First_Programme_Exit
	, Last_Programme_Exit
	, Programme_Exit_EstimatedStartDate_Skey
	, Programme_Exit_EstimatedEndDate_Skey
	, Is_Programme_Exit
	, Sum_Programme_Start
	, First_Programme_Start
	, Last_Programme_Start
	, Programme_Start_EstimatedStartDate_Skey
	, Programme_Start_EstimatedEndDate_Skey
	, Is_Programme_Start
	, Sum_Referral_Documents
	, First_Referral_Documents
	, Last_Referral_Documents
	, Referral_Documents_EstimatedStartDate_Skey
	, Referral_Documents_EstimatedEndDate_Skey
	, Is_Referral_Documents
	, Sum_Submission
	, First_Submission
	, Last_Submission
	, Submission_EstimatedStartDate_Skey
	, Submission_EstimatedEndDate_Skey
	, Is_Submission
	, Sum_Unknown
	, First_Unknown
	, Last_Unknown
	, Unknown_EstimatedStartDate_Skey
	, Unknown_EstimatedEndDate_Skey
	, Is_Unknown
	, Sum_Welcome_Pack
	, First_Welcome_Pack
	, Last_Welcome_Pack
	, Welcome_Pack_EstimatedStartDate_Skey
	, Welcome_Pack_EstimatedEndDate_Skey
	, Is_Welcome_Pack
	, Sum_Work_First_Appraisal
	, First_Work_First_Appraisal
	, Last_Work_First_Appraisal
	, Work_First_Appraisal_EstimatedStartDate_Skey
	, Work_First_Appraisal_EstimatedEndDate_Skey
	, Is_Work_First_Appraisal
	, Sum_Workplace_Plan_Appointment
	, First_Workplace_Plan_Appointment
	, Last_Workplace_Plan_Appointment
	, Workplace_Plan_Appointment_EstimatedStartDate_Skey
	, Workplace_Plan_Appointment_EstimatedEndDate_Skey
	, Is_Workplace_Plan_Appointment
FROM [DV].[Fact_Case_Base] FCB

LEFT OUTER JOIN [DV].[Fact_Case_WFE_Base] FCWFEB ON FCB.CaseHash = FCWFEB.CaseHash

where FCB.CaseHash not in ( '0x846A0682B5637A9BFC6062405ED22F0056A24C830AD3BA1567FD763E833B1A2C'
							,'0x2D3CDBC7E2BDBEAF9BE689DC380E25E2B623A3C9213E32966C5306FAA47D9613'
							,'0x2E785940CCD4E13CFB44984AEC29795D5C768F3523949505725F8EDD275F151F'
							,'0x3CB0B8494ACFAC9B40D8438848A9EB8004C315246B574559F8A613F8912AEF94'
							,'0x6359E6E676FBCCB17375BB8520ACAC532511FE74A9A9B2CF89EB0593E05C958D'
							,'0x6CE886D02E0A4FAA4B0407C04755AC5D2E0F32218A1335ED3B23CAE5EA2D17F6'
							,'0x7CA7A8B648597B11468F65D1B18BD9C7DD4148FE01CBEB79DE33A893CC662A33'
							,'0x89E4902C5D1FADD8A1D12FC50A7491448CDCC140E76D07B24AD6918041456E57'
							,'0xC2ECA04AB1B3882B17B21C09C18FCF9E740AABE5EFCDC23850FED1C69A177C02'
							,'0xC69812222F5D540879C55B337E2B37495E59DEEF3FD3412E689E7C2E9B2A4DF8'
							,'0xF05D1C3116E5370C2BDF16FAD9D11012782615504A85947B78FC730AFF93B456')

GO
