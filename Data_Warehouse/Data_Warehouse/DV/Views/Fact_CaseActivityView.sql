CREATE VIEW [DV].[Fact_CaseActivityView] AS with 
JobPref as		(	
Select			vgs.ParticipantKey
				,min(case when vgs.VacGoal = 1 then vgs.JobDesc else null end) as VacancyGoal1
				,min(case when vgs.VacGoal = 2 then vgs.JobDesc else null end) as VacancyGoal2
				,min(case when vgs.VacGoal = 3 then vgs.JobDesc else null end) as VacancyGoal3
from			(select		cop.ParticipantKey
							,cop.ParticipantEntityKey
							,cat.JOB_CATEGORY
							,ref.[Description] as JobDesc
							,row_number() over (partition by cat.REFERENCE order by cat.BISUNIQUEID) VacGoal
				from		ADAPT.SAT_Participant_Adapt_Core_PersonGen	cop 
				join		ADAPT.PROP_JOB_CAT							cat on cat.Reference = cast(replace(cop.ParticipantEntityKey,'ADAPT|','') as bigint)
				left join	DV.Dimension_References						ref on ref.Code = cat.JOB_CATEGORY 
																			and ref.ReferenceSource = 'ADAPT.MD_MULTI_NAMES') vgs
group by		vgs.ParticipantKey)
,JobJCP as		(	
select			hp.PARTICIPANTKEY
				,nullif(min(pcp.JCP_FORENAME + ' ' + pcp.JCP_SURNAME),'')	as ReferringWorkCoach
				,nullif(min(pcp.ST_LOCATION),'')							as ReferringJCP
from			DV.HUB_PARTICIPANT						as hp
join			DV.LINK_REFERRAL_PARTICIPANT			as lpr on lpr.PARTICIPANTHASH = hp.PARTICIPANTHASH
join			DV.HUB_REFERRAL							as hr  on hr.REFERRALHASH = lpr.REFERRALHASH 
join			ADAPT.PROP_CAND_PRAP					as pcp on pcp.REFERENCE = cast(replace(hr.ReferralKey,'ADAPT|','') as bigint) AND pcp.ISCURRENT = 1
group by		hp.PARTICIPANTKEY)
,Ping as		(	
select			hmrc.CaseHash
				,min(case when hmrc.FirstPaymentDate=1			then hmrc.NotificationDateKey else null end) as Ping1Date
				,min(case when hmrc.EarningsCrossed1000=1		then hmrc.NotificationDateKey else null end) as Ping2Date 
				,min(case when hmrc.EarningsCrossed2000=1		then hmrc.NotificationDateKey else null end) as Ping3Date
				,min(case when hmrc.EarningsReachedThreshold=1	then hmrc.NotificationDateKey else null end) as Ping4Date
from			DV.Fact_HMRC hmrc
group by		hmrc.CaseHash)
,LeaveDate as	(
select			fal.CaseHash
				,max(fal.JobLeaveaddDateDateKey) as JobLeaveaddDateDateKey
from			DV.Fact_Assignment fal
group by		fal.CaseHash)
,LastJob as		(
select			fa2.CaseHash
				,max(ems.EmploymentSiteName)	as EmployerName
				,max(ass.JobTitle)				as JobTitle
				,max(ass.WeeklyHours)			as WeeklyHours
				,max(ass.ContractedHours)		as ContractedHours
from			DV.Fact_Assignment				fa2
join			(select		fa3.CaseHash
							,max(fa3.AssignmentStartClaimDateKey) as LatestAssignmentStartClaimDateKey
				 from		DV.Fact_Assignment	fa3
				 group by	fa3.CaseHash)		lda on lda.CaseHash = fa2.CaseHash
left join		DV.Dimension_Assignment			ass on ass.AssignmentHash = fa2.AssignmentHash
left join		DV.Dimension_EmploymentSite		ems on ems.EmploymentSiteHash = fa2.EmploymentSiteHash
where			fa2.AssignmentStartClaimDateKey = lda.LatestAssignmentStartClaimDateKey
group by		fa2.CaseHash)


select			cas.CaseHash							as CaseHash
				--,cas.ParticipantHash					as ParticipantHash
				--,cas.EmployeeHash						as EmployeeHash
				--,cas.ReferralHash						as ReferralHash
				--,cas.ProgrammeHash					as ProgrammeHash
				--,cas.DeliverySiteHash					as DeliverySiteHash
				--,cas.RequestorHash					as RequestorHash
				--,cas.CaseStatusHash					as CaseStatusHash
				,act.ActivityHash						as ActivityHash
				--,act.ActivityTypeHash					as ActivityTypeHash
				--,act.ActivityOwningEmployeeHash		as ActivityOwningEmployeeHash
				--,act.ActivityCreatedByEmployeeHash	as ActivityCreatedByEmployeeHash
				--,act.ActivityCompletedByEmployeeHash	as ActivityCompletedByEmployeeHash
				,act.ActivityStartDateKey				as ActivityStartDateKey
				,act.ActivityCompleteDateKey			as ActivityCompleteDateKey
				,act.ActivityDueDateKey					as ActivityDueDateKey
				,act.IsAttended							as IsAttended
				,act.IsDidNotAttend						as IsDidNotAttend
				--,act.ActivityStatusHash				as ActivityStatusHash
				--,act.EmploymentSiteHash				as act_EmploymentSiteHash
				--,cas.ReferralStatusHash				as ReferralStatusHash
				,cas.ReferralDateKey					as ReferralDateKey
				,cas.StartDateKey						as StartDateKey
				,cas.IsLiveReferral						as IsLiveReferral
				,nullif(cas.JobOutcomeOneIsPaidDate,-1) as JobOutcomeOneIsPaidDateKey
				--,cas.StartVerifiedDateKey				as StartVerifiedDateKey
				--,cas.LeaveDateKey						as LeaveDateKey
				--,cas.ProjectedLeaveDateKey			as ProjectedLeaveDateKey
				--,act.ReferralDateKey					as act_ReferralDateKey
				--,act.RequestorStatusHash				as RequestorStatusHash
				--,act.ActivityHoursSpent				as ActivityHoursSpent
				--,act.ActivityHoursScheduled			as ActivityHoursScheduled
				--,act.VerifiedDateKey					as VerifiedDateKey
				--,act.ActivityStartDateKey				as ActivityStartDateKey
				--,act.ActivityCompleteDateKey			as ActivityCompleteDateKey
				--/\--Above are all hash keys for star schema
				--\/--below are all dimension fields to speed up drill through
				,del.DeliverySiteName					as DeliverySiteName
				,par.FullName							as FullName
				,isnull(par.ParticipantID,pac.ParticipantKey)										as ParticipantID
				,par.TelephoneMobile					as MobileNumber
				,convert(datetime,convert(varchar(10), nullif(cas.StartDateKey,-1),120))			as ContractStartDate
				,cst.CaseStatus							as CaseStatus
				,acd.ActivityName						as ActivityName
				,aty.ActivityType						as ActivityType
				,acd.ContactMethod						as ActivityContactMethod
				,ast.ActivityStatus						as ActivityStatus
				,convert(datetime,convert(varchar(10), nullif(act.ActivityStartDateKey,-1),120))	as ActivityStartDate				
				,convert(datetime,convert(varchar(10), nullif(act.ActivityCompleteDateKey,-1),120))	as ActivityCompleteDate
				,emc.EmployeeName						as CaseAdvisorName
				,ema.EmployeeName						as ActivityAdvisorName
				,jcp.ReferringJCP						as ReferringJCP
				,jcp.ReferringWorkCoach					as ReferringWorkCoach
				,bca.CaseID								as CaseID
				,bca.WorkRedinessStatus					as JobReadinessStatus
				,jpe.VacancyGoal1						as VacancyGoal1
				,jpe.VacancyGoal2						as VacancyGoal2
				,jpe.VacancyGoal3						as VacancyGoal3
				,par.HasUpToDateCV						as HasUpToDateCV
				,par.BetterOffCalculationStatus			as BetterOffCalculationStatus
				,par.IsDriver							as IsDriver
				,(case when pin.Ping1Date is null then 0 else 1 end
				 + case when pin.Ping2Date is null then 0 else 1 end
				 + case when pin.Ping3Date is null then 0 else 1 end
				 + case when pin.Ping4Date is null then 0 else 1 end) as PingCount
				,pin.Ping1Date							as Ping1Date
				,pin.Ping2Date							as Ping2Date
				,pin.Ping3Date							as Ping3Date
				,pin.Ping4Date							as Ping4Date
				,convert(datetime,convert(varchar(10), nullif(pin.Ping1Date,-1),120)) as Ping1DateActual
				,convert(datetime,convert(varchar(10), nullif(pin.Ping2Date,-1),120)) as Ping2DateActual
				,convert(datetime,convert(varchar(10), nullif(pin.Ping3Date,-1),120)) as Ping3DateActual
				,convert(datetime,convert(varchar(10), nullif(pin.Ping4Date,-1),120)) as Ping4DateActual
				,case when (isnull(pin.Ping1Date,-1) =  -1 and isnull(pin.Ping2Date,-1) =  -1 and isnull(pin.Ping3Date,-1) =  -1 and isnull(pin.Ping4Date,-1) =  -1) then 1 else 0 end as Ping0DateCalc 
				,case when (isnull(pin.Ping1Date,-1) <> -1 and isnull(pin.Ping2Date,-1) =  -1 and isnull(pin.Ping3Date,-1) =  -1 and isnull(pin.Ping4Date,-1) =  -1) then 1 else 0 end as Ping1DateCalc 
				,case when (isnull(pin.Ping2Date,-1) <> -1 and isnull(pin.Ping3Date,-1) =  -1 and isnull(pin.Ping4Date,-1) =  -1) then 1 else 0 end as Ping2DateCalc 
				,case when (isnull(pin.Ping3Date,-1) <> -1 and isnull(pin.Ping4Date,-1) =  -1) then 1 else 0 end as Ping3DateCalc
				,case when (isnull(pin.Ping4Date,-1) <> -1) then 1 else 0 end as Ping4DateCalc
				,erg.Cumulative_Earnings_To_Date		as CumulativeEarningsToDate
				,erg.RemainingEarnings					as RemainingEarnings
				,erg.projected_date						as ProjectedDate
				,pro.ProgrammeName						as ProgrammeName
				,1										as Redesign_TotalRowCount
				,convert(datetime,convert(varchar(10), nullif(cas.ReferralDateKey,-1),120))									as ReferralDate
				,convert(datetime,convert(varchar(10), nullif(cas.JobOutcomeOneIsPaidDate,-1),120))							as JobOutcomeOneIsPaidDate
				,format(convert(datetime,convert(varchar(10), nullif(act.ActivityCompleteDateKey,-1),120)),'MMM-yy')		as ActivityCompleteDate_MonthYear
				,lda.JobLeaveaddDateDateKey				as JobLeaveaddDateDateKey
				,convert(datetime,convert(varchar(10), nullif(lda.JobLeaveaddDateDateKey,-1),120))		as JobLeaveaddDateDate
				,case	when act.ActivityDueDateKey is null then 0
						when (act.ActivityDueDateKey <= cast(format(getdate(),'yyyyMMdd') as int) 
							  and act.ActivityCompleteDateKey = -1
							  and cst.CaseStatus = 'Overdue'
							  and isnull(cas.LeaveDateKey,-1) = -1) then 1
						else 0 
				 end									as IsOverdue
				,case	when (act.ActivityDueDateKey >= cast(format(getdate(),'yyyyMMdd') as int) and act.ActivityCompleteDateKey = -1) then 1
						else 0 
				 end									as IsInFuture
				,case	when (act.ActivityDueDateKey = cast(format(getdate(),'yyyyMMdd') as int)) then 1
						else 0 
				 end									as Isduetodayflag
				,laj.EmployerName						as LastJobEmployerName
				,laj.JobTitle							as LastJobJobTitle
				,laj.WeeklyHours						as LastJobWeeklyHours
				,laj.ContractedHours					as LastJobContractedHours
--------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------
--  Created By:=	Paul Hannelly	--------------------------------------------------
--  Create Date:=	09/12/2022		--------------------------------------------------
--------------------------------------------------------------------------------------
--  Notes  ---------------------------------------------------------------------------
-- This view was created beause the cube drill throughs were very slow, because of
-- the terrible way in which all the relationships in the cube model have been 
-- defined and because the cube version of this view has 20+ calculted columns.
--------------------------------------------------------------------------------------
--  Work Around \ Technical Debt   ---------------------------------------------------
-- Because of tight deadlines we have had to manually add the 3 Preffered Job fields
-- and 2 JCP fields directly into this view. These fields need to be added into the 
-- strategic solution and this work has been added to the technical debt backlog.
--------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------
from			DV.Fact_Case							cas
left join		DV.Fact_Activity						act on act.CaseHash				= cas.CaseHash
left join		DV.Dimension_DeliverySite				del on del.DeliverySiteHash		= cas.DeliverySiteHash
left join		DV.Dimension_Participant				par on par.ParticipantHash		= cas.ParticipantHash
left join		JobPref									jpe on jpe.ParticipantKey		= par.ParticipantID
left join		JobJCP									jcp on jcp.ParticipantKey		= par.ParticipantID
left join		DV.Dimension_CaseStatus					cst on cst.CaseStatusHash		= cas.CaseStatusHash
left join		DV.Dimension_Activity					acd on acd.ActivityHash			= act.ActivityHash
left join		DV.Dimension_ActivityType				aty on aty.ActivityTypeHash		= act.ActivityTypeHash
left join		DV.Dimension_ActivityStatus				ast on ast.ActivityStatusHash	= act.ActivityStatusHash
left join		DV.Dimension_Employee					emc on emc.EmployeeHash			= cas.EmployeeHash
left join		DV.Dimension_Employee					ema on ema.EmployeeHash			= act.EmployeeHash
left join		Ping									pin on pin.CaseHash				= cas.CaseHash
left join		LeaveDate								lda on lda.CaseHash				= cas.CaseHash
left join		DV.Dimension_Programme					pro on pro.ProgrammeHash		= cas.ProgrammeHash
left join		DV.Fact_EarningsAnalysis				erg on erg.CaseHash				= cas.CaseHash
left join		DV.Base_Case_Adapt						bca on bca.CaseHash				= cas.CaseHash
left join		LastJob									laj on laj.CaseHash				= cas.CaseHash
left join		DV.SAT_Participant_Adapt_Core_PersonGen pac on convert(char(66),isnull(pac.ParticipantHash,cast(0x0 as binary(32))),1) = cas.ParticipantHash and pac.IsCurrent = 1;
GO

