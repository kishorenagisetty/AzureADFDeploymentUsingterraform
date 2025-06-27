CREATE VIEW [dwh].[fact_Case] 
AS 
-- Author: 
-- Create date: DD/MM/YYY
-- Ticket Reference:  <Dev Ops Ticket Reference>
-- Description: <Description regarding object>
-- Revisions:
-- 10/07/2023 - <MK> - <24899> - <Added Job Add Date & Employment Org Name for first & last job>
-- 03/08/2023 - <MK> - <26306> - <Changed Case Outcome Status Logic as per agreed with Paul Walters>
-- 14/08/2023 - <MK> - <26306> - <Added extra criteria for InWork Calculation>
-- 09/10/2023 - <SK> - <27218> - <Adding 2 columns related to Strands>
-- 12/12/2023 - <MK> - <28466> - <Added 1 Column related to DisEngagement>
-- 14/02/2023 - <MK> - <31676> - <Switch Bridgend & Vale Core Provider from Old to New>
-- 05/03/2024 - <MK> - <31676> - <Amended Criteria for DeliverySite>

with			FactCase as
(
select			cas.RecordSource															 as RecordSource
				,cas.CaseHash																 as CaseHashBin
				,convert(char(66),cas.CaseHash,1)											 as CaseHash
				,convert(char(66),isnull(par.ParticipantHash ,cast(0x0 as binary(32))),1)	 as ParticipantHash
				,convert(char(66),isnull(emp.EmployeeHash	 ,cast(0x0 as binary(32))),1)	 as EmployeeHash
				,isnull(ref.ReferralHash ,cast(0x0 as binary(32)))							 as ReferralHashBin
				,convert(char(66),isnull(ref.ReferralHash ,cast(0x0 as binary(32))),1)	 	 as ReferralHash
				,convert(char(66),isnull(pro.ProgrammeHash	 ,cast(0x0 as binary(32))),1)	 as ProgrammeHash
				,case when convert(char(66),isnull(dsi.DeliverySiteHash,cast(0x0 as binary(32))),1) <> '0xE699BE9C01D797DD9E0032209F6B42FAE6D963479BC726C21E667F0950D33B8C' and -- 05/03/24 <MK> <31676>
					trim(rac.ReferringJCP) in ('Bridgend-Jobcentre Plus Office','Bridgend Market Street-Jobcentre Plus Office','Penarth-Jobcentre Plus Office','Barry-Jobcentre Plus Office','Maesteg-Jobcentre Plus Office','Llantrisant-Jobcentre Plus Office','Porthcawl-Jobcentre Plus Office')
							and convert(char(66),isnull(pro.ProgrammeHash ,cast(0x0 as binary(32))),1) = '0xD68A73F0D6BC4E17F10BD9B8640A21A1D8B6D309A51EC1B91A4CE1F9F02BB9E9' --Just For WHP Wales
					then convert(char(66),hashbytes('SHA2_256','BridgeVale'),1)
					else convert(char(66),isnull(dsi.DeliverySiteHash,cast(0x0 as binary(32))),1)
				 end																		 as DeliverySiteHash
				,cast(rac.ReferralDate as date)												 as ReferralDate
				,coalesce(nullif(mu1.Name,''),nullif(mu1.Description,''))					 as ReferralType
				,cast(sad.StartDate as date)												 as StartDate
				,datefromparts(year(sad.StartDate),month(sad.StartDate),1)					 as StartMonth
			    ,case when month(sad.StartDate) >= 10 then concat(year(sad.StartDate), '/', year(sad.StartDate)+1)
					  else concat(year(sad.StartDate)-1, '/', year(sad.StartDate))
				 end  + ' ' +
				 case when month(sad.StartDate) >= 10 then cast(month(sad.StartDate) - 9 as varchar)
					  else cast(month(sad.StartDate) + 3 as varchar)
				 end  + ' ' +
				 format(sad.StartDate, 'MMM', 'en-US')										 as CohortMonth
				,cast(sad.StartVerifiedDate as date)										 as StartVerifiedDate
				,cast(sad.LeaveDate as date)												 as LeaveDate
				,cast(sad.ProjectedLeaveDate as date)										 as ProjectedLeaveDate
				,cast(sad.ReportDate as date)												 as ReportDate
				,cast(sad.ReferralSLADate as date)											 as ReferralSLADate
				,cast(gfi.FirstJobStartDate as date)										 as FirstJobStartDate
				,cast(aac.JobOutcomeOneClaimedDate as date)									 as JobOutcomeOneClaimedDate
				,cast(aac.JobOutcomeOneClaimedDate_IsDWP as date)							 as JobOutcomeOneClaimedDate_IsDWP
				,cast(aac.JobOutcomeOneClaimedDate_NotDWP as date)							 as JobOutcomeOneClaimedDate_NotDWP
				,cast(isnull(aac.JobOutcomeOneClaimedDate, 
						case when aac.JobLeaveAddDate between dateadd(dd,456,sad.StartDate) and dateadd(dd,639,sad.StartDate) then aac.JobLeaveAddDate
							 else sad.ProjectedLeaveDate			 
						end) as date)														 as EarliestOfProjectedLeaveOrJobOutcomeDate
				,case
					  when aac.JobOutcomeOneClaimedDate is not null then 'Customer Reached Outcome - No Exit Plan Required'
					  when aac.JobLeaveAddDate between dateadd(dd,456,sad.StartDate) and dateadd(dd,639,sad.StartDate) then 'Participant ceased employment in the extension period'
					  when dateadd(dd,456,sad.StartDate) <= getdate() and mu2.Description != 'In Work'
					       and isnull(aac.JobLeaveAddDate, sad.ProjectedLeaveDate) between sad.StartDate and dateadd(dd,456,sad.StartDate) then 'Exit with No Extension Applied'
				 end																		 as Category
				,cast(aac.JobLeaveAddDate as date)											 as JobLeaveAddDate
				,format(cast(aac.JobLeaveAddDate as date),'MMM-yyyy')						 as JobLeaveAddDateMonthYear
				,datediff(month	,cast(sad.StartDate as date)
								,cast(gfi.FirstJobStartDate as date)) +1					 as SDMonthFirstJob
				,datediff(month	,cast(sad.StartDate as date)
								,cast(aac.JobOutcomeOneClaimedDate as date)) +1				 as SDMonthJobOutcome
				,datediff(month	,cast(sad.StartDate as date)
								,cast(pin.Ping1Date as date)) +1							 as SDMonthFirstEarning
				,convert(date,convert(varchar(10), nullif(pea.ProjectedOutcomeDate,-1),120)) as ProjectedOutcomeDate
				,cast(cac.CaseKey AS varchar(25)) 											 as CaseID
				,replace(cast(cac.CaseKey AS varchar(25)),'ADAPT|','') 						 as CaseIDNumber
				--,case
				--	when aac.JobOutcomeOneClaimedDate is not null then 'Paid'
				--	when (nullif(pea.ProjectedOutcomeDate,-1) = cast(format(getdate(), 'yyyyMMdd') as int) and aac.JobOutcomeOneClaimedDate is null and sad.LeaveDate is null) then 'Due Today' 
				--	when (nullif(pea.ProjectedOutcomeDate,-1) > cast(format(getdate(), 'yyyyMMdd') as int) and aac.JobOutcomeOneClaimedDate is null and sad.LeaveDate is null) then 'In Pipeline'
				--	when (nullif(pea.ProjectedOutcomeDate,-1) < cast(format(getdate(), 'yyyyMMdd') as int) and aac.JobOutcomeOneClaimedDate is null and sad.LeaveDate is null) then 'Overdue'
				--	when (nullif(pea.ProjectedOutcomeDate,-1) < cast(format(getdate(), 'yyyyMMdd') as int) and aac.JobOutcomeOneClaimedDate is null and cast(format(sad.LeaveDate,'yyyyMMdd') as int)  < nullif(pea.ProjectedOutcomeDate,-1)) then 'Unachievable'
				--	when (nullif(pea.ProjectedOutcomeDate,-1) < cast(format(getdate(), 'yyyyMMdd') as int) and aac.JobOutcomeOneClaimedDate is null and cast(format(sad.LeaveDate,'yyyyMMdd') as int)  > nullif(pea.ProjectedOutcomeDate,-1)) then 'Overdue'
				--	when (nullif(pea.ProjectedOutcomeDate,-1) < cast(format(getdate(), 'yyyyMMdd') as int) and aac.JobOutcomeOneClaimedDate is null and cast(format(sad.LeaveDate,'yyyyMMdd') as int)  = nullif(pea.ProjectedOutcomeDate,-1)) then 'In Pipeline'
				--	when (nullif(pea.ProjectedOutcomeDate,-1) < cast(format(getdate(), 'yyyyMMdd') as int) and aac.JobOutcomeOneClaimedDate is null and sad.LeaveDate is not null) then 'Overdue Off Programme'
				--	when (nullif(pea.ProjectedOutcomeDate,-1) < cast(format(getdate(), 'yyyyMMdd') as int) and aac.JobOutcomeOneClaimedDate is not null and sad.LeaveDate is not null) then 'Overdue Paid Off Programme'
				--	when case 
				--			when cast(sad.LeaveDate as date) is not null								then 'Off-Programme'
				--			when cast(aac.JobOutcomeOneClaimedDate as date) is not null					then 'Off-Programme'
				--			else nullif(mu2.Description,'')
				--		 end = 'In Work' then 'In Pipeline'
				--	when pea.ProjectedOutcomeDate is null then null
				--	when gfi.FirstJobStartDate is null then null
				--	else null
				-- end																										as CaseOutcomeStatus
				,case
					when aac.JobOutcomeOneClaimedDate is not null then 'Paid'
					When (nullif(pea.ProjectedOutcomeDate,-1) < cast(format(getdate(), 'yyyyMMdd') as int) and aac.JobOutcomeOneClaimedDate is null and sad.LeaveDate is null  and Cumulative_Earnings_To_Date >= 4335) then 'Overdue'
					when (nullif(pea.ProjectedOutcomeDate,-1) < cast(format(getdate(), 'yyyyMMdd') as int) and aac.JobOutcomeOneClaimedDate is null and cast(format(sad.LeaveDate,'yyyyMMdd') as int)  > nullif(pea.ProjectedOutcomeDate,-1) and Cumulative_Earnings_To_Date >= 4335) then 'Overdue Off Programme'
					when (nullif(pea.ProjectedOutcomeDate,-1) = cast(format(getdate(), 'yyyyMMdd') as int) and aac.JobOutcomeOneClaimedDate is null and sad.LeaveDate is null and Cumulative_Earnings_To_Date >= 4335) then 'Due Today' 
					when (nullif(pea.ProjectedOutcomeDate,-1) < cast(format(getdate(), 'yyyyMMdd') as int) and aac.JobOutcomeOneClaimedDate is null and sad.LeaveDate is not null and Cumulative_Earnings_To_Date >= 4334.72) then 'Overdue Off Programme'
					when (aac.JobOutcomeOneClaimedDate is null and sad.LeaveDate is null and Inwork.Casehash is not null and Cumulative_Earnings_To_Date < 4335) then 'In Pipeline'
					when (nullif(pea.ProjectedOutcomeDate,-1) > cast(format(getdate(), 'yyyyMMdd') as int) and aac.JobOutcomeOneClaimedDate is null and sad.LeaveDate is null and Inwork.Casehash is not null) then 'In Pipeline'
					when (nullif(pea.ProjectedOutcomeDate,-1) < cast(format(getdate(), 'yyyyMMdd') as int) and aac.JobOutcomeOneClaimedDate is null and cast(format(sad.LeaveDate,'yyyyMMdd') as int)  = nullif(pea.ProjectedOutcomeDate,-1)) then 'In Pipeline'
					when (nullif(pea.ProjectedOutcomeDate,-1) < cast(format(getdate(), 'yyyyMMdd') as int) and aac.JobOutcomeOneClaimedDate is null and cast(format(sad.LeaveDate,'yyyyMMdd') as int)  < nullif(pea.ProjectedOutcomeDate,-1)) then 'Unachievable'				
					when (nullif(pea.ProjectedOutcomeDate,-1) < cast(format(getdate(), 'yyyyMMdd') as int) and aac.JobOutcomeOneClaimedDate is not null and sad.LeaveDate is not null) then 'Overdue Paid Off Programme'
					when case 
							when cast(sad.LeaveDate as date) is not null																			then 'Off-Programme'
							when cast(aac.JobOutcomeOneClaimedDate as date) is not null																then 'Off-Programme'
							else nullif(mu2.Description,'')
						 end = 'In Work'																											then 'In Pipeline'
					When (aac.JobOutcomeOneClaimedDate is null and pea.ProjectedOutcomeDate is null and cast(sad.LeaveDate as date) is not null)	then 'Unachievable'
					when pea.ProjectedOutcomeDate is null then null
					when gfi.FirstJobStartDate is null then null
					else null
				 end																										as CaseOutcomeStatus  -- 03/08/23 <MK> <26306>
				,convert(char(66),isnull(hashbytes('SHA2_256',cast(cac.CaseStatus as varchar)),cast(0x0 as binary(32))),1)	as CaseStatusHash
				,case 
					when cast(sad.LeaveDate as date) is not null								then 'Off-Programme'
					when cast(aac.JobOutcomeOneClaimedDate as date) is not null					then 'Off-Programme'
					else nullif(mu2.Description,'')
				 end																										as CaseStatus
				,nullif(mu3.Description,'')																					as WorkRedinessStatus
				,nullif(mu4.Description,'')																					as LeaveReason				
				,convert(char(66),
					case when isnull(rro.RequestingOrganisationHash,rrs.RequestingSiteHash) is null then cast(0x0 as binary(32))
					else cast(hashbytes('SHA2_256', concat(isnull(rro.RequestingOrganisationHash,cast(0x0 as binary(32))),isnull(rrs.RequestingSiteHash,cast(0x0 as binary(32))))) as binary(32))
					end ,1)																									as RequestorHash
				,row_number() over (partition by cas.CaseHash order by cas.CaseHash, rac.ReferralDate desc)					as RowNumber
				,dis.IsDisengaged																							as IsDisengaged
				,Case When dis.IsDisengaged = 1 then 'Yes' Else 'No' End													as IsDisengaged_YN  -- 12/12/23 <MK> <28466>
				,dis.IsDisengagedDate																						as IsDisengagedDate
				,dis.WasDisengaged																							as WasDisengaged
				,iap.IANotCompleted																							as InitialAppointmentNotCompleted
				,iap.IABooked																								as InitialAppointmentBooked
				,iap.IABookedDate																							as InitialAppointmentBookedDate
				,iap.IACompletedDate																						as InitialAppointmentCompletedDate
				,case 
					when cast(sad.LeaveDate as date) is not null								then 'Off-Programme'
					when cast(aac.JobOutcomeOneClaimedDate as date) is not null					then 'Off-Programme'
					when nullif(mu2.Description,'') = 'Off-Programme'							then 'Off-Programme'
					when cast(sad.LeaveDate as date) is null and dis.IsDisengaged = 1			then 'Disengaged'
					when cast(sad.LeaveDate as date) is null and isnull(dis.IsDisengaged,0) = 0	then 'Engaged'
					else null
				 end																										as EngagementStatus
				--,case
				--	when cast(aac.JobOutcomeOneClaimedDate as date)	is null						then null
				--	when convert(date,convert(varchar(10), nullif(pea.ProjectedOutcomeDate,-1),120)) > cast(sad.ProjectedLeaveDate as date) then 1
				--	else null
				-- end																										as OffTrack
				,case
					when datediff(day,cast(sad.StartDate as date),isnull(convert(date,convert(varchar(10), nullif(pea.ProjectedOutcomeDate,-1),120)),dateadd(day,1000,cast(sad.StartDate as date)))) >= 639 then 1
					else null
				 end																										as OffTrack
				,case
					when cast(sad.LeaveDate as date)				is not null										then 0
					when cast(gfi.FirstJobStartDate as date)		is null											then 0
					when cast(sad.StartDate as date)				is null											then 0
					when cast(aac.AssignmentLeaveDate as date)		is null											then 0
					when nullif(mu2.Description,'')					= 'In Work'										then 0
					when cast(aac.AssignmentLeaveDate as date)		>= cast(gfi.FirstJobStartDate as date)
						 and datediff(month	,cast(sad.StartDate as date),cast(gfi.FirstJobStartDate as date)) < 16	then 1
					else 0
				 end																										as IsRapidResponce
				,case	
					when cast(sad.StartDate as date) is not null													then 0
					when isnull(cor.CorNoWelcome,0) = 0 and isnull(doc.NoWelcome,0) > 0 and sad.LeaveDate is null	then 1
					else 0
				 end																										as NoCorrespondenceWelcomePack
				,cor.CorNoActionPlan																						as NoActionPlan
				,cfl.FirstCorrespondenceDate																				as FirstCorrespondenceDate
				,cfl.LastCorrespondenceDate																					as LastCorrespondenceDate
				,case 
					when cfl.LastCorrespondenceDate is null then null 
					when datediff(day,cast(cfl.LastCorrespondenceDate as date),cast(getdate() as date)) < 0 then null
					else datediff(day,cast(cfl.LastCorrespondenceDate as date),cast(getdate() as date))
				 end																										as LastCorrespondanceToToday
				,case 
					when cfl.LastCorrespondenceDate is null then null 
					when datediff(day,cast(cfl.LastCorrespondenceDate as date),cast(getdate() as date)) < 0 then null
					else cfl.WorkingDaysSinceLastCorrespondenceDate
				 end																										as LastCorrespondanceToTodayWorkingDays
				,case 
					when cfl.LastSuccessfulCorrDate is null then null 
					when datediff(day,cast(cfl.LastSuccessfulCorrDate as date),cast(getdate() as date)) < 0 then null
					else cfl.WorkingDaysSinceLastLastSuccessfulCorrDate
				 end																										as LastSuccessfulCorrToTodayWorkingDays
				,case 
					when wfa.LastWFADate is null then null 
					when wfa.LastWFADate <= aac.JobLeaveAddDate and aac.JobLeaveAddDate <= getdate()
						then aac.WorkingDaysSinceLastJobLeaveAddDate
					else wfa.WorkingDaysSinceLastWFADate
				 end																										as LastWFADateToTodayWorkingDays
				,cfl.LastCorrespondenceStatus																				as LastCorrespondenceStatus
				,cfl.NoOfUnsuccessfulContactsInLastMonth																	as NoOfUnsuccessfulContactsInLastMonth
				--,case	
				--	when nullif(pea.ProjectedOutcomeDate,-1) is null												then null
				--	when cast(aac.JobOutcomeOneClaimedDate as date)	<= cast(sad.ProjectedLeaveDate as date)			then 'On-Track'
				--	when convert(date,convert(varchar(10), nullif(pea.ProjectedOutcomeDate,-1),120)) <= cast(sad.ProjectedLeaveDate as date) then 'On-Track'
				--	when cast(aac.JobOutcomeOneClaimedDate as date) is null											then null
				--	when convert(date,convert(varchar(10), nullif(pea.ProjectedOutcomeDate,-1),120)) > cast(sad.ProjectedLeaveDate as date) then 'Off-Track'
				--	when cast(aac.JobOutcomeOneClaimedDate as date)	> cast(sad.ProjectedLeaveDate as date)			then 'Off-Track'
				--	else null
				-- end																										as OnTrackStatus
				 ,case
					when datediff(day,cast(sad.StartDate as date),isnull(convert(date,convert(varchar(10), nullif(pea.ProjectedOutcomeDate,-1),120)),dateadd(day,1000,cast(sad.StartDate as date)))) >= 639 then 'Off-Track'
					else null
				 end																										as OnTrackStatus
				,case	
					when cast(rac.ReferralDate as date)	is not null 
						 and cast(sad.StartDate as date) is null													then 'Referral'
					when cast(rac.ReferralDate as date)	is not null 
						 and cast(sad.StartDate as date) is not null 
						 and cast(gfi.FirstJobStartDate as date) is null											then 'On Programme'
					when cast(rac.ReferralDate as date)	is not null 
						 and cast(sad.StartDate as date) is not null 
						 and cast(gfi.FirstJobStartDate as date) is not null
						 and cast(aac.JobOutcomeOneClaimedDate as date) is null										then 'Job Started'
					when cast(rac.ReferralDate as date)	is not null 
						 and cast(sad.StartDate as date) is not null 
						 and cast(gfi.FirstJobStartDate as date) is not null 
						 and cast(aac.JobOutcomeOneClaimedDate as date) is not null									then 'Outcome Achieved'
					else null
				 end																										as CurrentStage
				,erg.Cumulative_Earnings_To_Date																			as CumulativeEarningsToDate
				,erg.RemainingEarnings																						as RemainingEarnings
				,eac.EmployeeName																							as CaseAdvisorName
				,laj.LastJobAssignmentTitle																					as LastJobAssignmentTitle
				,laj.LastJobAssignmentStartDate																				as LastJobAssignmentStartDate
				,laj.LastJobAddDate																							as LastJobAssignmentAdddate -- 10/07/23 <MK> <24899>
				,laj.LastJobWeeklyHours																						as LastJobWeeklyHours
				,laj.LastJobContractedHours																					as LastJobContractedHours
				,laj.LastJobEmploymentSiteName																				as LastJobEmploymentSiteName
				,laj.LastJobEmploymentOrgName																				as LastJobEmploymentOrgName -- 10/07/23 <MK> <24899>
				,laj.LastJobClaimDate																						as LastJobClaimDate
				,laj.LastJobLeaveDate																						as LastJobLeaveDate
				,laj.LastJobOwningAdvisor																					as LastJobOwningAdvisor
				,gfi.FirstJobAssignmentTitle																				as FirstJobAssignmentTitle
				,gfi.FirstJobAdddate																						as FirstJobAssignmentAdddate -- 10/07/23 <MK> <24899>
				,gfi.FirstJobWeeklyHours																					as FirstJobWeeklyHours
				,gfi.FirstJobContractedHours																				as FirstJobContractedHours
				,gfi.FirstJobEmploymentSiteName																				as FirstJobEmploymentSiteName
				,gfi.FirstJobEmploymentOrgName																				as FirstJobEmploymentOrgName -- 10/07/23 <MK> <24899>
				,gfi.FirstJobClaimDate																						as FirstJobClaimDate
				,gfi.FirstJobLeaveDate																						as FirstJobLeaveDate
				,datediff(day	,cast(rac.ReferralDate as date)
								,cast(getdate() as date)) 																	as DaysSinceReferral
				,datediff(day	,cast(sad.LeaveDate as date)
								,cast(getdate() as date)) 																	as DaysLeftOnProgramme
				,ext.ExitReportUploadedDate																					as ExitReportUploadedDate
				,ots.LatestDistanceTravelledDate																			as LatestDistanceTravelledDate
				,ots.LatestDistanceTravelled																				as LatestDistanceTravelled
				,case 
					when sad.WorkingDaysSinceOrLeftToProjectedLeaveDate > aac.WorkingDaysSinceJobOutcomeOneClaimedDate 
					then sad.WorkingDaysSinceOrLeftToProjectedLeaveDate		
					else aac.WorkingDaysSinceJobOutcomeOneClaimedDate
				 end 																										as WorkingDaysFromProjectedLeaveOrJobOutcomeDate	 
				,case when isnull(aac.JobOutcomeOneClaimedDate, 
								  case when aac.JobLeaveAddDate between dateadd(dd,456,sad.StartDate) and dateadd(dd,639,sad.StartDate) then aac.JobLeaveAddDate
									   else sad.ProjectedLeaveDate			 
								  end) between getdate() and dateadd(month, 1, getdate()) then 'Exit Due In a Month'	 														
					  when isnull(aac.JobOutcomeOneClaimedDate, 
								  case when aac.JobLeaveAddDate between dateadd(dd,456,sad.StartDate) and dateadd(dd,639,sad.StartDate) then aac.JobLeaveAddDate
									   else sad.ProjectedLeaveDate			 
								  end) < getdate()	and ext.ExitReportUploadedDate is null 			
					 then 'Exit Report Outstanding'
				 end 																										as ExceptionType
				,NULLIF(mu5.Description,'')																				AS InitialStrand   -- 09/10/2023 - <SK> - <27218>
				,NULLIF(mu6.Description,'')																				AS ConfirmedStrand -- 09/10/2023 - <SK> - <27218>
from			(select		*
				 from DV.HUB_Case
				 union all
				 select		cast(0x0 as binary(32))
							,'ADAPT|99999999'
							,'ADAPT.PROP_WP_GEN'
							,getdate())					cas
join			(select		* 
				 from DV.LINK_Case_Participant
				 union all
				 select		cast(0x0 as binary(32))
							,cast(0x0 as binary(32))
							,cast(0x0 as binary(32))
							,'ADAPT.PROP_X_CAND_WP'
							,getdate()) 				par	on par.CaseHash				= cas.CaseHash
left join		BV.LINK_Case_Employee					emp on emp.Case_EmployeeHash	= cas.CaseHash
left join		DV.SAT_Employee_Adapt_Core				eac on eac.EmployeeHash			= emp.EmployeeHash		and eac.IsCurrent = 1
left join		DV.LINK_Case_Referral					ref on ref.CaseHash				= cas.CaseHash
left join		DV.LINK_Referral_RequestingOrganisation	rro on rro.ReferralHash			= ref.ReferralHash
left join		DV.LINK_Referral_RequestingSite			rrs on rrs.ReferralHash			= ref.ReferralHash 
left join		BV.LINK_Case_DeliverySite				dsi on dsi.CaseHash				= cas.CaseHash 
left join		DV.LINK_Referral_Programme				pro on pro.ReferralHash			= ref.ReferralHash
left join		DV.SAT_Participant_Adapt_Core_PersonGen pac on pac.ParticipantHash		= par.ParticipantHash	and pac.IsCurrent = 1
left join		DV.SAT_Case_Adapt_Core					cac on cac.CaseHash				= cas.CaseHash			and cac.IsCurrent = 1
left join		(select * from 
						(select sr1.*,row_number() over (partition by sr1.ReferralHash order by sr1.ReferralHash, sr1.ReferralDate desc) as rn
						from	DV.SAT_Referral_Adapt_Core sr1 where sr1.IsCurrent = 1) sr2
						where sr2.rn = 1)				rac on rac.ReferralHash		= ref.ReferralHash and rac.IsCurrent = 1
left join		DV.SAT_References_MDMultiNames			mu1 on mu1.ID = rac.ReferralType		and mu1.IsCurrent = 1  and mu1.Type = 'Code'
left join		DV.SAT_References_MDMultiNames			mu2 on mu2.ID = cac.CaseStatus			and mu2.IsCurrent = 1  and mu2.Type = 'Code'
left join		DV.SAT_References_MDMultiNames			mu3 on mu3.ID = cac.WorkRedinessStatus	and mu3.IsCurrent = 1  and mu3.Type = 'Code'
left join		DV.SAT_References_MDMultiNames			mu4 on mu4.ID = cac.LeaveReason			and mu4.IsCurrent = 1  and mu4.Type = 'Code'
left join		DV.SAT_References_MDMultiNames			mu5 on mu5.ID = cac.InitStrand			and mu5.IsCurrent = 1  and mu5.Type = 'Code' -- 09/10/2023 - <SK> - <27218>
left join		DV.SAT_References_MDMultiNames			mu6 on mu6.ID = cac.ConfStrand			and mu6.IsCurrent = 1  and mu6.Type = 'Code' -- 09/10/2023 - <SK> - <27218>
left join 		(select	sad.CaseHash
						,min(cast(sad.StartVerifiedDate as date))		as StartVerifiedDate
						,min(cast(sad.StartDate as date))				as StartDate
						,min(cast(sad.LeaveDate as date))				as LeaveDate
						,min(cast(sad.ProjectedLeaveDate as date))		as ProjectedLeaveDate
						,min(cast(sad.ReportDate as date))				as ReportDate
						,min(cast(sad.ReferralSLADate as date))			as ReferralSLADate	
						,count(dat.date_skey)							as WorkingDaysSinceOrLeftToProjectedLeaveDate
				from		DV.SAT_Case_Adapt_Dates	sad
				left join	dwh.dim_date			dat	on dat.[Date] > sad.ProjectedLeaveDate and dat.[Date] <= getdate()     			and dat.is_business_day = 1 -- WorkingDaysSinceProjectedLeaveDate
														or dat.[Date] > getdate() 	  		   and dat.[Date] <= sad.ProjectedLeaveDate and dat.is_business_day = 1 -- WorkingDaysLeftToProjectedLeaveDate
				where		sad.iscurrent = 1
				group by	sad.CaseHash)				sad on sad.CaseHash	= cas.CaseHash
left join		(select	 aac.CaseHash										as CaseHash
						,min(aac.JobOutcomeOneClaimedDate_NotDWP)			as JobOutcomeOneClaimedDate_NotDWP
						,min(aac.JobOutcomeOneClaimedDate_IsDWP)			as JobOutcomeOneClaimedDate_IsDWP
						,min(aac.JobOutcomeOneClaimedDate)					as JobOutcomeOneClaimedDate
						,max(aac.AssignmentLeaveDate)						as AssignmentLeaveDate
						,max(aac.JobLeaveAddDate)							as JobLeaveAddDate
						,min(aac.WorkingDaysSinceLastJobLeaveAddDate)		as WorkingDaysSinceLastJobLeaveAddDate
						,count(dat.date_skey)								as WorkingDaysSinceJobOutcomeOneClaimedDate
				from
				(
					select		lca.CaseHash
								,min(case when isnull(aac.AssignmentOutcomeOneClaimYear,'') not like '%DWP%' and aac.AssignmentOutcomeOneClaimYear is not null then aac.AssignmentOutcomeOneClaimedDate end)	as JobOutcomeOneClaimedDate_NotDWP
								,min(case when isnull(aac.AssignmentOutcomeOneClaimYear,'') like '%DWP%' and aac.AssignmentOutcomeOneClaimYear is not null then aac.AssignmentOutcomeOneClaimedDate end)		as JobOutcomeOneClaimedDate_IsDWP
								,min(case when aac.AssignmentOutcomeOneClaimYear is not null then aac.AssignmentOutcomeOneClaimedDate end)																		as JobOutcomeOneClaimedDate
								,max(aac.AssignmentLeaveDate)																																					as AssignmentLeaveDate
								,max(lea.JobLeaveAddDate)																																						as JobLeaveAddDate
								,min(lea.WorkingDaysSinceLastJobLeaveAddDate)																																	as WorkingDaysSinceLastJobLeaveAddDate
					from		DV.SAT_Assignment_Adapt_Core		aac
					join		DV.LINK_Case_Assignment				lca on lca.AssignmentHash	= aac.AssignmentHash
					left join	(select		laa.AssignmentHash
											,max(laa.AuditDate)		as JobLeaveAddDate
											,count(dat.date_skey)	as WorkingDaysSinceLastJobLeaveAddDate
								from		DV.SAT_Assignment_LeaveAudit_Adapt_Core laa
								left join	dwh.dim_date			dat	on dat.[date] > laa.AuditDate and dat.[Date] <= getdate() and dat.is_business_day = 1
								where		laa.IsCurrent = 1
								group by	laa.AssignmentHash)		lea on lea.AssignmentHash	= aac.AssignmentHash
					join		DV.SAT_Case_Adapt_Core				cac on cac.CaseHash			= lca.CaseHash				and cac.IsCurrent = 1
					left join	DV.SAT_Entity_SoftDelete_Adapt_Core sda on sda.EntityKey		= aac.AssignmentReference	and sda.IsCurrent = 1
					where		aac.IsCurrent = 1
					and			sda.EntityKey is null
					group by	lca.CaseHash
				) aac
				left join	dwh.dim_date				dat	on dat.[date] > aac.JobOutcomeOneClaimedDate and dat.[Date] <= getdate() and dat.is_business_day = 1
				group by aac.CaseHash)					aac on aac.CaseHash	= cas.CaseHash
--left join		(select		subq.Casehash
--							,min(subq.WorkingDayKey)			as ProjectedOutcomeDate
--				from		(select		fae.Casehash
--										,fae.WorkingDayKey
--										,(fae.Working_Hours * fae.Hourly_Rate) Earnings
--										,sum((fae.Working_Hours * fae.Hourly_Rate)) over(partition by fae.CaseHash order by fae.WorkingDayKey rows between unbounded preceding and current row) as Cum
--							from		DV.Fact_AssignmentEarnings fae
--							where		(fae.Working_Hours * fae.Hourly_Rate) <> 0 ) subq
--				where		subq.Cum >= 3952
--				group by	subq.Casehash)							pea on pea.Casehash		= convert(char(66),isnull(cas.CaseHash,cast(0x0 as binary(32))),1)
left join		dwh.Fact_AssignmentEarnings							pea on pea.Casehash		= convert(char(66),isnull(cas.CaseHash,cast(0x0 as binary(32))),1)
left join		dwh.dim_HMRC_PingData								pin on pin.CaseHashBin	= cas.CaseHash
left join		(select			cba.CaseHash											as CaseHash
								,min(case when bac.BarrierEndDate is null then 1 end)	as IANotCompleted
								,1														as IABooked
								,min(bac.BarrierStartDate)								as IABookedDate
								,min(bac.BarrierEndDate)								as IACompletedDate
				from			DV.HUB_Barriers						bar
				left join		DV.LINK_Case_Barriers				cba on cba.BarriersHash = bar.BarriersHash 
				left join		DV.SAT_Barriers_Adapt_Core			bac on bac.BarriersHash = cba.BarriersHash and bac.IsCurrent = 1
				left join		DV.SAT_References_MDMultiNames		mu1 on mu1.ID = bac.BarrierName and mu1.Type = 'Code'
				where			bar.RecordSource = 'ADAPT.PROP_BARRIER_GEN'
				--and				bac.BarrierEndDate is null  ---- Updated 22/06/23
				and				coalesce(nullif(mu1.Name,''),nullif(mu1.Description,''),'Unknown') = 'Initial Appointment'
				group by		cba.CaseHash)						iap on iap.CaseHash =  cas.CaseHash
left join		(select			cba.CaseHash						as CaseHash
								,min(case when bac.BarrierEndDate is null					then 1 end)						as IsDisengaged
								,min(case when bac.BarrierEndDate is null					then bac.BarrierStartDate end)	as IsDisengagedDate
								,case when (min(case when bac.BarrierEndDate is null		then 1 end) is null
										   and min(case when bac.BarrierEndDate is not null	then 1 end) = 1) then 1 end		as WasDisengaged
				from			DV.HUB_Barriers						bar
				left join		DV.LINK_Case_Barriers				cba on cba.BarriersHash = bar.BarriersHash 
				left join		DV.SAT_Barriers_Adapt_Core			bac on bac.BarriersHash = cba.BarriersHash and bac.IsCurrent = 1
				left join		DV.SAT_References_MDMultiNames		mu1 on mu1.ID = bac.BarrierName and mu1.Type = 'Code'
				where			bar.RecordSource = 'ADAPT.PROP_BARRIER_GEN'
				and				((coalesce(nullif(mu1.Name,''),nullif(mu1.Description,''),'Unknown') like '%Disengage%')				
								or (coalesce(nullif(mu1.Name,''),nullif(mu1.Description,''),'Unknown') like '%suspend engagement%'))
				group by		cba.CaseHash)						dis on dis.CaseHash =  cas.CaseHash
left join		(				select			lcc.CaseHash												as CaseHash
								--,min(case when	mu1.Description		= 'BOT - Welcome Pack'		and mu2.Description = '2:Achieved'					then 1 end) as CorNoWelcome
								,min(case when	(mu1.Description	= 'BOT - Welcome Pack' Or mu3.Description		= 'Welcome Pack Sent')		and mu2.Description = '2:Achieved'	then 1 end) as CorNoWelcome  ---- Updated 22/06/23
								,min(case when	mu3.Description		= 'Action Plan sent to PP'	and mu2.Description in ('2:Achieved','12:Exceeded')	then 1 end) as CorNoActionPlan
				from			DV.SAT_Correspondence_Adapt_Core	cac
				left join		DV.LINK_Case_Correspondence			lcc on lcc.CorrespondenceHash = cac.CorrespondenceHash
				left join		DV.SAT_Entity_SoftDelete_Adapt_Core sda ON sda.EntityKey = cac.CorrespondenceReferenceKey			and sda.IsCurrent = 1
				left join 		DV.SAT_References_MDMultiNames		mu1	on mu1.id = cac.CorrespondenceMethod  and mu1.Type = 'Code'	and mu1.IsCurrent = 1
				left join 		DV.SAT_References_MDMultiNames		mu2	on mu2.id = cac.CorrespondenceOutcome and mu2.Type = 'Code'	and mu2.IsCurrent = 1
				left join 		DV.SAT_References_MDMultiNames		mu3	on mu3.id = cac.CorrespondenceType	  and mu3.Type = 'Code'	and mu3.IsCurrent = 1
				where			cac.IsCurrent = 1
				and				sda.EntityKey IS NULL
				group by		lcc.CaseHash)						cor on cor.CaseHash		= cas.CaseHash 
left join		(select			lcd.CaseHash
								,1 as NoWelcome
				from			DV.SAT_Document_Adapt_Core			dac
				left join		DV.LINK_Case_Document				lcd on lcd.DocumentHash = dac.DocumentHash
				left join		DV.SAT_Entity_SoftDelete_Adapt_Core	sda on sda.EntityKey = dac.DocumentReferenceKey			and sda.IsCurrent = 1
				where			dac.IsCurrent = 1
				and				sda.EntityKey IS NULL
				and				dac.DocumentName in ('Welcome Pack','WHP Welcome Pack','Participant Declaration')
				and				dac.CompletedDate is null
				group by		lcd.CaseHash)						doc on doc.CaseHash		= cas.CaseHash 
left join		(select			cor1.CaseHash
								,cor1.FirstCorrespondenceDate
								,cor1.LastCorrespondenceDate
								,cor1.LastSuccessfulCorrDate		
								,cor1.NoOfUnsuccessfulContactsInLastMonth
								,cor1.LastCorrespondenceStatus
								,cor1.WorkingDaysSinceLastCorrespondenceDate
								,count(d1.date_skey)									as WorkingDaysSinceLastLastSuccessfulCorrDate
				from			(select			cor.CaseHash
												,min(cor.CorrespondenceDate)											as FirstCorrespondenceDate
												,max(cor.CorrespondenceDate)											as LastCorrespondenceDate
												,max(case when cor.CorrespondenceStatus = 'Completed'
														  then cor.CorrespondenceDate  
														  else null
													  end)																as LastSuccessfulCorrDate
												,count(case when cor.CorrespondenceStatus != 'Completed' and cor.CorrespondenceDate >= dateadd(mm, -1, getdate()) 
															then cor.CorrespondenceDate  
															else null
													  end)																as NoOfUnsuccessfulContactsInLastMonth
												,max(case when cor.rn <> 1 then null else cor.CorrespondenceStatus end)	as LastCorrespondenceStatus
												,count(d.date_skey)														as WorkingDaysSinceLastCorrespondenceDate
								from			(select			crr.CaseHash
																,cac.CorrespondenceDate
																,mu1.Description										as CorrespondenceStatus
																,row_number() over (partition by crr.CaseHash order by cac.CorrespondenceDate desc) as rn
												from			DV.link_case_Correspondence			crr
												left join		DV.SAT_Correspondence_Adapt_Core	cac on cac.CorrespondenceHash = crr.CorrespondenceHash and cac.IsCurrent = 1
												left join 		DV.SAT_References_MDMultiNames		mu1	on mu1.id = cac.CorrespondenceOutcome and mu1.Type = 'Code'	and mu1.IsCurrent = 1
												left join 		DV.SAT_References_MDMultiNames		mu2	on mu2.id = cac.CorrespondenceMethod  and mu2.Type = 'Code'	and mu2.IsCurrent = 1
												where			cac.CorrespondenceDate <= getdate()
												and				isnull(mu2.Description, '') != 'BOT - FTA') cor
								left join		dwh.dim_date		d	on d.[date] > cor.CorrespondenceDate and d.[Date] <= getdate() and d.is_business_day = 1 and cor.rn = 1
								group by		cor.CaseHash)		cor1			
				left join		dwh.dim_date						d1	on d1.[date] > cor1.LastSuccessfulCorrDate and d1.[Date] <= getdate() and d1.is_business_day = 1
				group by		cor1.CaseHash
								,cor1.FirstCorrespondenceDate
								,cor1.LastCorrespondenceDate
								,cor1.LastSuccessfulCorrDate
								,cor1.NoOfUnsuccessfulContactsInLastMonth
								,cor1.LastCorrespondenceStatus
								,cor1.WorkingDaysSinceLastCorrespondenceDate)	cfl on cfl.CaseHash		= cas.CaseHash
left join		(select			act.CaseHash
								,min(act.ActivityStartDate)												as FirstWFADate
								,max(act.ActivityStartDate)												as LastWFADate
								,max(case when act.rn <> 1 then null else act.WFAActivityStatus end)	as LastWFAStatus
								,count(dat.date_skey)													as WorkingDaysSinceLastWFADate
				from			(select			lca.CaseHash
												,sac.ActivityStartDate
												,mu1.Description as WFAActivityStatus
												,row_number() over (partition by lca.CaseHash order by sac.ActivityStartDate desc) as rn
								from			DV.LINK_case_Activity				lca
								left join		DV.SAT_Activity_Adapt_Core			sac on sac.ActivityHash = lca.ActivityHash and sac.IsCurrent = 1 and (isnull(sac.ActivityName,'') like '%Work First Appraisal%' or isnull(sac.ActivityName,'') like '%Working First Appraisal%') 
								left join 		DV.SAT_References_MDMultiNames		mu1	on mu1.id = sac.ActivityStatus and mu1.Type = 'Code'	and mu1.IsCurrent = 1
								where			sac.ActivityStartDate <= getdate()) act
				left join		dwh.dim_date						dat	on dat.[date] > act.ActivityStartDate and dat.[Date] <= getdate() and dat.is_business_day = 1 and act.rn = 1
				group by		act.CaseHash)						wfa on wfa.CaseHash		= cas.CaseHash
left join		DV.Fact_EarningsAnalysis							erg on erg.CaseHash		= convert(char(66),cas.CaseHash,1)
left join		(select			ass.CaseHashBin
								,min(ass.AssignmentTitle)			as FirstJobAssignmentTitle
								,min(ass.AssignmentStartDate)		as FirstJobAssignmentStartDate
								,min(ass.AssignmentStartDate)		as FirstJobStartDate
								,min(ass.WeeklyHours)				as FirstJobWeeklyHours
								,min(ass.ContractedHours)			as FirstJobContractedHours
								,min(ass.EmploymentSiteName)		as FirstJobEmploymentSiteName
								,min(ass.EmploymentOrgName)			as FirstJobEmploymentOrgName 
								,min(ass.AssignmentLeaveDate)		as FirstJobLeaveDate
								,min(ass.AssignmentStartClaimDate)	as FirstJobClaimDate
								,min(ass.AssignmentAddDate)         as FirstJobAddDate -- 10/07/23 <MK> <24899>
				from			dwh.fact_Assignment					ass				
				where			ass.IsFirstJob = 1
				group by		ass.CaseHashBin)					gfi on gfi.CaseHashBin = cas.CaseHash
left join		(select			ass.CaseHashBin
								,max(ass.AssignmentTitle)			as LastJobAssignmentTitle
								,max(ass.AssignmentStartDate)		as LastJobAssignmentStartDate
								,max(ass.WeeklyHours)				as LastJobWeeklyHours
								,max(ass.ContractedHours)			as LastJobContractedHours
								,max(ass.EmploymentSiteName)		as LastJobEmploymentSiteName
								,max(ass.EmploymentOrgName)			as LastJobEmploymentOrgName -- 10/07/23 <MK> <24899>
								,max(ass.AssignmentLeaveDate)		as LastJobLeaveDate
								,max(ass.AssignmentStartClaimDate)	as LastJobClaimDate
								,max(ass.JobOwningAdvisor)			as LastJobOwningAdvisor  ---- Added on 08/07/2023
								,max(ass.AssignmentAddDate)			as LastJobAddDate -- 10/07/23 <MK> <24899>
				from			dwh.fact_Assignment					ass				
				where			ass.IsLastJob = 1
				group by		ass.CaseHashBin)					laj on laj.CaseHashBin = cas.CaseHash
left join		(select		tmp.CaseHash							as CaseHash
							,min(ddu.UploadedDate)					as ExitReportUploadedDate
				from		stg.Meta_WorkflowEventsStaging			tmp
				left join	DV.LINK_Case_DocumentUpload				cdu on cdu.CaseHash = tmp.CaseHashBin
				left join	DV.SAT_DocumentUpload_Adapt_Core		ddu on ddu.DocumentUploadHash = cdu.DocumentUploadHash and ddu.IsCurrent = 1
				where        (isnull(ddu.DocumentName,'')        	like '%Exit%Report%'
				or            isnull(ddu.DocumentDescription,'') 	like '%Exit%Report%')
				group by	tmp.CaseHash)							ext on ext.CaseHash = cas.CaseHash
left join		(select 	los.CaseHash
							,sos.AnswerDate							as LatestDistanceTravelledDate
							,sos.Colour								as LatestDistanceTravelled
							,row_number() over (partition by los.CaseHash order by sos.AnswerDate asc) rn
				from 		DV.LINK_Case_OutcomeScore				los
				join 		DV.SAT_OutcomeScore_Adapt_Core			sos	on los.OutcomeScoreHash = sos.OutcomeScoreHash	and sos.IsCurrent = 1
				)													ots	on ots.CaseHash			= cas.CaseHash			and ots.rn = 1

Left join		(Select     lca.Casehash
				from		DV.SAT_Assignment_Adapt_Core		aac
				join		DV.LINK_Case_Assignment				lca on lca.AssignmentHash	    = aac.AssignmentHash
				left join	DV.LINK_Case_Referral				ref on ref.CaseHash				= lca.CaseHash
				left join	DV.LINK_Referral_Programme			pro on pro.ReferralHash			= ref.ReferralHash
				Left Join	[DV].[SAT_Programme_Adapt_Core]		pr  on pro.[ProgrammeHash]       = pr.[ProgrammeHash]    and pr.IsCurrent = 1
				WHere		aac.iscurrent = 1
				AND			aac.AssignmentStartDate is not null
				AND			aac.AssignmentLeaveDate is Null
				AND			aac.AssignmentStartClaimYear not like 'DNC%'   ---- 14/08/23 <MK> <26306>
				AND			Pr.ProgrammeName in ('WHP Wales', 'WHP London')
				Group by    lca.Casehash
				)											   InWork on cas.Casehash = Inwork.Casehash	

where			cas.RecordSource = 'ADAPT.PROP_WP_GEN'	--This line is Temp until we add other sources
--and			convert(char(66),isnull(cas.CaseHash,cast(0x0 as binary(32))),1) = '0x3C4F5DDFC287DAAF1E31BD70D419CD4FF9F026CB20A8F4A77D509205EB8BD2ED'
and not			(cast(rac.ReferralDate as date) is null and convert(char(66),cas.CaseHash,1) <> '0x0000000000000000000000000000000000000000000000000000000000000000')
and not exists	(select		1
				 from		DV.SAT_Entity_SoftDelete_Adapt_Core csa
				 where		csa.IsCurrent		= 1 
				 and		(csa.EntityHash		= cas.CaseHash
							or csa.EntityHash	= ref.ReferralHash
							or csa.EntityHash	= dsi.DeliverySiteHash
							or csa.EntityKey	= pac.ParticipantEntityKey))
)

select			*
from			FactCase
where			RowNumber = 1;
GO