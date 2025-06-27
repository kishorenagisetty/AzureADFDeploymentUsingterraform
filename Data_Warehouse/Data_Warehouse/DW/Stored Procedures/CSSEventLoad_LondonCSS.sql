CREATE PROC [DW].[CSSEventLoad_LondonCSS] AS

declare		@SLADuration int;
declare		@LoadStartTime as datetime;
declare		@LoadStartMessage as varchar(100);
set			@LoadStartTime = getdate();


delete 
from		DV.SAT_WorkFlowEvents_Meta_Core_New 
where		CSSName like '%WHP London%';

--------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------
-- London WHP CSS1 Rules --------------------------------------------------------------
--------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------

insert into	DV.SAT_WorkFlowEvents_Meta_Core_New
			(CaseHashBin
			,CaseHash
			,EmployeeHashBin
			,EmployeeHash
			,AssignmentHashIfNeeded
			,WorkFlowEventDate
			,WorkFlowEventEstimatedStartDate
			,WorkFlowEventEstimatedEndDate
			,InOutWork
			,CSSName
			,RecordSource)
select		tmp.CaseHashBin									as CaseHashBin
			,tmp.CaseHash									as CaseHash
			,null											as EmployeeHashBin
			,null											as EmployeeHash			
			,null											as AssignmentHashIfNeeded
			,tmp.FirstCorrespondenceDate					as WorkFlowEventDate
			,tmp.ReferralDate								as WorkFlowEventEstimatedStartDate 
			,(select	max(gdt.[Date])	as [Date]
			 from		(select top (select					wfc.WorkFlowEventSLADuration *1
									 from					META.SAT_WorkFlowEventType_Core wfc
									 where					wfc.WorkFlowEventProgramme = 'WHP London'
									 and					wfc.WorkFlowEventCSSRelated = 'CSS1')	ddd.[Date]
						 from		DW.d_date ddd
						 where		ddd.[Date] > tmp.ReferralDate
						 and		ddd.is_business_day = 1
						 order by	ddd.[Date]) gdt)		as WorkFlowEventEstimatedEndDate
			,tmp.InOutWork									as InOutWork
			,'WHP London  -  CSS1'							as CSSName
			,tmp.RecordSource								as RecordSource
from		stg.Meta_WorkflowEventsStaging					tmp
where		tmp.ProgrammeName = 'WHP London';

set @LoadStartMessage = concat('London CSS 1 Time Taken = ',(select cast((getdate()-@LoadStartTime) as time(0)) '[hh:mm:ss]'))
raiserror(@LoadStartMessage, 0, 1) with nowait;
set @LoadStartTime = getdate();

--------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------
-- London WHP CSS2 Rules ------------------------------------------------------------
--------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------

insert into	DV.SAT_WorkFlowEvents_Meta_Core_New
			(CaseHashBin
			,CaseHash
			,EmployeeHashBin
			,EmployeeHash
			,AssignmentHashIfNeeded
			,WorkFlowEventDate
			,WorkFlowEventEstimatedStartDate
			,WorkFlowEventEstimatedEndDate
			,InOutWork
			,CSSName
			,RecordSource)
select		tmp.CaseHashBin									as CaseHashBin
			,tmp.CaseHash									as CaseHash
			,null											as EmployeeHashBin
			,null											as EmployeeHash
			,null											as AssignmentHashIfNeeded
			,cs2.WorkFlowEventDate							as WorkFlowEventDate
			,tmp.ReferralDate								as WorkFlowEventEstimatedStartDate 
			,(select	max(gdt.[Date])	as [Date]
			 from		(select top (select			wfc.WorkFlowEventSLADuration *1
									 from			META.SAT_WorkFlowEventType_Core wfc
									 where			wfc.WorkFlowEventProgramme = 'WHP London'
									 and			wfc.WorkFlowEventCSSRelated = 'CSS2')	ddd.[Date]
						 from		DW.d_date ddd
						 where		ddd.[Date] > tmp.ReferralDate
						 and		ddd.is_business_day = 1
						 order by	ddd.[Date]) gdt)		as WorkFlowEventEstimatedEndDate
			,tmp.InOutWork									as InOutWork
			,'WHP London  -  CSS2'							as CSSName
			,tmp.RecordSource								as RecordSource
from		stg.Meta_WorkflowEventsStaging					tmp
left join	(select		lca.CaseHash						as CaseHash
						,min(sac.ActivityCompleteDate)		as WorkFlowEventDate
			from		DV.LINK_Case_Activity				lca
			join		DV.SAT_Activity_Adapt_Core			sac on sac.ActivityHash = lca.ActivityHash		and sac.IsCurrent = 1	and sac.activityname = 'Welcome Meeting'
			where		cast(sac.ActivityCompleteDate as date) <= cast(getdate() as date)
			and			sac.ActivityRelatedSupportNeed = 'Initial Appointment'
			group by	lca.CaseHash)						cs2 on cs2.CaseHash = tmp.CaseHashBin
where		tmp.ProgrammeName = 'WHP London';

set @LoadStartMessage = concat('London CSS 2 Time Taken = ',(select cast((getdate()-@LoadStartTime) as time(0)) '[hh:mm:ss]'))
raiserror(@LoadStartMessage, 0, 1) with nowait;
set @LoadStartTime = getdate();

--------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------
-- London WHP CSS3 Rules --------------------------------------------------------------
--------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------

insert into	DV.SAT_WorkFlowEvents_Meta_Core_New
			(CaseHashBin
			,CaseHash
			,EmployeeHashBin
			,EmployeeHash
			,AssignmentHashIfNeeded
			,WorkFlowEventDate
			,WorkFlowEventEstimatedStartDate
			,WorkFlowEventEstimatedEndDate
			,InOutWork
			,CSSName
			,RecordSource)
select		tmp.CaseHashBin									as CaseHashBin
			,tmp.CaseHash									as CaseHash
			,null											as EmployeeHashBin
			,null											as EmployeeHash
			,null											as AssignmentHashIfNeeded
			,cs3.WorkFlowEventDate							as WorkFlowEventDate
			,tmp.ReferralDate								as WorkFlowEventEstimatedStartDate 
			,(select	max(gdt.[Date])	as [Date]
			 from		(select top (select			wfc.WorkFlowEventSLADuration *1
									 from			META.SAT_WorkFlowEventType_Core wfc
									 where			wfc.WorkFlowEventProgramme = 'WHP London'
									 and			wfc.WorkFlowEventCSSRelated = 'CSS3')	ddd.[Date]
						 from		DW.d_date ddd
						 where		ddd.[Date] > tmp.ReferralDate
						 and		ddd.is_business_day = 1
						 order by	ddd.[Date]) gdt)		as WorkFlowEventEstimatedEndDate
			,tmp.InOutWork									as InOutWork
			,'WHP London  -  CSS3'							as CSSName
			,tmp.RecordSource								as RecordSource
from		stg.Meta_WorkflowEventsStaging					tmp
left join	(select		lca.CaseHash						as CaseHash
						,min(sac.ActivityCompleteDate)		as WorkFlowEventDate
			from		DV.LINK_Case_Activity				lca
			join		DV.SAT_Activity_Adapt_Core			sac on sac.ActivityHash = lca.ActivityHash		and sac.IsCurrent = 1
			where		cast(sac.ActivityCompleteDate as date) <= cast(getdate() as date)
			and			(isnull(sac.ActivityRelatedSupportNeed,'') like '%BPSA%' or isnull(sac.activityname,'') like '%BPSA%')
			group by	lca.CaseHash)						cs3 on cs3.CaseHash = tmp.CaseHashBin
where		tmp.ProgrammeName = 'WHP London'
and 		tmp.StartDate is not null;

set @LoadStartMessage = concat('London CSS 3 Time Taken = ',(select cast((getdate()-@LoadStartTime) as time(0)) '[hh:mm:ss]'))
raiserror(@LoadStartMessage, 0, 1) with nowait;
set @LoadStartTime = getdate();

--------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------
-- London WHP CSS4 Rules --------------------------------------------------------------
--------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------

insert into	DV.SAT_WorkFlowEvents_Meta_Core_New
			(CaseHashBin
			,CaseHash
			,EmployeeHashBin
			,EmployeeHash
			,AssignmentHashIfNeeded
			,WorkFlowEventDate
			,WorkFlowEventEstimatedStartDate
			,WorkFlowEventEstimatedEndDate
			,InOutWork
			,CSSName
			,RecordSource)
select		tmp.CaseHashBin									as CaseHashBin
			,tmp.CaseHash									as CaseHash
			,null											as EmployeeHashBin
			,null											as EmployeeHash
			,null											as AssignmentHashIfNeeded
			,cs4.DocUploadedDate							as WorkFlowEventDate
			,tmp.ReferralDate								as WorkFlowEventEstimatedStartDate 
			,(select	max(gdt.[Date])	as [Date]
			 from		(select top (select					wfc.WorkFlowEventSLADuration *1
									 from					META.SAT_WorkFlowEventType_Core wfc
									 where					wfc.WorkFlowEventProgramme = 'WHP London'
									 and					wfc.WorkFlowEventCSSRelated = 'CSS4')	ddd.[Date]
						 from		DW.d_date ddd
						 where		ddd.[Date] > tmp.ReferralDate
						 and		ddd.is_business_day = 1
						 order by	ddd.[Date]) gdt)		as WorkFlowEventEstimatedEndDate
			,tmp.InOutWork									as InOutWork
			,'WHP London  -  CSS4'							as CSSName
			,tmp.RecordSource								as RecordSource
from		stg.Meta_WorkflowEventsStaging					tmp
left join	(select		tmp.CaseHash
						,min(ddu.UploadedDate)				as DocUploadedDate
			from		stg.Meta_WorkflowEventsStaging		tmp
			join		DV.LINK_Case_DocumentUpload			cdu on cdu.CaseHash = tmp.CaseHashBin
			join		DV.SAT_DocumentUpload_Adapt_Core	ddu on ddu.DocumentUploadHash = cdu.DocumentUploadHash
			group by	tmp.CaseHash)						cs4 on cs4.CaseHash = tmp.CaseHash
where		tmp.ProgrammeName = 'WHP London'
and 		tmp.StartDate is not null;

set @LoadStartMessage = concat('London CSS 4 Time Taken = ',(select cast((getdate()-@LoadStartTime) as time(0)) '[hh:mm:ss]'))
raiserror(@LoadStartMessage, 0, 1) with nowait;
set @LoadStartTime = getdate();

--------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------
-- London WHP CSS5 Rules -------------------------------------------------------------
--------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------


with			FirstEmpDate as
(
select			lce.EmployeeHash					as EmployeeHash
				,min(tmp.StartDate)					as StartDate
from			stg.Meta_WorkflowEventsStaging		tmp
left join		BV.LINK_Case_Employee				lce on lce.Case_EmployeeHash	= tmp.CaseHashBin 
left join		DV.SAT_Employee_Adapt_Core			sec on sec.EmployeeHash			= lce.EmployeeHash			and sec.IsCurrent = 1
where			tmp.StartDate is not null 
and				tmp.ProgrammeName = 'WHP London'
group by		lce.EmployeeHash
)
,				LastEmpDate as
(
select			lce.EmployeeHash					as EmployeeHash
				,max(case 
					when tmp.StartDate is not null and tmp.LeaveDate is not null
					then cast(getdate() as date)
					else tmp.LeaveDate
				 end)								as LeaveDate					 
from			stg.Meta_WorkflowEventsStaging		tmp
left join		BV.LINK_Case_Employee				lce on lce.Case_EmployeeHash	= tmp.CaseHashBin 
left join		DV.SAT_Employee_Adapt_Core			sec on sec.EmployeeHash			= lce.EmployeeHash			and sec.IsCurrent = 1
where			tmp.StartDate is not null 
and				tmp.ProgrammeName = 'WHP London'
group by		lce.EmployeeHash
)
,				DoDateCross as
(
select			fem.EmployeeHash
				,dat.date
from			FirstEmpDate							fem
join			LastEmpDate								lem on lem.EmployeeHash = fem.EmployeeHash
cross apply		(select		ddd.date
				 from		dwh.dim_Date				ddd
				 where		ddd.Date >= fem.StartDate
				 and		ddd.Date <= lem.LeaveDate)	dat 
)

insert into		DV.SAT_WorkFlowEvents_Meta_Core_New
				(CaseHashBin
				,CaseHash
				,EmployeeHashBin
				,EmployeeHash
				,AssignmentHashIfNeeded
				,WorkFlowEventDate
				,WorkFlowEventEstimatedStartDate
				,WorkFlowEventEstimatedEndDate
				,InOutWork
				,CSSName
				,RecordSource)
select			cast(0x0 as binary(32))														as CaseHashBin
				,'0x0000000000000000000000000000000000000000000000000000000000000000'		as CaseHash
				,ddc.EmployeeHash															as EmployeeHashBin
				,convert(char(66),isnull(ddc.EmployeeHash ,cast(0x0 as binary(32))),1)		as EmployeeHash
				,null																		as AssignmentHashIfNeeded
				,ddc.date																	as WorkFlowEventDate
				,ddc.date																	as WorkFlowEventEstimatedStartDate
				,case 
				   when sum(case when ddc.date >= tmp.StartDate and ddc.date <= tmp.Leavedate then 1 end) >= 65
				   then	dateadd(day,-1,ddc.date)
				   else ddc.date
				 end																		as WorkFlowEventEstimatedEndDate
				,null																		as InOutWork
				,'WHP London  -  CSS5'														as CSSName
				,'ADAPT.PROP_WP_GEN'														as RecordSource
from			DoDateCross											ddc
left join		(select			sec.EmployeeHash											as EmployeeHash
								,tmp.StartDate												as StartDate
								,isnull(tmp.Leavedate,cast(getdate() as date))				as Leavedate
								,tmp.RecordSource
				from			stg.Meta_WorkflowEventsStaging		tmp
				left join		BV.LINK_Case_Employee				lce on lce.Case_EmployeeHash	= tmp.CaseHashBin 
				left join		DV.SAT_Employee_Adapt_Core			sec on sec.EmployeeHash			= lce.EmployeeHash			and sec.IsCurrent = 1
				where			tmp.StartDate is not null 
				and				tmp.ProgrammeName = 'WHP London'
				)													tmp on tmp.EmployeeHash = ddc.EmployeeHash
group by		ddc.EmployeeHash
				,ddc.date
				,RecordSource;

set @LoadStartMessage = concat('London CSS 5 Time Taken = ',(select cast((getdate()-@LoadStartTime) as time(0)) '[hh:mm:ss]'))
raiserror(@LoadStartMessage, 0, 1) with nowait;
set @LoadStartTime = getdate();

--------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------
-- London WHP CSS6 Rules --------------------------------------------------------------
--------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------

select		@SLADuration =	wfc.WorkFlowEventSLADuration *1
from		META.SAT_WorkFlowEventType_Core wfc
where		wfc.WorkFlowEventProgramme = 'WHP London'
and			wfc.WorkFlowEventCSSRelated = 'CSS6';

with BarrierStartEndDates as (
select distinct	tmp.CaseHashBin								as CaseHashBin
			,tmp.CaseHash									as CaseHash
			,'Barrier End Date'								as ActivityName
			,cast(bac.BarrierEndDate as date)				as ActivityDate
			,cast(bac.BarrierStartDate as date)				as BarrierStartDate 
			,tmp.RecordSource								as RecordSource
from		stg.Meta_WorkflowEventsStaging					tmp
join		DV.LINK_Case_Activity							lca on lca.CaseHash = tmp.CaseHashBin
join		DV.SAT_Activity_Adapt_Core						sac on sac.ActivityHash = lca.ActivityHash		and sac.IsCurrent = 1
join		DV.LINK_Case_Barriers							cba on cba.CaseHash	= tmp.CaseHashBin  
join		DV.SAT_Barriers_Adapt_Core						bac on bac.BarriersHash = cba.BarriersHash and bac.IsCurrent = 1
join		DV.SAT_References_MDMultiNames					mu1 on mu1.ID = bac.BarrierName and mu1.Type = 'Code'
where		tmp.ProgrammeName = 'WHP London'
and 		(isnull(sac.ActivityName,'') like '%EWRA%' 
			 or isnull(sac.ActivityName,'') = 'Enhanced Work Readiness Assessment' 
			 or isnull(sac.ActivityRelatedSupportNeed,'') like '%EWRA%' 
			 or isnull(sac.ActivityRelatedSupportNeed,'') = 'Enhanced Work Readiness Assessment'
			)
and 		tmp.StartDate is not null
and			sac.ActivityStartDate >= tmp.StartDate
and 		bac.BarrierEndDate > sac.ActivityStartDate 		-- Only pick barriers which continue until after the EWRA Start Date
and 		((coalesce(nullif(mu1.Name,''),nullif(mu1.Description,''),'Unknown') like '%Disengage%')				
			  or (coalesce(nullif(mu1.Name,''),nullif(mu1.Description,''),'Unknown') like '%suspend engagement%'))
)
,CaseStartDate as (
-- Get start date for a case
select		tmp.CaseHashBin									as CaseHashBin
			,tmp.CaseHash									as CaseHash
			,'Start Date'									as ActivityName
			,min(cast(sac.ActivityStartDate as date))		as ActivityDate
			,null											as BarrierStartDate 
			,tmp.RecordSource								as RecordSource
from		stg.Meta_WorkflowEventsStaging					tmp
join		DV.LINK_Case_Activity							lca on lca.CaseHash = tmp.CaseHashBin
join		DV.SAT_Activity_Adapt_Core						sac on sac.ActivityHash = lca.ActivityHash		and sac.IsCurrent = 1
where		tmp.ProgrammeName = 'WHP London'	
and 		(isnull(sac.ActivityName,'') like '%EWRA%' 
			 or isnull(sac.ActivityName,'') = 'Enhanced Work Readiness Assessment' 
			 or isnull(sac.ActivityRelatedSupportNeed,'') like '%EWRA%' 
			 or isnull(sac.ActivityRelatedSupportNeed,'') = 'Enhanced Work Readiness Assessment'
			)
and 		tmp.StartDate is not null
and			sac.ActivityStartDate >= tmp.StartDate
group by	tmp.CaseHashBin
			,tmp.CaseHash
			,tmp.RecordSource		
union
-- If a participant has completed the disengagement barrier, then we need to exclude the periods when disengagement barrier was effective
-- So BarrierEndDate needs to be included as the start date, because date ranges need to be generated again after that date
-- Self-join is done because barrier start and end dates can overlap
select		a.CaseHashBin									as CaseHashBin
			,a.CaseHash										as CaseHash
			,a.ActivityName									as ActivityName
			,isnull(b.ActivityDate, a.ActivityDate)			as ActivityDate
			, min(isnull(case when b.BarrierStartDate > a.BarrierStartDate 
							  then a.BarrierStartDate 
							  else b.BarrierStartDate 
						 end, a.BarrierStartDate))			as BarrierStartDate
			,a.RecordSource									as RecordSource
from 	  BarrierStartEndDates								a
left join BarrierStartEndDates								b on  a.CaseHash = b.CaseHash 
															  and a.ActivityDate > b.BarrierStartDate 
															  and a.ActivityDate < b.ActivityDate 
group by a.CaseHashBin, a.CaseHash, a.ActivityName, isnull(b.ActivityDate, a.ActivityDate), a.RecordSource
)
,CaseExitDate as (
-- Get exit date for a case
select		csd.CaseHashBin									as CaseHashBin
			,csd.CaseHash									as CaseHash
			,'Exit Activity'								as ActivityName
			,max(cast(sac.ActivityDueDate as date))			as ActivityDate 
			,csd.RecordSource								as RecordSource
			,csd.ActivityDate								as StartDate
from		CaseStartDate									csd
join		DV.LINK_Case_Activity							lca on lca.CaseHash = csd.CaseHashBin
join		DV.SAT_Activity_Adapt_Core						sac on sac.ActivityHash = lca.ActivityHash		and sac.IsCurrent = 1 and sac.ActivityName in ('Exit Interview', 'Exit Review') 
group by	csd.CaseHashBin
			,csd.CaseHash
			,sac.ActivityName
			,csd.RecordSource
			,csd.ActivityDate
union
-- If a participant has completed the disengagement barrier, then we need to exclude the periods when disengagement barrier was effective
-- So BarrierStartDate needs to be included as an exit date
select		csd.CaseHashBin									as CaseHashBin
			,csd.CaseHash									as CaseHash
			,'Barrier Start Date'							as ActivityName
			,csd.BarrierStartDate							as ActivityDate 
			,csd.RecordSource								as RecordSource
			,null											as StartDate
from		CaseStartDate									csd
where		csd.BarrierStartDate is not null
) 
,GetWorkflowActivity as (	-- Get start date, exit date, and all activities for a case
select		csd.CaseHashBin									as CaseHashBin
			,csd.CaseHash									as CaseHash
			,csd.ActivityName									as ActivityName
			,csd.ActivityDate								as ActivityDueDate
			,csd.RecordSource								as RecordSource
			,csd.ActivityDate								as StartDate
from		CaseStartDate									csd
join		CaseStartDate									csd1 on csd.CaseHashBin = csd1.CaseHashBin 		and csd1.ActivityName = 'Start Date'
left join	CaseExitDate									ced	 on ced.CaseHash 	= csd.CaseHash			and	ced.ActivityName = 'Exit Activity'	-- Get exit activity date
where		csd.ActivityDate <= isnull(ced.ActivityDate, 
										case	when dateadd(day, 639, csd1.ActivityDate) > getdate()
												then getdate()
												else dateadd(day, 639, csd1.ActivityDate) 
										end)
union
select		distinct 
			csd.CaseHashBin									as CaseHashBin
			,csd.CaseHash									as CaseHash
			,'Has Activity'									as ActivityName
			,cast(sac.ActivityCompleteDate as date)			as ActivityDueDate
			,csd.RecordSource								as RecordSource
			,csd.ActivityDate								as StartDate
from		CaseStartDate									csd
join		DV.LINK_case_Activity							lca on lca.CaseHash		= csd.CaseHashBin
join		DV.SAT_Activity_Adapt_Core						sac on sac.ActivityHash = lca.ActivityHash		and sac.IsCurrent = 1
left join	CaseExitDate									ced	on ced.CaseHash 	= csd.CaseHash			and	ced.ActivityName = 'Exit Activity'	-- Get exit activity date
where		sac.ActivityCompleteDate >= isnull(csd.ActivityDate, '1900-01-01')	-- Activity is between start and exit dates
and			sac.ActivityCompleteDate <= isnull(ced.ActivityDate, 
												case	when dateadd(day, 639, csd.ActivityDate) > getdate()
														then getdate()
														else dateadd(day, 639, csd.ActivityDate) 
												end)
and			csd.ActivityName = 'Start Date'
-- Do not pick up activities which occurred while the participant was disengaged
and not exists (select		dis.CaseHash
				from		CaseStartDate					dis
				where		dis.CaseHash = csd.CaseHash
				and			sac.ActivityCompleteDate between dis.BarrierStartDate and dis.ActivityDate)
union
select		distinct 
			csd.CaseHashBin									as CaseHashBin
			,csd.CaseHash									as CaseHash
			,'Has Activity'									as ActivityName
			,cast(sca.CorrespondenceDate as date)			as ActivityDueDate
			,csd.RecordSource								as RecordSource
			,csd.ActivityDate								as StartDate
from		CaseStartDate									csd
left join	DV.LINK_Case_Correspondence						lcc on lcc.CaseHash 		  = csd.CaseHashBin
left join	DV.SAT_Correspondence_Adapt_Core				sca on sca.CorrespondenceHash = lcc.CorrespondenceHash
left join	CaseExitDate									ced	on ced.CaseHash 		  = csd.CaseHash				and	ced.ActivityName = 'Exit Activity'	-- Get exit activity date
where		sca.CorrespondenceDate is not null
and			sca.CorrespondenceDate >= isnull(csd.ActivityDate, '1900-01-01') -- Activity is between start and exit dates
and			sca.CorrespondenceDate <= isnull(ced.ActivityDate, 
											case	when dateadd(day, 639, csd.ActivityDate) > getdate()
													then getdate()
													else dateadd(day, 639, csd.ActivityDate) 
											end) 
and			csd.ActivityName = 'Start Date'
-- Do not pick up activities which occurred while the participant was disengaged
and not exists (select		dis.CaseHash
				from		CaseStartDate					dis
				where		dis.CaseHash = csd.CaseHash
				and			sca.CorrespondenceDate between dis.BarrierStartDate and dis.ActivityDate)
union
-- Get exit date for a case
select		ced.CaseHashBin									as CaseHashBin
			,ced.CaseHash									as CaseHash
			,ced.ActivityName								as ActivityName
			,ced.ActivityDate								as ActivityDueDate 
			,ced.RecordSource								as RecordSource
			,ced.StartDate									as StartDate
from		CaseExitDate									ced
union	-- For cases where there is no exit date, use start date + 639 days and put ActivityName as 'Missing Exit'
		-- If start date + 639 days is in future or if there is no start date, use today's date as exit date
select		csd.CaseHashBin									as CaseHashBin
			,csd.CaseHash									as CaseHash
			,'Missing Exit'									as ActivityName
			,case	when dateadd(day, 639, csd.ActivityDate) > getdate()
					then getdate()
					else dateadd(day, 639, csd.ActivityDate) 
			 end											as ActivityDueDate 
			,csd.RecordSource								as RecordSource
			,csd.ActivityDate								as StartDate
from		CaseStartDate									csd
where		-- Exclude cases where there is an exit date
not exists	(select		ced.CaseHash
			from		CaseExitDate						ced
			where		ced.CaseHash = csd.CaseHash
			and			ced.ActivityName = 'Exit Activity')
and			csd.ActivityName = 'Start Date'
)
,CSS6_Base	as (
-- If there are multiple activities within the due date range, only select the first activity
select grp.CaseHashBin, grp.CaseHash, grp.ActivityName, grp.ActivityDate, grp.NextActivityDueDate, min(grp.NextActivityDateWithinDueDate) as NextActivityDateWithinDueDate, max(grp.NextActivityDateAfterDueDate) as NextActivityDateAfterDueDate, grp.NextActivityNameAfterDueDate, max(grp.NextActivityDueDateAfterCurrentDueDate) as NextActivityDueDateAfterCurrentDueDate, grp.RecordSource
from (
	select	wf1.CaseHashBin
			, wf1.CaseHash
			, wf1.ActivityName
			, wf1.ActivityDate
			, wf1.NextActivityDueDate
			, NextActivityDateWithinDueDate = wf2.ActivityDueDate
			, wf1.NextActivityDateWithinDueDate1d
			, wf1.NextActivityDateWithinDueDate10wd
			-- Following three columns are used in the next CTE to generate records when there are missed activities 
			,case	when wf2.ActivityDueDate is null 
					then lead(wf1.ActivityDate, 1) over (partition by wf1.CaseHash order by wf1.ActivityDate asc, wf1.ActivityName desc) 
					else null
			 end											as NextActivityDateAfterDueDate		-- If there is no activity within the current due date range, get activity date for the next earliest activity (whenever it took place)
			,case 	when wf2.ActivityDueDate is null 
					then lead(wf1.ActivityName, 1) over (partition by wf1.CaseHash order by wf1.ActivityDate asc, wf1.ActivityName desc) 
					else null
			 end											as NextActivityNameAfterDueDate		-- If there is no activity within the current due date range, get activity name for the next earliest activity (whenever it took place)
			,case	when wf2.ActivityDueDate is null 
					then lead(wf1.NextActivityDueDate, 1) over (partition by wf1.CaseHash order by wf1.ActivityDate asc, wf1.ActivityName desc) 
					else null
			 end											as NextActivityDueDateAfterCurrentDueDate		-- If there is no activity within the current due date range, get activity due date for the next earliest activity (whenever it took place)
			, wf1.RecordSource
	from
		(
		select		wf1.CaseHashBin									as CaseHashBin
					,wf1.CaseHash									as CaseHash
					,wf1.ActivityName								as ActivityName
					,wf1.ActivityDueDate							as ActivityDate
					,(select max ([Date])
						from   
							(
							select top(( @SLADuration )+0 ) [Date]
							from   dw.d_date
							where  [Date] > wf1.ActivityDueDate
								and is_business_day = 1
							order by [Date]
							) a
					)												as NextActivityDueDate
					,dateadd(day, 1, wf1.ActivityDueDate)			as NextActivityDateWithinDueDate1d
					,(select max ([Date])
						from   
							(
							select top(( @SLADuration )+0 ) [Date]
							from   dw.d_date
							where  [Date] > wf1.ActivityDueDate
								and is_business_day = 1
							order by [Date]
							) a
					)												as NextActivityDateWithinDueDate10wd
					,wf1.RecordSource								as RecordSource
		from		GetWorkflowActivity								wf1
		)															wf1
		left join	GetWorkflowActivity								wf2 on wf2.CaseHash = wf1.CaseHash			-- Get next activity which is within the current due date range
																	   and wf2.ActivityDueDate between 
																		   case when wf1.ActivityName in ('Start Date', 'Barrier End Date')
																				then wf1.ActivityDate
																				else wf1.NextActivityDateWithinDueDate1d
																		   end 
																		   and wf1.NextActivityDateWithinDueDate10wd
																	   and wf2.ActivityName in ('Has Activity', 'Exit Activity')
) grp
where grp.NextActivityNameAfterDueDate is null
	-- Exlude records where either the current activity is 'Barrier Start Date' or 
	-- if participant has gone Disengaged before next activity due date
   or (grp.ActivityName != 'Barrier Start Date' and grp.NextActivityNameAfterDueDate != 'Barrier Start Date') 
   or (grp.NextActivityNameAfterDueDate = 'Barrier Start Date' and grp.NextActivityDateAfterDueDate > grp.NextActivityDueDate)
group by grp.CaseHashBin, grp.CaseHash, grp.ActivityName, grp.ActivityDate, grp.NextActivityDueDate, grp.NextActivityNameAfterDueDate, grp.RecordSource						
)
,CSS6_Complete as (
select		 c6b.CaseHashBin
	        ,c6b.CaseHash
			,c6b.ActivityName
			,c6b.ActivityDate
			,c6b.NextActivityDueDate
			,c6b.NextActivityDateWithinDueDate
			,c6b.NextActivityDateAfterDueDate
			,c6b.NextActivityNameAfterDueDate
			,c6b.RecordSource
from		CSS6_Base										c6b
where		c6b.ActivityName not in ('Exit Activity', 'Missing Exit', 'Barrier Start Date') -- Exit date line gets generated in the below union
union all
-- Fill gaps between missing appointments
select		 c6b.CaseHashBin
			,c6b.CaseHash
			,case	when	c6b.Date >= c6b.NextActivityDateAfterDueDate
							and c6b.NextActivityNameAfterDueDate not in ('Missing Exit', 'Has Activity')
					then	c6b.NextActivityNameAfterDueDate			-- If next earliest activity is the final exit activity then use actual exit activity name. This regenerates the exit line which is excluded in above union with correct dates
					else	'Missing Activity'
				end											as ActivityName
			,null											as ActivityDate
 			,c6b.Date										as NextActivityDueDate
			,case	when	c6b.Date >= c6b.NextActivityDateAfterDueDate 			-- If the generated missing due date is after next earliest activity then use date for the next earliest activity as NextActivityDateWithinDueDate
							and c6b.NextActivityNameAfterDueDate != 'Missing Exit'	-- however if the next earliest activity is 'Missing Exit' then that means there was no next earliest activity and it should be null
					then	c6b.NextActivityDateAfterDueDate
					else	null										
			end												as NextActivityDateWithinDueDate
			, null											as NextActivityDateAfterDueDate
			, null											as NextActivityNameAfterDueDate
			,c6b.RecordSource								as RecordSource				
from
(
	select c6b.*, ddd.Date, row_number() over (partition by c6b.CaseHash, c6b.NextActivityDueDate, c6b.NextActivityDateAfterDueDate order by ddd.Date) rn
	from		CSS6_Base										c6b
	-- Get all working days from due date until the due date of next earliest activity
	join	dw.d_date											ddd on ddd.Date > c6b.NextActivityDueDate 
																	and ddd.Date < c6b.NextActivityDueDateAfterCurrentDueDate
																	and ddd.is_business_day = 1	
	where		c6b.NextActivityDateWithinDueDate is null		-- Identifies records where an activity hasn't taken place when it was due as we only need to generate missing gaps for these ones
	and			(    c6b.NextActivityNameAfterDueDate is null 
				-- Since Disengaged needs to be excluded, so the missing records need to be generated up until just prior to the 'Barrier Start Date'
				 or c6b.NextActivityNameAfterDueDate != 'Barrier Start Date'
				 or (c6b.NextActivityNameAfterDueDate = 'Barrier Start Date' and ddd.DATE < c6b.NextActivityDateAfterDueDate )) 
	and			c6b.ActivityName not in ('Exit Activity', 'Missing Exit')	-- Exit activity record is not needed because it gets regenerated while generating the missing records within this union
) c6b where rn % @SLADuration = 0		-- Only pick up every @SLADuration working day
)

insert into	DV.SAT_WorkFlowEvents_Meta_Core_New
			(CaseHashBin
			,CaseHash
			,EmployeeHashBin
			,EmployeeHash
			,AssignmentHashIfNeeded
			,WorkFlowEventDate
			,WorkFlowEventEstimatedStartDate
			,WorkFlowEventEstimatedEndDate
			,InOutWork
			,CSSName
			,RecordSource)
select		cs6.CaseHashBin									as CaseHashBin
			,cs6.CaseHash									as CaseHash
			,null											as EmployeeHashBin
			,null											as EmployeeHash
			,null											as AssignmentHashIfNeeded
			,cs6.NextActivityDateWithinDueDate				as WorkFlowEventDate
			-- For WorkFlowEventEstimatedStartDate, get previous WorkFlowEventDate. If null then get previous WorkFlowEventEstimatedEndDate. When there is no previous record get the first activity date (usually will be the start date)
			,case when cs6.ActivityName in ('Start Date', 'Barrier End Date') then cs6.ActivityDate
				  else coalesce(lag(cs6.NextActivityDateWithinDueDate, 1) over (partition by cs6.CaseHash order by cs6.NextActivityDueDate, isnull(cs6.NextActivityDateWithinDueDate, cs6.NextActivityDateAfterDueDate))
							   ,lag(cs6.NextActivityDueDate, 1) over (partition by cs6.CaseHash order by cs6.NextActivityDueDate, isnull(cs6.NextActivityDateWithinDueDate, cs6.NextActivityDateAfterDueDate)))
			 end						 					as WorkFlowEventEstimatedStartDate
			,cs6.NextActivityDueDate						as WorkFlowEventEstimatedEndDate 
			,null											as InOutWork
			,'WHP London  -  CSS6'							as CSSName
			,cs6.RecordSource								as RecordSource
from		CSS6_Complete									cs6;

set @LoadStartMessage = concat('London CSS 6 Time Taken = ',(select cast((getdate()-@LoadStartTime) as time(0)) '[hh:mm:ss]'))
raiserror(@LoadStartMessage, 0, 1) with nowait;
set @LoadStartTime = getdate();

--------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------
-- London WHP CSS7 Rules --------------------------------------------------------------
--------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------

select		@SLADuration =	wfc.WorkFlowEventSLADuration *1
from		META.SAT_WorkFlowEventType_Core wfc
where		wfc.WorkFlowEventProgramme = 'WHP London'
and			wfc.WorkFlowEventCSSRelated = 'CSS7';

with BarrierStartEndDates as (
select distinct	tmp.CaseHashBin								as CaseHashBin
			,tmp.CaseHash									as CaseHash
			,'Barrier End Date'								as ActivityName
			,cast(bac.BarrierEndDate as date)				as ActivityDate
			,cast(bac.BarrierStartDate as date)				as BarrierStartDate	
			,tmp.RecordSource								as RecordSource
from		stg.Meta_WorkflowEventsStaging					tmp
join		DV.LINK_Case_Barriers							cba on cba.CaseHash	= tmp.CaseHashBin  
join		DV.SAT_Barriers_Adapt_Core						bac on bac.BarriersHash = cba.BarriersHash and bac.IsCurrent = 1
join		DV.SAT_References_MDMultiNames					mu1 on mu1.ID = bac.BarrierName and mu1.Type = 'Code'
where		tmp.ProgrammeName = 'WHP London'	
and			tmp.InOutWork = 'Unemployed'					-- Exclude InWork
and 		tmp.StartDate is not null
and 		bac.BarrierEndDate > tmp.StartDate				-- Only pick barriers which continue until after the start date
and 		((coalesce(nullif(mu1.Name,''),nullif(mu1.Description,''),'Unknown') like '%Disengage%')				
			  or (coalesce(nullif(mu1.Name,''),nullif(mu1.Description,''),'Unknown') like '%suspend engagement%'))
)
,CaseStartDate as (
-- Get start date for a case
select		tmp.CaseHashBin										as CaseHashBin
			,tmp.CaseHash										as CaseHash
			,'Start Date'										as ActivityName
			,min(tmp.StartDate)									as ActivityDate
			,null												as BarrierStartDate 
			,tmp.RecordSource									as RecordSource
from		stg.Meta_WorkflowEventsStaging						tmp
where		tmp.ProgrammeName = 'WHP London'	
and			tmp.InOutWork = 'Unemployed'						-- Exclude InWork
and 		tmp.StartDate is not null
group by	tmp.CaseHashBin
			,tmp.CaseHash
			,tmp.RecordSource
union
-- If a participant has completed the disengagement barrier, then we need to exclude the periods when disengagement barrier was effective
-- So BarrierEndDate needs to be included as the start date, because date ranges need to be generated again after that date
-- Self-join is done because barrier start and end dates can overlap
select		a.CaseHashBin									as CaseHashBin
			,a.CaseHash										as CaseHash
			,a.ActivityName									as ActivityName
			,isnull(b.ActivityDate, a.ActivityDate)			as ActivityDate
			, min(isnull(case when b.BarrierStartDate > a.BarrierStartDate 
							  then a.BarrierStartDate 
							  else b.BarrierStartDate 
						 end, a.BarrierStartDate))			as BarrierStartDate
			,a.RecordSource									as RecordSource
from 	  BarrierStartEndDates								a
left join BarrierStartEndDates								b on  a.CaseHash = b.CaseHash 
															  and a.ActivityDate > b.BarrierStartDate 
															  and a.ActivityDate < b.ActivityDate 														  
group by a.CaseHashBin, a.CaseHash, a.ActivityName, isnull(b.ActivityDate, a.ActivityDate), a.RecordSource
)
,CaseExitDate as (
-- Get exit date for a case
select		csd.CaseHashBin									as CaseHashBin
			,csd.CaseHash									as CaseHash
			,'Exit Activity'								as ActivityName
			,max(cast(sac.ActivityCompleteDate as date))	as ActivityDate 
			,csd.RecordSource								as RecordSource
from		CaseStartDate									csd
join		DV.LINK_Case_Activity							lca on lca.CaseHash = csd.CaseHashBin
join		DV.SAT_Activity_Adapt_Core						sac on sac.ActivityHash = lca.ActivityHash		and sac.IsCurrent = 1 and sac.ActivityName in ('Exit Interview', 'Exit Review') 
group by	csd.CaseHashBin
			,csd.CaseHash
			,sac.ActivityName
			,csd.RecordSource
union
-- If a participant has completed the disengagement barrier, then we need to exclude the periods when disengagement barrier was effective
-- So BarrierStartDate needs to be included as an exit date
select		csd.CaseHashBin									as CaseHashBin
			,csd.CaseHash									as CaseHash
			,'Barrier Start Date'							as ActivityName
			,csd.BarrierStartDate							as ActivityDate 
			,csd.RecordSource								as RecordSource
from		CaseStartDate									csd
where		csd.BarrierStartDate is not null
) 	
,GetWorkflowActivity as (	-- Get start date, exit date, and all action plan document uploaded dates for a case
-- Case start date
select		csd.CaseHashBin									as CaseHashBin
			,csd.CaseHash									as CaseHash
			,csd.ActivityName								as ActivityName
			,csd.ActivityDate								as ActivityCompleteDate
			,csd.RecordSource								as RecordSource
from		CaseStartDate									csd
join		CaseStartDate									csd1 on csd.CaseHashBin = csd1.CaseHashBin 		and csd1.ActivityName = 'Start Date'
left join	CaseExitDate									ced	 on ced.CaseHash 	= csd.CaseHash			and	ced.ActivityName = 'Exit Activity'	-- Get exit activity date
where		csd.ActivityDate <= isnull(ced.ActivityDate, 
										case	when dateadd(day, 639, csd1.ActivityDate) > getdate()
												then getdate()
												else dateadd(day, 639, csd1.ActivityDate) 
										end)
and			csd.ActivityDate <= dateadd(day, 639, csd1.ActivityDate)
union all
-- Get all action plan document uploaded dates for a case between start and the final exit dates
select		distinct 
			csd.CaseHashBin									as CaseHashBin
			,csd.CaseHash									as CaseHash
			,'Has Activity'									as ActivityName
			,cast(ddu.UploadedDate as date)					as ActivityCompleteDate
			,csd.RecordSource								as RecordSource
from		CaseStartDate									csd
join		DV.LINK_Case_DocumentUpload						cdu on cdu.CaseHash = csd.CaseHashBin
join		DV.SAT_DocumentUpload_Adapt_Core				ddu on ddu.DocumentUploadHash = cdu.DocumentUploadHash
left join	CaseExitDate									ced	on ced.CaseHash = csd.CaseHash						and	ced.ActivityName = 'Exit Activity'	-- Get exit activity date
where		(isnull(ddu.DocumentName,'')        like '%Action%%Plan%'
or           isnull(ddu.DocumentName,'')        like '% AP %'
or           isnull(ddu.DocumentDescription,'') like '%Action%%Plan%'
or           isnull(ddu.DocumentDescription,'') like '% AP %')		
and			 ddu.UploadedDate >= isnull(csd.ActivityDate, '1900-01-01')		-- If start date is not found, get all action plan document uploaded dates from beginning
and			 ddu.UploadedDate <= isnull(ced.ActivityDate, 
										case	when dateadd(day, 639, csd.ActivityDate) > getdate()
												then getdate()
												else dateadd(day, 639, csd.ActivityDate) 
										end) 
and			csd.ActivityName = 'Start Date'										
-- Do not pick up activities which occurred while the participant was disengaged
and not exists (select		dis.CaseHash
				from		CaseStartDate					dis
				where		dis.CaseHash = csd.CaseHash
				and			ddu.UploadedDate 	between dis.BarrierStartDate and dis.ActivityDate)
union all
-- Get exit date for a case
select		ced.CaseHashBin									as CaseHashBin
			,ced.CaseHash									as CaseHash
			,ced.ActivityName								as ActivityName
			,ced.ActivityDate								as ActivityCompleteDate 
			,ced.RecordSource								as RecordSource
from		CaseExitDate 									ced
union all	
-- For cases where there is no exit date, use start date + 639 days and put ActivityName as 'Missing Exit'
-- If start date + 639 days is in future or if there is no start date, use today's date as exit date
select		csd.CaseHashBin									as CaseHashBin
			,csd.CaseHash									as CaseHash
			,'Missing Exit'									as ActivityName
			,case	when dateadd(day, 639, csd.ActivityDate) > getdate()
					then getdate()
					else dateadd(day, 639, csd.ActivityDate) 
			 end											as ActivityCompleteDate 
			,csd.RecordSource								as RecordSource
from		CaseStartDate									csd
where		-- Do not generate 'missing exits' for cases where there is an exit date present
not exists	(select		ced.CaseHash
			from		CaseExitDate						ced
			where		ced.CaseHash = csd.CaseHash
			and			ced.ActivityName = 'Exit Activity')
and			csd.ActivityName = 'Start Date'
)
,CSS7_Base	as (
-- If there are multiple activities within the due date range, only select the first activity
select grp.CaseHashBin, grp.CaseHash, grp.ActivityName, grp.ActivityDate, grp.NextActivityDueDate, min(grp.NextActivityDateWithinDueDate) as NextActivityDateWithinDueDate, max(grp.NextActivityDateAfterDueDate) as NextActivityDateAfterDueDate, grp.NextActivityNameAfterDueDate, grp.RecordSource
from
(
	select		wf1.CaseHashBin									as CaseHashBin
				,wf1.CaseHash									as CaseHash										
				,wf1.ActivityName								as ActivityName
				,wf1.ActivityCompleteDate						as ActivityDate
				,dateadd(dd, @SLADuration
						   , wf1.ActivityCompleteDate)			as NextActivityDueDate
				,wf2.ActivityCompleteDate						as NextActivityDateWithinDueDate 
				-- Following two columns are used in the next CTE to generate records when there are missed action plan document upload dates
				,case	when wf2.ActivityCompleteDate is null 
						then lead(wf1.ActivityCompleteDate, 1) over (partition by wf1.CaseHash order by wf1.ActivityCompleteDate asc, wf1.ActivityName desc) 
						else null
				 end											as NextActivityDateAfterDueDate		-- If there is no activity within the current due date range, get activity date for the next earliest activity (whenever it took place)
				, case 	when wf2.ActivityCompleteDate is null 
						then lead(wf1.ActivityName, 1) over (partition by wf1.CaseHash order by wf1.ActivityCompleteDate asc, wf1.ActivityName desc) 
						else null
				 end											as NextActivityNameAfterDueDate		-- If there is no activity within the current due date range, get activity name for the next earliest activity (whenever it took place)
				,wf1.RecordSource								as RecordSource
	from		GetWorkflowActivity								wf1
	left join	GetWorkflowActivity								wf2 on wf2.CaseHash = wf1.CaseHash			-- Get next activity which is within the current due date range
																   and wf2.ActivityCompleteDate between 
																	   case when wf1.ActivityName in ('Start Date', 'Barrier End Date')
																			 then wf1.ActivityCompleteDate 
																			 else dateadd(dd, 1, wf1.ActivityCompleteDate) 
																	   end 
																	   and dateadd(dd, @SLADuration, wf1.ActivityCompleteDate) 
																   and wf2.ActivityName in ('Has Activity', 'Exit Activity')
) grp
where grp.NextActivityNameAfterDueDate is null
	-- Exlude records where either the current activity is 'Barrier Start Date' or 
	-- if participant has gone Disengaged before next activity due date
   or (grp.ActivityName != 'Barrier Start Date' and grp.NextActivityNameAfterDueDate != 'Barrier Start Date') 
   or (grp.NextActivityNameAfterDueDate = 'Barrier Start Date' and grp.NextActivityDateAfterDueDate > grp.NextActivityDueDate)
group by grp.CaseHashBin, grp.CaseHash, grp.ActivityName, grp.ActivityDate, grp.NextActivityDueDate, grp.NextActivityNameAfterDueDate, grp.RecordSource
)
,CSS7_Complete as (
select	  	 c7b.CaseHashBin
			,c7b.CaseHash
			,c7b.ActivityName
			,c7b.ActivityDate
			,c7b.NextActivityDueDate
			,c7b.NextActivityDateWithinDueDate
			,c7b.NextActivityDateAfterDueDate
			,c7b.NextActivityNameAfterDueDate
			,c7b.RecordSource
from		CSS7_Base										c7b
where		c7b.ActivityName not in ('Exit Activity', 'Missing Exit', 'Barrier Start Date') 	-- Exit date line gets generated in the below union
union all
-- Fill gaps between missing WFA activities
select		 c7b.CaseHashBin
			,c7b.CaseHash
			,case	when	ddd.DATE >= c7b.NextActivityDateAfterDueDate
							and c7b.NextActivityNameAfterDueDate not in ('Missing Exit', 'Has Activity')
					then	c7b.NextActivityNameAfterDueDate			-- If next earliest activity is the final exit activity then use actual exit activity name. This regenerates the exit line which is excluded in above union with correct dates
					else	'Missing Doc Upload Date'
			 end											as ActivityName
			,null											as ActivityDate
 			,ddd.DATE										as NextActivityDueDate
			,case	when	ddd.DATE >= c7b.NextActivityDateAfterDueDate 			-- If the generated missing due date is after next earliest activity then use date for the next earliest activity as NextActivityDateWithinDueDate
							and c7b.NextActivityNameAfterDueDate != 'Missing Exit'	-- however if the next earliest activity is 'Missing Exit' then that means there was no next earliest activity and it should be null
					then	c7b.NextActivityDateAfterDueDate
					else	null										
			end												as NextActivityDateWithinDueDate
			, null											as NextActivityDateAfterDueDate
			, null											as NextActivityNameAfterDueDate
			,c7b.RecordSource								as RecordSource
from		CSS7_Base										c7b
-- Get dates in @SLADuration day intervals from due date until the date of next earliest activity + @SLADuration days
join		dw.d_date										ddd on ddd.DATE > c7b.NextActivityDueDate 
																and ddd.DATE < dateadd(day, @SLADuration, c7b.NextActivityDateAfterDueDate) 
																-- Calculates difference in days between each date and the due date, divides it by @SLADuration and checks if the remainder is 0. This ensures we get dates in @SLADuration days intervals only.
																and datediff(day, ddd.DATE, c7b.NextActivityDueDate) % @SLADuration = 0 
where		c7b.NextActivityDateWithinDueDate is null		-- Identifies records where WFA activity hasn't taken place when it was due as we only need to generate missing gaps for these ones
and			(    c7b.NextActivityNameAfterDueDate is null 
			-- Since Disengaged needs to be excluded, so the missing records need to be generated up until just prior to the 'Barrier Start Date'
			 or c7b.NextActivityNameAfterDueDate != 'Barrier Start Date'
			 or (c7b.NextActivityNameAfterDueDate = 'Barrier Start Date' and ddd.DATE < c7b.NextActivityDateAfterDueDate )) 
and			c7b.ActivityName not in ('Exit Activity', 'Missing Exit') 	-- Exit activity record is not needed because it gets regenerated while generating the missing records within this union
)

insert into	DV.SAT_WorkFlowEvents_Meta_Core_New
			(CaseHashBin
			,CaseHash
			,EmployeeHashBin
			,EmployeeHash
			,AssignmentHashIfNeeded
			,WorkFlowEventDate
			,WorkFlowEventEstimatedStartDate
			,WorkFlowEventEstimatedEndDate
			,InOutWork
			,CSSName
			,RecordSource)
select		c7b.CaseHashBin									as CaseHashBin
			,c7b.CaseHash									as CaseHash
			,null											as EmployeeHashBin
			,null											as EmployeeHash
			,null											as AssignmentHashIfNeeded
			,c7b.NextActivityDateWithinDueDate				as WorkFlowEventDate
			-- For WorkFlowEventEstimatedStartDate, get previous WorkFlowEventDate. If null then get previous WorkFlowEventEstimatedEndDate. When there is no previous record get the first activity date (usually will be the start date)
			,case when c7b.ActivityName in ('Start Date', 'Barrier End Date') then c7b.ActivityDate
				  else coalesce(lag(c7b.NextActivityDateWithinDueDate, 1) over (partition by c7b.CaseHash order by c7b.NextActivityDueDate, isnull(c7b.NextActivityDateWithinDueDate, c7b.NextActivityDateAfterDueDate))
							   ,lag(c7b.NextActivityDueDate, 1) over (partition by c7b.CaseHash order by c7b.NextActivityDueDate, isnull(c7b.NextActivityDateWithinDueDate, c7b.NextActivityDateAfterDueDate)))
			 end 											as WorkFlowEventEstimatedStartDate
			,c7b.NextActivityDueDate						as WorkFlowEventEstimatedEndDate 
			,null											as InOutWork
			,'WHP London  -  CSS7'							as CSSName
			,c7b.RecordSource								as RecordSource
from		CSS7_Complete									c7b;

set @LoadStartMessage = concat('London CSS 7 Time Taken = ',(select cast((getdate()-@LoadStartTime) as time(0)) '[hh:mm:ss]'))
raiserror(@LoadStartMessage, 0, 1) with nowait;
set @LoadStartTime = getdate();

--------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------
-- London WHP CSS8 Rules --------------------------------------------------------------
--------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------

insert into	DV.SAT_WorkFlowEvents_Meta_Core_New
			(CaseHashBin
			,CaseHash
			,EmployeeHashBin
			,EmployeeHash
			,AssignmentHashIfNeeded
			,WorkFlowEventDate
			,WorkFlowEventEstimatedStartDate
			,WorkFlowEventEstimatedEndDate
			,InOutWork
			,CSSName
			,RecordSource)
select		tmp.CaseHashBin									as CaseHashBin
			,tmp.CaseHash									as CaseHash
			,null											as EmployeeHashBin
			,null											as EmployeeHash
			,null											as AssignmentHashIfNeeded
			,cs8.WorkFlowEventDate							as WorkFlowEventDate
			,tmp.StartDate									as WorkFlowEventEstimatedStartDate 
			,tmp.ProjectedLeaveDate							as WorkFlowEventEstimatedEndDate
			,tmp.InOutWork									as InOutWork
			,'WHP London  -  CSS8'							as CSSName
			,tmp.RecordSource								as RecordSource
from stg.Meta_WorkflowEventsStaging							tmp
left join
(
	select		 lca.CaseHash						as CaseHash
			    ,min(sac.ActivityCompleteDate)		as WorkFlowEventDate
	from		DV.LINK_Case_Activity				lca
	join		DV.SAT_Activity_Adapt_Core			sac on sac.ActivityHash = lca.ActivityHash		and sac.IsCurrent = 1
	left join	DV.SAT_References_MDMultiNames		mu1	on mu1.ID = sac.ActivityType 				and mu1.Type = 'Code'
	left join	DV.SAT_References_MDMultiNames		mu2	on mu2.ID = sac.ActivityStatus 				and mu2.Type = 'Code'
	where		(mu1.Description like '%CV%' 
	or			sac.ActivityName like '%CV%')
	and			mu2.Description = 'Completed'
	group by	lca.CaseHash
)															cs8	on cs8.CaseHash = tmp.CaseHashBin
where tmp.StartDate is not null
and	  tmp.ProgrammeName = 'WHP London';

set @LoadStartMessage = concat('London CSS 8 Time Taken = ',(select cast((getdate()-@LoadStartTime) as time(0)) '[hh:mm:ss]'))
raiserror(@LoadStartMessage, 0, 1) with nowait;
set @LoadStartTime = getdate();
  
--------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------
-- London WHP CSS9 Rules -------------------------------------------------------------
--------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------

insert into	DV.SAT_WorkFlowEvents_Meta_Core_New
			(CaseHashBin
			,CaseHash
			,EmployeeHashBin
			,EmployeeHash
			,AssignmentHashIfNeeded
			,WorkFlowEventDate
			,WorkFlowEventEstimatedStartDate
			,WorkFlowEventEstimatedEndDate
			,InOutWork
			,CSSName
			,RecordSource)
select		tmp.CaseHashBin									as CaseHashBin
			,tmp.CaseHash									as CaseHash
			,null											as EmployeeHashBin
			,null											as EmployeeHash
			,null											as AssignmentHashIfNeeded
			,evt.ActivityCompleteDate						as WorkFlowEventDate
			,tmp.StartDate									as WorkFlowEventEstimatedStartDate 
			,(select	max(gdt.[Date])	as [Date]
			 from		(select top (select					wfc.WorkFlowEventSLADuration *1
									 from					META.SAT_WorkFlowEventType_Core wfc
									 where					wfc.WorkFlowEventProgramme = 'WHP London'
									 and					wfc.WorkFlowEventCSSRelated = 'CSS9')	ddd.[Date]
						 from		DW.d_date ddd
						 where		ddd.[Date] > tmp.StartDate
						 and		ddd.is_business_day = 1
						 order by	ddd.[Date]) gdt)		as WorkFlowEventEstimatedEndDate		 
			,tmp.InOutWork									as InOutWork
			,'WHP London  -  CSS9'							as CSSName
			,tmp.RecordSource								as RecordSource
from stg.Meta_WorkflowEventsStaging							tmp
left join
(
		select		 lca.CaseHash							as CaseHash
					,min(sac.ActivityCompleteDate)			as ActivityCompleteDate
		from		DV.LINK_Case_Activity					lca
		join		DV.SAT_Activity_Adapt_Core				sac on  sac.ActivityHash = lca.ActivityHash		and sac.IsCurrent = 1
		left join	DV.Dimension_References					dre on  dre.Code = sac.ActivityType
		where		dre.Description in ('BOC', 'Better Off In Work Calculation', 'Start - Better Off In Work Calculation')
		or			sac.ActivityRelatedSupportNeed in ('BOC', 'Better Off In Work Calculation')
		group by 	lca.CaseHash
) evt														on evt.CaseHash = tmp.CaseHashBin
where tmp.StartDate is not null
  and tmp.ProgrammeName = 'WHP London';

set @LoadStartMessage = concat('London CSS 9 Time Taken = ',(select cast((getdate()-@LoadStartTime) as time(0)) '[hh:mm:ss]'))
raiserror(@LoadStartMessage, 0, 1) with nowait;
set @LoadStartTime = getdate();

--------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------
-- London WHP CSS10 Rules -------------------------------------------------------------
--------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------

insert into	DV.SAT_WorkFlowEvents_Meta_Core_New
			(CaseHashBin
			,CaseHash
			,AssignmentHashIfNeeded
			,WorkFlowEventDate
			,WorkFlowEventEstimatedStartDate
			,WorkFlowEventEstimatedEndDate
			,InOutWork
			,CSSName
			,RecordSource)
select		tmp.CaseHashBin									as CaseHashBin
			,tmp.CaseHash									as CaseHash
			,null											as AssignmentHashIfNeeded
			,case when spi.ParticipantHash is null 
				  then null 
				  else 
					case when tmp.StartDate > tmp.LeaveDate 
						 then tmp.LeaveDate
						 else tmp.StartDate
					end
			 end											as WorkFlowEventDate 
			,case when tmp.StartDate > tmp.LeaveDate 
				  then tmp.LeaveDate
				  else tmp.StartDate
			 end											as WorkFlowEventEstimatedStartDate 
			,(select	max(gdt.[Date])	as [Date]
			 from		(select top (select			wfc.WorkFlowEventSLADuration *1
									 from			META.SAT_WorkFlowEventType_Core wfc
									 where			wfc.WorkFlowEventProgramme = 'WHP London'
									 and			wfc.WorkFlowEventCSSRelated = 'CSS10')	ddd.[Date]
						 from		DW.d_date ddd
						 where		ddd.[Date] > case when tmp.StartDate > tmp.LeaveDate 
													  then tmp.LeaveDate
													  else tmp.StartDate
												 end
						 and		ddd.is_business_day = 1
						 order by	ddd.[Date]) gdt)		as WorkFlowEventEstimatedEndDate
			,tmp.InOutWork									as InOutWork
			,'WHP London  -  CSS10'							as CSSName
			,tmp.RecordSource								as RecordSource
from		stg.Meta_WorkflowEventsStaging					tmp
left join	DV.Link_Case_Participant						lcp	on lcp.CaseHash = tmp.CaseHashBin
left join	DV.SAT_Participant_Adapt_Industry				spi on spi.ParticipantHash = lcp.ParticipantHash and spi.iscurrent=1 -- Vacancy Family Box option
where		tmp.ProgrammeName = 'WHP London'
and 		tmp.StartDate is not null;

set @LoadStartMessage = concat('London CSS 10 Time Taken = ',(select cast((getdate()-@LoadStartTime) as time(0)) '[hh:mm:ss]'))
raiserror(@LoadStartMessage, 0, 1) with nowait;
set @LoadStartTime = getdate();

--------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------
-- London WHP CSS11 Rules ------------------------------------------------------------
--------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------

insert into	DV.SAT_WorkFlowEvents_Meta_Core_New
			(CaseHashBin
			,CaseHash
			,EmployeeHashBin
			,EmployeeHash
			,AssignmentHashIfNeeded
			,WorkFlowEventDate
			,WorkFlowEventEstimatedStartDate
			,WorkFlowEventEstimatedEndDate
			,InOutWork
			,CSSName
			,RecordSource)
select		tmp.CaseHashBin									as CaseHashBin
			,tmp.CaseHash									as CaseHash
			,null											as EmployeeHashBin
			,null											as EmployeeHash
			,null											as AssignmentHashIfNeeded
			,c11.ActivityCompleteDate						as WorkFlowEventDate
			,tmp.StartDate									as WorkFlowEventEstimatedStartDate 
			,(select	max(gdt.[Date])	as [Date]
			 from		(select top (select			wfc.WorkFlowEventSLADuration *1
									 from			META.SAT_WorkFlowEventType_Core wfc
									 where			wfc.WorkFlowEventProgramme = 'WHP London'
									 and			wfc.WorkFlowEventCSSRelated = 'CSS11')	ddd.[Date]
						 from		DW.d_date ddd
						 where		ddd.[Date] > tmp.StartDate
						 and		ddd.is_business_day = 1
						 order by	ddd.[Date]) gdt)		as WorkFlowEventEstimatedEndDate
			,tmp.InOutWork									as InOutWork
			,'WHP London  -  CSS11'							as CSSName
			,tmp.RecordSource								as RecordSource
from		stg.Meta_WorkflowEventsStaging					tmp
left join	(select		lca.CaseHash						as CaseHash
						,min(sac.ActivityCompleteDate)		as ActivityCompleteDate
			from		DV.LINK_Case_Activity				lca
			join		DV.SAT_Activity_Adapt_Core			sac on sac.ActivityHash = lca.ActivityHash		and sac.IsCurrent = 1	
			join 		DV.Dimension_References 			dr1 on dr1.Code = sac.ActivityStatus
			join 		DV.Dimension_References 			dr2 on dr2.Code = sac.ActivityType
			
			where		isnull(dr2.Description,'') like '%mock%'
			and 		(   isnull(dr1.Description,'') not in ('Not Started', 'Partially Completed') 
						 or isnull(dr1.Description,'') like '%DNA%' COLLATE SQL_Latin1_General_CP1_CS_AS	-- Case-sensitive match
						 )
			group by	lca.CaseHash)						c11 on c11.CaseHash = tmp.CaseHashBin
where		tmp.ProgrammeName = 'WHP London'
and 		tmp.StartDate is not null;

set @LoadStartMessage = concat('London CSS 11 Time Taken = ',(select cast((getdate()-@LoadStartTime) as time(0)) '[hh:mm:ss]'))
raiserror(@LoadStartMessage, 0, 1) with nowait;
set @LoadStartTime = getdate();

--------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------
-- London WHP CSS12 Rules ------------------------------------------------------------
--------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------

insert into	DV.SAT_WorkFlowEvents_Meta_Core_New
			(CaseHashBin
			,CaseHash
			,EmployeeHashBin
			,EmployeeHash
			,AssignmentHashIfNeeded
			,WorkFlowEventDate
			,WorkFlowEventEstimatedStartDate
			,WorkFlowEventEstimatedEndDate
			,InOutWork
			,CSSName
			,RecordSource)
select		tmp.CaseHashBin									as CaseHashBin
			,tmp.CaseHash									as CaseHash
			,null											as EmployeeHashBin
			,null											as EmployeeHash
			,null											as AssignmentHashIfNeeded
			,cast(c12.BarrierEndDate as date)				as WorkFlowEventDate
			,tmp.StartDate									as WorkFlowEventEstimatedStartDate 
			,dateadd(dd, -1, tmp.ProjectedLeaveDate)		as WorkFlowEventEstimatedEndDate
			,tmp.InOutWork									as InOutWork
			,'WHP London  -  CSS12'							as CSSName
			,tmp.RecordSource								as RecordSource
from		stg.Meta_WorkflowEventsStaging					tmp
left join	(select		cba.CaseHash						as CaseHash
					   ,min(bac.BarrierEndDate)				as BarrierEndDate
			from		DV.LINK_Case_Barriers				cba 
			join		DV.SAT_Barriers_Adapt_Core			bac on bac.BarriersHash = cba.BarriersHash and bac.IsCurrent = 1
			join		DV.SAT_References_MDMultiNames		mu1 on mu1.ID = bac.BarrierName and mu1.Type = 'Code'
			where		bac.BarrierEndDate is not null
			and 		coalesce(nullif(mu1.Name,''),nullif(mu1.Description,''),'Unknown') in ('Skills training', 'Basic Skills', 'Confidence', 'Employability Support', 'Health and Safety at work', 'Health Management')	
			group by	cba.CaseHash)						c12 on c12.CaseHash = tmp.CaseHashBin
where		tmp.ProgrammeName = 'WHP London'
and 		tmp.StartDate is not null;


set @LoadStartMessage = concat('London CSS 12 Time Taken = ',(select cast((getdate()-@LoadStartTime) as time(0)) '[hh:mm:ss]'))
raiserror(@LoadStartMessage, 0, 1) with nowait;
set @LoadStartTime = getdate();

--------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------
-- London WHP CSS14 Rules ------------------------------------------------------------
--------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------

insert into	DV.SAT_WorkFlowEvents_Meta_Core_New
			(CaseHashBin
			,CaseHash
			,EmployeeHashBin
			,EmployeeHash
			,AssignmentHashIfNeeded
			,WorkFlowEventDate
			,WorkFlowEventEstimatedStartDate
			,WorkFlowEventEstimatedEndDate
			,InOutWork
			,CSSName
			,RecordSource)
select		tmp.CaseHashBin									as CaseHashBin
			,tmp.CaseHash									as CaseHash
			,null											as EmployeeHashBin
			,null											as EmployeeHash
			,null											as AssignmentHashIfNeeded
			,c14.ActivityCompleteDate						as WorkFlowEventDate
			,tmp.StartDate									as WorkFlowEventEstimatedStartDate 
			,tmp.ProjectedLeaveDate							as WorkFlowEventEstimatedEndDate
			,tmp.InOutWork									as InOutWork
			,'WHP London  -  CSS14'							as CSSName
			,tmp.RecordSource								as RecordSource
from		stg.Meta_WorkflowEventsStaging					tmp
left join	(select		lca.CaseHash						as CaseHash
						,min(sac.ActivityCompleteDate)		as ActivityCompleteDate
			from		DV.LINK_Case_Activity				lca
			join		DV.SAT_Activity_Adapt_Core			sac on sac.ActivityHash = lca.ActivityHash		and sac.IsCurrent = 1	
			join 		DV.Dimension_References 			dr1 on dr1.Code = sac.ActivityStatus
			where		dr1.Description not in ('Not Started', 'Partially Completed') 
			and			sac.ActivityNeoType != 0
			group by	lca.CaseHash)						c14 on c14.CaseHash = tmp.CaseHashBin
where		tmp.ProgrammeName = 'WHP London'
and 		tmp.StartDate is not null;

set @LoadStartMessage = concat('London CSS 14 Time Taken = ',(select cast((getdate()-@LoadStartTime) as time(0)) '[hh:mm:ss]'))
raiserror(@LoadStartMessage, 0, 1) with nowait;
set @LoadStartTime = getdate();

--------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------
-- London WHP CSS15 Rules ------------------------------------------------------------
--------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------

insert into	DV.SAT_WorkFlowEvents_Meta_Core_New
			(CaseHashBin
			,CaseHash
			,EmployeeHashBin
			,EmployeeHash
			,AssignmentHashIfNeeded
			,WorkFlowEventDate
			,WorkFlowEventEstimatedStartDate
			,WorkFlowEventEstimatedEndDate
			,InOutWork
			,CSSName
			,RecordSource)
select		tmp.CaseHashBin									as CaseHashBin
			,tmp.CaseHash									as CaseHash
			,null											as EmployeeHashBin
			,null											as EmployeeHash
			,null											as AssignmentHashIfNeeded
			,c15.ActivityCompleteDate						as WorkFlowEventDate
			,tmp.FirstJobStartDate							as WorkFlowEventEstimatedStartDate 
			,(select	max(gdt.[Date])	as [Date]
			 from		(select top (select					wfc.WorkFlowEventSLADuration *1
									 from					META.SAT_WorkFlowEventType_Core wfc
									 where					wfc.WorkFlowEventProgramme = 'WHP London'
									 and					wfc.WorkFlowEventCSSRelated = 'CSS15')	ddd.[Date]
						 from		DW.d_date ddd
						 where		ddd.[Date] > tmp.FirstJobStartDate
						 and		ddd.is_business_day = 1
						 order by	ddd.[Date]) gdt)		as WorkFlowEventEstimatedEndDate		 
			,tmp.InOutWork									as InOutWork
			,'WHP London  -  CSS15'							as CSSName
			,tmp.RecordSource								as RecordSource
from stg.Meta_WorkflowEventsStaging							tmp
left join
(
		select		 lca.CaseHash							as CaseHash
					,min(sac.ActivityCompleteDate)			as ActivityCompleteDate
		from		DV.LINK_Case_Activity					lca
		join		DV.SAT_Activity_Adapt_Core				sac on  sac.ActivityHash = lca.ActivityHash		and sac.IsCurrent = 1
		left join	DV.Dimension_References					dr1 on  dr1.Code = sac.ActivityType
		left join	DV.Dimension_References					dr2 on  dr2.Code = sac.ActivityStatus
		where		dr1.Description = 'Transition to Work Review' 
		and 		(dr2.Description is null or (isnull(dr2.Description,'') != 'Cancelled' and isnull(dr2.Description,'') not like '%DNA%' COLLATE SQL_Latin1_General_CP1_CS_AS))	-- Case-sensitive match		
		group by 	lca.CaseHash
) c15														on c15.CaseHash = tmp.CaseHashBin
where tmp.FirstJobStartDate is not null
  and tmp.ProgrammeName = 'WHP London';

set @LoadStartMessage = concat('London CSS 15 Time Taken = ',(select cast((getdate()-@LoadStartTime) as time(0)) '[hh:mm:ss]'))
raiserror(@LoadStartMessage, 0, 1) with nowait;
set @LoadStartTime = getdate();


--------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------
-- London WHP CSS16 Rules ------------------------------------------------------------
--------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------

select		@SLADuration =	wfc.WorkFlowEventSLADuration *1
from		META.SAT_WorkFlowEventType_Core wfc
where		wfc.WorkFlowEventProgramme = 'WHP London'
and			wfc.WorkFlowEventCSSRelated = 'CSS16';

with BarrierStartEndDates as (
select distinct	tmp.CaseHashBin								as CaseHashBin
			,tmp.CaseHash									as CaseHash
			,sac.AssignmentHash								as AssignmentHash
			,'Barrier End Date'								as ActivityName
			,cast(bac.BarrierEndDate as date)				as ActivityDate
			,case when bac.BarrierStartDate > sac.AssignmentStartDate
				  then cast(bac.BarrierStartDate as date)				
				  else cast(sac.AssignmentStartDate as date)	
			end												as BarrierStartDate 
			,dateadd(day,639
					,cast(sac.AssignmentStartDate as date)) as StartDate639
			,case	when isnull(sac.AssignmentLeaveDate, getdate()) > tmp.LeaveDate
					then tmp.LeaveDate
					else sac.AssignmentLeaveDate				
			 end											as JobLeaveDate					
			,tmp.RecordSource								as RecordSource
from		stg.Meta_WorkflowEventsStaging					tmp
join		DV.LINK_Case_Assignment							lca on lca.CaseHash			= tmp.CaseHashBin
join		DV.SAT_Assignment_Adapt_Core					sac on sac.AssignmentHash	= lca.AssignmentHash and sac.IsCurrent = 1
join		DV.LINK_Case_Barriers							cba on cba.CaseHash			= tmp.CaseHashBin  
join		DV.SAT_Barriers_Adapt_Core						bac on bac.BarriersHash 	= cba.BarriersHash and bac.IsCurrent = 1
join		DV.SAT_References_MDMultiNames					mu1 on mu1.ID = bac.BarrierName and mu1.Type = 'Code'
where		tmp.ProgrammeName = 'WHP London'	
and 		tmp.LeaveDate is null
and			sac.AssignmentStartDate is not null
and         sac.AssignmentStartDate < '2999-12-31'
and 		bac.BarrierEndDate > sac.AssignmentStartDate -- Only pick barriers which continue until after the job has started
and 		((coalesce(nullif(mu1.Name,''),nullif(mu1.Description,''),'Unknown') like '%Disengage%')				
			  or (coalesce(nullif(mu1.Name,''),nullif(mu1.Description,''),'Unknown') like '%suspend engagement%'))
)
,JobStartDate as (
-- Get job verified date for each assignment as the start date
select		tmp.CaseHashBin									as CaseHashBin
			,tmp.CaseHash									as CaseHash
			,sac.AssignmentHash								as AssignmentHash
			,'Job Start Date'								as ActivityName
			,sac.AssignmentStartDate						as ActivityDate
			,dateadd(day,639
					,cast(sac.AssignmentStartDate as date)) as ActivityDate639
			,case	when isnull(sac.AssignmentLeaveDate, getdate()) > tmp.LeaveDate
					then tmp.LeaveDate
					else sac.AssignmentLeaveDate				
			 end											as JobLeaveDate
			,null											as BarrierStartDate
			,tmp.RecordSource								as RecordSource
from		stg.Meta_WorkflowEventsStaging					tmp
join		DV.LINK_Case_Assignment							lca on lca.CaseHash			= tmp.CaseHashBin
join		DV.SAT_Assignment_Adapt_Core					sac on sac.AssignmentHash	= lca.AssignmentHash and sac.IsCurrent = 1
where		tmp.ProgrammeName = 'WHP London'	
and 		tmp.LeaveDate is null
and			sac.AssignmentStartDate is not null
and         sac.AssignmentStartDate < '2999-12-31'
union
-- If a participant has completed the disengagement barrier, then we need to exclude the periods when disengagement barrier was effective
-- So BarrierEndDate needs to be included as the start date, because date ranges need to be generated again after that date
-- Self-join is done because barrier start and end dates can overlap
select		a.CaseHashBin									as CaseHashBin
			,a.CaseHash										as CaseHash
			,a.AssignmentHash								as AssignmentHash
			,a.ActivityName									as ActivityName
			,isnull(b.ActivityDate, a.ActivityDate)			as ActivityDate
			,null											as ActivityDate639
			,null											as JobLeaveDate
			, min(isnull(case when b.BarrierStartDate > a.BarrierStartDate 
							  then a.BarrierStartDate 
							  else b.BarrierStartDate 
						 end, a.BarrierStartDate))			as BarrierStartDate
			,a.RecordSource									as RecordSource
from BarrierStartEndDates									a
left join BarrierStartEndDates								b on  a.AssignmentHash = b.AssignmentHash
															  and a.ActivityDate   > b.BarrierStartDate 
															  and a.ActivityDate   < b.ActivityDate
-- Only include as start date if the barrier ended before the exit date (because if the barrier continued until the exit date then we do not need to start re-generating periods after the barrier ended)															  
where 	 a.ActivityDate < isnull(a.JobLeaveDate, a.StartDate639)																  
group by a.CaseHashBin, a.CaseHash, a.AssignmentHash, a.ActivityName, isnull(b.ActivityDate, a.ActivityDate), a.RecordSource
)
,JobExitDate as (
-- Get job leave date for each assignment as the final exit date
select		jsd.CaseHashBin									as CaseHashBin
			,jsd.CaseHash									as CaseHash
			,jsd.AssignmentHash								as AssignmentHash
			,'Job Exit Date'								as ActivityName
			,jsd.JobLeaveDate								as ActivityDate
			,jsd.RecordSource								as RecordSource
from		JobStartDate									jsd
where		jsd.JobLeaveDate is not null
union
-- If a participant has completed the disengagement barrier, then we need to exclude the periods when disengagement barrier was effective
-- So BarrierStartDate needs to be included as an exit date
select		jsd.CaseHashBin									as CaseHashBin
			,jsd.CaseHash									as CaseHash
			,jsd.AssignmentHash								as AssignmentHash
			,'Barrier Start Date'							as ActivityName
			,jsd.BarrierStartDate							as ActivityDate 
			,jsd.RecordSource								as RecordSource
from		JobStartDate									jsd
where		jsd.ActivityName = 'Barrier End Date'
and 		jsd.BarrierStartDate is not null
) 
,GetWorkflowActivity as (	-- Get start date, exit date, and all activities for a case
select		jsd.CaseHashBin									as CaseHashBin
			,jsd.CaseHash									as CaseHash
			,jsd.AssignmentHash								as AssignmentHash
			,jsd.ActivityName								as ActivityName
			,jsd.ActivityDate								as ActivityCompleteDate
			,jsd.RecordSource								as RecordSource
from		JobStartDate									jsd
join		JobStartDate									jsd1 on jsd.AssignmentHash = jsd1.AssignmentHash and jsd1.ActivityName = 'Job Start Date'
left join	JobExitDate										jed	 on jed.AssignmentHash = jsd.AssignmentHash	 and jed.ActivityName  = 'Exit Activity'	-- Get exit activity date
where		jsd.ActivityDate <= isnull(jed.ActivityDate, 
										case	when dateadd(day, 639, jsd1.ActivityDate) > getdate()
												then getdate()
												else dateadd(day, 639, jsd1.ActivityDate) 
										end)
-- If JobStartDate falls between a disengagement barrier, then exclude it
and	not exists ( 
				select bse.CaseHash
				from   BarrierStartEndDates 				bse
				where  jsd.AssignmentHash = bse.AssignmentHash
				and    jsd.ActivityName   = 'Job Start Date'
				and    jsd.ActivityDate between bse.BarrierStartDate and bse.ActivityDate)
union
select		distinct 
			jsd.CaseHashBin									as CaseHashBin
			,jsd.CaseHash									as CaseHash
			,jsd.AssignmentHash								as AssignmentHash
			,'Has Activity'									as ActivityName
			,cast(sac.ActivityCompleteDate as date)			as ActivityCompleteDate
			,jsd.RecordSource								as RecordSource
from		JobStartDate									jsd
join		DV.LINK_case_Activity							lca on lca.CaseHash		= jsd.CaseHashBin
join		DV.SAT_Activity_Adapt_Core						sac on sac.ActivityHash = lca.ActivityHash		and sac.IsCurrent = 1
join		DV.Dimension_References							dr1 on dr1.Code = sac.ActivityType
left join	JobExitDate										jed	on jed.AssignmentHash = jsd.AssignmentHash 	and	jed.ActivityName = 'Job Exit Date'	-- To get job leave date as the final exit date
where		sac.ActivityCompleteDate >= isnull(jsd.ActivityDate, '1900-01-01')	-- Activity is between start and exit dates
and			sac.ActivityCompleteDate <= isnull(jed.ActivityDate, 
											case	when ActivityDate639 > getdate()
													then getdate()
													else ActivityDate639 
											end) 
and 		dr1.Description like '%in work support%'
and			jsd.ActivityName = 'Job Start Date'
-- Do not pick up activities which occurred while the participant was disengaged
and not exists (select		dis.CaseHash
				from		JobStartDate					dis
				where		dis.AssignmentHash = jsd.AssignmentHash
				and			sac.ActivityCompleteDate between dis.BarrierStartDate and dis.ActivityDate)		
union
-- Get exit date for a case
select		jed.CaseHashBin									as CaseHashBin
			,jed.CaseHash									as CaseHash
			,jed.AssignmentHash								as AssignmentHash
			,jed.ActivityName								as ActivityName
			,jed.ActivityDate								as ActivityCompleteDate 
			,jed.RecordSource								as RecordSource
from		JobExitDate										jed
union	-- For cases where there is no exit date, use start date + 639 days and put ActivityName as 'Missing Exit'
		-- If start date + 639 days is in future or if there is no start date, use today's date as exit date
select		jsd.CaseHashBin									as CaseHashBin
			,jsd.CaseHash									as CaseHash
			,jsd.AssignmentHash								as AssignmentHash
			,'Missing Exit'									as ActivityName
			,case	when ActivityDate639 > getdate()
					then getdate()
					else ActivityDate639
			 end											as ActivityCompleteDate 
			,jsd.RecordSource								as RecordSource
from		JobStartDate									jsd
where		-- Exclude cases where there is an exit date
not exists	(select		jed.CaseHash
			from		JobExitDate							jed
			where		jed.AssignmentHash = jsd.AssignmentHash
			and 		jed.ActivityName = 'Job Exit Date')
and			jsd.ActivityName = 'Job Start Date'
)
,CSS16_Base	as (
-- If there are multiple activities within the due date range, only select the first activity
select grp.CaseHashBin, grp.CaseHash, grp.AssignmentHash, grp.ActivityName, grp.ActivityDate, grp.NextActivityDueDate, min(grp.NextActivityDateWithinDueDate) as NextActivityDateWithinDueDate, max(grp.NextActivityDateAfterDueDate) as NextActivityDateAfterDueDate, grp.NextActivityNameAfterDueDate, grp.RecordSource
from
(
	select		wf1.CaseHashBin									as CaseHashBin
				,wf1.CaseHash									as CaseHash
				,wf1.AssignmentHash								as AssignmentHash
				,wf1.ActivityName								as ActivityName
				,wf1.ActivityCompleteDate						as ActivityDate
				,dateadd(dd, @SLADuration
						   , wf1.ActivityCompleteDate)			as NextActivityDueDate
				,wf2.ActivityCompleteDate						as NextActivityDateWithinDueDate 
				-- Following two columns are used in the next CTE to generate records when there are missed 'in work support action plan' activities 
				,case	when wf2.ActivityCompleteDate is null 
						then lead(wf1.ActivityCompleteDate, 1) over (partition by wf1.AssignmentHash order by wf1.ActivityCompleteDate asc, wf1.ActivityName desc) 
						else null
				 end											as NextActivityDateAfterDueDate		-- If there is no activity within the current due date range, get activity date for the next earliest activity (whenever it took place)
				, case 	when wf2.ActivityCompleteDate is null 
						then lead(wf1.ActivityName, 1) over (partition by wf1.AssignmentHash order by wf1.ActivityCompleteDate asc, wf1.ActivityName desc) 
						else null
				 end											as NextActivityNameAfterDueDate		-- If there is no activity within the current due date range, get activity name for the next earliest activity (whenever it took place)
				,wf1.RecordSource								as RecordSource
	from		GetWorkflowActivity								wf1
	left join	GetWorkflowActivity								wf2 on wf2.AssignmentHash = wf1.AssignmentHash	-- Get next activity which is within the current due date range
																and wf2.ActivityCompleteDate between 
																	case when wf1.ActivityName in ('Job Start Date', 'Barrier End Date') 
																		 then wf1.ActivityCompleteDate 
																		 else dateadd(dd, 1, wf1.ActivityCompleteDate) 
																	end 
																	and dateadd(dd, @SLADuration, wf1.ActivityCompleteDate) 
																and wf2.ActivityName = 'Has Activity'
) grp
where grp.NextActivityNameAfterDueDate is null
	-- Exlude records where either the current activity is 'Barrier Start Date' or 
	-- if participant has gone Disengaged before next activity due date
   or (grp.ActivityName != 'Barrier Start Date' and grp.NextActivityNameAfterDueDate != 'Barrier Start Date') 
   or (grp.NextActivityNameAfterDueDate = 'Barrier Start Date' and grp.NextActivityDateAfterDueDate > grp.NextActivityDueDate)
group by grp.CaseHashBin, grp.CaseHash, grp.AssignmentHash, grp.ActivityName, grp.ActivityDate, grp.NextActivityDueDate, grp.NextActivityNameAfterDueDate, grp.RecordSource					
)
,CSS16_Complete as (
select	  	 c16b.CaseHashBin
			,c16b.CaseHash
			,c16b.AssignmentHash
			,c16b.ActivityName
			,c16b.ActivityDate
			,c16b.NextActivityDueDate
			,c16b.NextActivityDateWithinDueDate
			,c16b.NextActivityDateAfterDueDate
			,c16b.NextActivityNameAfterDueDate
			,c16b.RecordSource
from		CSS16_Base										c16b
where		c16b.ActivityName not in ('Job Exit Date', 'Missing Exit', 'Barrier Start Date') 	-- Exit date line gets generated in the below union
union all
-- Fill gaps between missing 'in work support action plan' activities
select		 c16b.CaseHashBin
			,c16b.CaseHash
			,c16b.AssignmentHash
			,c16b.NextActivityNameAfterDueDate				as ActivityName
			,null											as ActivityDate
 			,ddd.DATE										as NextActivityDueDate
			,case	when	ddd.DATE >= c16b.NextActivityDateAfterDueDate 			-- If the generated missing due date is after next earliest activity then use date for the next earliest activity as NextActivityDateWithinDueDate
							and c16b.NextActivityNameAfterDueDate not in ('Job Exit Date', 'Missing Exit')	-- however if the next earliest activity is the 'Exit Date' then that means there was no next earliest activity and it should be null
					then	c16b.NextActivityDateAfterDueDate
					else	null										
			end												as NextActivityDateWithinDueDate
			,null											as NextActivityDateAfterDueDate
			,null											as NextActivityNameAfterDueDate
			,c16b.RecordSource								as RecordSource
from		CSS16_Base										c16b
-- Get dates in @SLADuration day intervals from due date until the date of next earliest activity + @SLADuration days
join		dw.d_date										ddd on ddd.DATE > c16b.NextActivityDueDate 
																and ddd.DATE < dateadd(day, @SLADuration, c16b.NextActivityDateAfterDueDate) 
																-- Calculates difference in days between each date and the due date, divides it by @SLADuration and checks if the remainder is 0. This ensures we get dates in @SLADuration days intervals only.
																and datediff(day, ddd.DATE, c16b.NextActivityDueDate) % @SLADuration = 0 
where		c16b.NextActivityDateWithinDueDate is null		-- Identifies records where 'in work support action plan' activity hasn't taken place when it was due as we only need to generate missing gaps for these ones
and			(    c16b.NextActivityNameAfterDueDate is null 
			-- Since Disengaged needs to be excluded, so the missing records need to be generated up until just prior to the 'Barrier Start Date'
			or c16b.NextActivityNameAfterDueDate != 'Barrier Start Date'
			or (c16b.NextActivityNameAfterDueDate = 'Barrier Start Date' and ddd.DATE < c16b.NextActivityDateAfterDueDate )) 
and			c16b.ActivityName not in ('Job Exit Date', 'Missing Exit') 	-- Exit date should not be marked as compliant
)
insert into	DV.SAT_WorkFlowEvents_Meta_Core_New
			(CaseHashBin
			,CaseHash
			,EmployeeHashBin
			,EmployeeHash
			,AssignmentHashIfNeeded
			,WorkFlowEventDate
			,WorkFlowEventEstimatedStartDate
			,WorkFlowEventEstimatedEndDate
			,InOutWork
			,CSSName
			,RecordSource)
select		cs16.CaseHashBin								as CaseHashBin
			,cs16.CaseHash									as CaseHash
			,null											as EmployeeHashBin
			,null											as EmployeeHash
			,AssignmentHash									as AssignmentHashIfNeeded
			,cs16.NextActivityDateWithinDueDate				as WorkFlowEventDate
			-- For WorkFlowEventEstimatedStartDate, get previous WorkFlowEventDate. If null then get previous WorkFlowEventEstimatedEndDate. When there is no previous record get the first activity date (usually will be the start date)
			,case when cs16.ActivityName in ('Job Start Date', 'Barrier End Date') then cs16.ActivityDate
				  else coalesce(lag(cs16.NextActivityDateWithinDueDate, 1) over (partition by cs16.AssignmentHash order by cs16.NextActivityDueDate, isnull(cs16.NextActivityDateWithinDueDate, cs16.NextActivityDateAfterDueDate))
							   ,lag(cs16.NextActivityDueDate, 1) over (partition by cs16.AssignmentHash order by cs16.NextActivityDueDate, isnull(cs16.NextActivityDateWithinDueDate, cs16.NextActivityDateAfterDueDate)))
			 end 											as WorkFlowEventEstimatedStartDate
			,cs16.NextActivityDueDate						as WorkFlowEventEstimatedEndDate 
			,null											as InOutWork
			,'WHP London  -  CSS16'							as CSSName
			,cs16.RecordSource								as RecordSource
from		CSS16_Complete									cs16;


set @LoadStartMessage = concat('London CSS 16 Time Taken = ',(select cast((getdate()-@LoadStartTime) as time(0)) '[hh:mm:ss]'))
raiserror(@LoadStartMessage, 0, 1) with nowait;
set @LoadStartTime = getdate();


--------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------
-- London WHP CSS17 Rules -------------------------------------------------------------
--------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------

with cte as (
select 
	tmp.CaseHashBin
	,tmp.CaseHash
	,H1.AnswerDate StartAnswerDate
	,H1.Total StartTotal
	,H2.AnswerDate LeaveAnswerDate
	,H2.Total LeaveTotal
	,row_number() over (partition by tmp.CaseHash order by h1.AnswerDate asc) rn1
	,row_number() over (partition by tmp.CaseHash order by h2.AnswerDate desc) rn2
from stg.Meta_WorkflowEventsStaging					tmp
left join DV.LINK_Case_OutcomeScore					lco on tmp.CaseHashBin = lco.CaseHash
left join (select OutcomeScoreHash,AnswerDate,Total from DV.SAT_OutcomeScore_Adapt_Core where IsCurrent = 1) h1 ON H1.OutcomeScoreHash = lco.OutcomeScoreHash AND h1.AnswerDate >= tmp.StartDate
left join (select OutcomeScoreHash,AnswerDate,Total from DV.SAT_OutcomeScore_Adapt_Core where IsCurrent = 1) h2 ON H2.OutcomeScoreHash = lco.OutcomeScoreHash AND H2.AnswerDate < tmp.LeaveDate
where tmp.ProgrammeName = 'WHP London'
)
insert into	DV.SAT_WorkFlowEvents_Meta_Core_New
			(CaseHashBin
			,CaseHash
			,EmployeeHashBin
			,EmployeeHash
			,WorkFlowEventDate
			,WorkFlowEventEstimatedStartDate
			,WorkFlowEventEstimatedEndDate
			,InOutWork
			,CSSName
			,RecordSource)
select		tmp.CaseHashBin									as CaseHashBin
			,tmp.CaseHash									as CaseHash
			,null											as EmployeeHashBin
			,null											as EmployeeHash
			,s1.Compliant									as WorkFlowEventDate
			,tmp.StartDate									as WorkFlowEventEstimatedStartDate 
			,case when tmp.FirstJobStartDate is null 
				  then dateadd(mm, 15, tmp.StartDate)
				  when tmp.InOutWork = 'Employed'
				  then dateadd(mm, 21, tmp.StartDate)
			 end											as WorkFlowEventEstimatedEndDate
			,tmp.InOutWork									as InOutWork
			,'WHP London  -  CSS17'							as CSSName
			,tmp.RecordSource								as RecordSource
from		stg.Meta_WorkflowEventsStaging					tmp
left join	
(
	select	s1.CaseHashBin
			,s1.CaseHash
			,s1.StartAnswerDate
			,s1.StartTotal
			,s2.LeaveAnswerDate
			,s2.LeaveTotal
			,case when s2.LeaveTotal > s1.StartTotal 
				then s2.LeaveAnswerDate
			end as Compliant
	from		cte s1
	left join	cte s2 on s1.CaseHash = s2.CaseHash and s2.rn2 = 1
	where	s1.rn1 = 1
)															s1 on s1.CaseHashBin = tmp.CaseHashBin
-- Exclude cases which falls under scenario 3 (Enhancement 22970)
left join
(
	select b.CaseHashBin
	from 
	(
			select		tmp.CaseHashBin						as CaseHashBin
						,tmp.CaseHash						as CaseHash
						,tmp.RecordSource					as RecordSource
						,max(case when sac.AssignmentLeaveDate >= tmp.StartDate and sac.AssignmentLeaveDate < dateadd(mm, 15, tmp.StartDate)
								  then 1
								  else 0
						 end)								as OutOfWorkBetween0to15
						,max(case when sac.AssignmentLeaveDate >= dateadd(mm, 15, tmp.StartDate) and sac.AssignmentLeaveDate < dateadd(mm, 21, tmp.StartDate)
								  then 1
								  else 0
						 end)								as OutOfWorkBetween16to21
						,max(case when sac.AssignmentStartDate >= dateadd(mm, 15, tmp.StartDate) and sac.AssignmentLeaveDate is null
								  then 1
								  else 0
						 end)								as DueToStartBetween16to21
			from		stg.Meta_WorkflowEventsStaging		tmp
			join		DV.LINK_Case_Assignment				lca on lca.CaseHash			= tmp.CaseHashBin
			join		DV.SAT_Assignment_Adapt_Core		sac on sac.AssignmentHash	= lca.AssignmentHash and sac.IsCurrent = 1
			where		tmp.ProgrammeName = 'WHP London'	
			and			tmp.StartDate is not null
			and			tmp.LeaveDate is not null
			group by	tmp.CaseHashBin, tmp.CaseHash, tmp.RecordSource 
	) b
	where OutOfWorkBetween0to15 = 1 and OutOfWorkBetween16to21 = 1 and DueToStartBetween16to21 = 0
)															exc	on exc.CaseHashBin		= tmp.CaseHashBin
where 		tmp.ProgrammeName = 'WHP London'
and			tmp.StartDate is not null
and			tmp.LeaveDate is not null
and			exc.CaseHashBin is null;

set @LoadStartMessage = concat('London CSS 17 Time Taken = ',(select cast((getdate()-@LoadStartTime) as time(0)) '[hh:mm:ss]'))
raiserror(@LoadStartMessage, 0, 1) with nowait;
set @LoadStartTime = getdate();