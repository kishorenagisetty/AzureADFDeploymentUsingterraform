CREATE PROC [DW].[CSSEventLoad_WalesCSS] AS

declare		@SLADuration int;
declare		@LoadStartTime as datetime;
declare		@LoadStartMessage as varchar(100);
set			@LoadStartTime = getdate();

delete 
from		DV.SAT_WorkFlowEvents_Meta_Core_New 
where		CSSName like '%WHP Wales%';

--------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------
-- Wales WHP CSS1 Rules --------------------------------------------------------------
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
			,cs1.WorkFlowEventDate							as WorkFlowEventDate
			,tmp.ReferralDate								as WorkFlowEventEstimatedStartDate 
			,(select	max(gdt.[Date])	as [Date]
			 from		(select top (select			wfc.WorkFlowEventSLADuration *1
									 from			META.SAT_WorkFlowEventType_Core wfc
									 where			wfc.WorkFlowEventProgramme = 'WHP Wales'
									 and			wfc.WorkFlowEventCSSRelated = 'CSS1')	ddd.[Date]
						 from		DW.d_date ddd
						 where		ddd.[Date] > tmp.ReferralDate
						 and		ddd.is_business_day = 1
						 order by	ddd.[Date]) gdt)		as WorkFlowEventEstimatedEndDate
			,tmp.InOutWork									as InOutWork
			,'WHP Wales  -  CSS1'							as CSSName
			,tmp.RecordSource								as RecordSource
from		stg.Meta_WorkflowEventsStaging					tmp
left join	(select		convert(char(66),isnull(lca.CaseHash ,cast(0x0 as binary(32))),1)	as CaseHash
						,min(sac.ActivityCompleteDate)										as WorkFlowEventDate
			from		DV.LINK_Case_Activity				lca
			left join	DV.SAT_Activity_Adapt_Core			sac on sac.ActivityHash = lca.ActivityHash
			left join	DV.Dimension_References				dre on dre.Code = sac.ActivityStatus
			where		cast(sac.ActivityCompleteDate as date) <= cast(getdate() as date)
			and not		dre.Description in ('Not Started','Partially Completed')
			and			sac.ActivityRelatedSupportNeed = 'Initial Appointment'
			--and			cast(sac.ActivityCompleteDate as date) >= '2020-07-30'
			group by	lca.CaseHash)						cs1 on cs1.CaseHash = tmp.CaseHash
where		tmp.ProgrammeName = 'WHP Wales';													

set @LoadStartMessage = concat('Wales CSS 1 Time Taken = ',(select cast((getdate()-@LoadStartTime) as time(0)) '[hh:mm:ss]'))
raiserror(@LoadStartMessage, 0, 1) with nowait;
set @LoadStartTime = getdate();


--------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------
-- Wales WHP CSS2 Rules --------------------------------------------------------------
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
									 where					wfc.WorkFlowEventProgramme = 'WHP Wales'
									 and					wfc.WorkFlowEventCSSRelated = 'CSS2')	ddd.[Date]
						 from		DW.d_date ddd
						 where		ddd.[Date] > tmp.ReferralDate
						 and		ddd.is_business_day = 1
						 order by	ddd.[Date]) gdt)		as WorkFlowEventEstimatedEndDate
			,tmp.InOutWork									as InOutWork
			,'WHP Wales  -  CSS2'							as CSSName
			,tmp.RecordSource								as RecordSource
from		stg.Meta_WorkflowEventsStaging					tmp
where		tmp.ProgrammeName = 'WHP Wales';		

set @LoadStartMessage = concat('Wales CSS 2 Time Taken = ',(select cast((getdate()-@LoadStartTime) as time(0)) '[hh:mm:ss]'))
raiserror(@LoadStartMessage, 0, 1) with nowait;
set @LoadStartTime = getdate();

--------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------
-- Wales WHP CSS6 Rules --------------------------------------------------------------
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
			,isnull(tmp.BotWelcomePackDate,cs6.SentDate)	as WorkFlowEventDate
			,tmp.StartDate									as WorkFlowEventEstimatedStartDate 
			,(select	max(gdt.[Date])						as [Date]
			 from		(select top (select			top 1 wfc.WorkFlowEventSLADuration *1
									 from			META.SAT_WorkFlowEventType_Core wfc
									 where			wfc.WorkFlowEventProgramme = 'WHP Wales'
									 and			wfc.WorkFlowEventCSSRelated = 'CSS6')	ddd.[Date]
						 from		DW.d_date ddd
						 where		ddd.[Date] > tmp.StartDate
						 and		ddd.is_business_day = 1
						 order by	ddd.[Date]) gdt)		as WorkFlowEventEstimatedEndDate
			,tmp.InOutWork									as InOutWork
			,'WHP Wales  -  CSS6'							as CSSName
			,tmp.RecordSource								as RecordSource
from		stg.Meta_WorkflowEventsStaging					tmp
left join	(select		tmp.CaseHash
						,min(isnull(dac.SentDate,ddu.UploadedDate))	as SentDate
			from		stg.Meta_WorkflowEventsStaging		tmp
			left join	DV.LINK_Case_DocumentUpload			cdu on cdu.CaseHash				= tmp.CaseHashBin		
			left join	DV.SAT_DocumentUpload_Adapt_Core	ddu on ddu.DocumentUploadHash	= cdu.DocumentUploadHash	and isnull(ddu.DocumentName,'') like '%Welcome%Pack%'
			left join	DV.LINK_Case_Document				doc on doc.CaseHash				= tmp.CaseHashBin
			left join	DV.SAT_Document_Adapt_Core			dac ON dac.DocumentHash			= doc.DocumentHash			and isnull(dac.DocumentName,'') LIKE '%welcome%pack%'
			where		isnull(ddu.DocumentName,'') like '%Welcome%Pack%'
			group by	tmp.CaseHash)						cs6 on cs6.CaseHash = tmp.CaseHash
where		tmp.ProgrammeName = 'WHP Wales';						

set @LoadStartMessage = concat('Wales CSS 6 Time Taken = ',(select cast((getdate()-@LoadStartTime) as time(0)) '[hh:mm:ss]'))
raiserror(@LoadStartMessage, 0, 1) with nowait;
set @LoadStartTime = getdate();

--------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------
-- Wales WHP CSS7 Rules --------------------------------------------------------------
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
			,cs7.DocUploadedDate							as WorkFlowEventDate
			,tmp.ReferralDate								as WorkFlowEventEstimatedStartDate 
			,(select	max(gdt.[Date])	as [Date]
			 from		(select top (select					wfc.WorkFlowEventSLADuration *1
									 from					META.SAT_WorkFlowEventType_Core wfc
									 where					wfc.WorkFlowEventProgramme = 'WHP Wales'
									 and					wfc.WorkFlowEventCSSRelated = 'CSS7')	ddd.[Date]
						 from		DW.d_date ddd
						 where		ddd.[Date] > tmp.ReferralDate
						 and		ddd.is_business_day = 1
						 order by	ddd.[Date]) gdt)		as WorkFlowEventEstimatedEndDate
			,tmp.InOutWork									as InOutWork
			,'WHP Wales  -  CSS7'							as CSSName
			,tmp.RecordSource								as RecordSource
from		stg.Meta_WorkflowEventsStaging					tmp
left join	(select		tmp.CaseHash
						,min(ddu.UploadedDate)				as DocUploadedDate
			from		stg.Meta_WorkflowEventsStaging		tmp
			left join	DV.LINK_Case_DocumentUpload			cdu on cdu.CaseHash = tmp.CaseHashBin
			left join	DV.SAT_DocumentUpload_Adapt_Core	ddu on ddu.DocumentUploadHash = cdu.DocumentUploadHash
            where        (isnull(ddu.DocumentName,'')        like '%Action%%Plan%'
            or            isnull(ddu.DocumentName,'')        like '% AP %'
            or            isnull(ddu.DocumentDescription,'') like '%Action%%Plan%'
            or            isnull(ddu.DocumentDescription,'') like '% AP %')
			group by	tmp.CaseHash)						cs7 on cs7.CaseHash = tmp.CaseHash
where		tmp.ProgrammeName = 'WHP Wales';	

set @LoadStartMessage = concat('Wales CSS 7 Time Taken = ',(select cast((getdate()-@LoadStartTime) as time(0)) '[hh:mm:ss]'))
raiserror(@LoadStartMessage, 0, 1) with nowait;
set @LoadStartTime = getdate();


--------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------
-- Wales WHP CSS8 Rules --------------------------------------------------------------
--------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------

select		@SLADuration =	wfc.WorkFlowEventSLADuration *1
from		META.SAT_WorkFlowEventType_Core wfc
where		wfc.WorkFlowEventProgramme = 'WHP Wales'
and			wfc.WorkFlowEventCSSRelated = 'CSS8';
									 
									 
with TailoredEngagement as (
select distinct tmp.CaseHashBin
from		stg.Meta_WorkflowEventsStaging	tmp
join		DV.LINK_Case_Barriers			lcb				on lcb.CaseHash = tmp.CaseHashBin
join		DV.SAT_Barriers_Adapt_Core		bac				on bac.BarriersHash = lcb.BarriersHash and bac.IsCurrent = 1
join		DV.SAT_References_MDMultiNames	mu1				on mu1.ID = bac.BarrierName and mu1.Type = 'Code'
join		DV.SAT_References_MDMultiNames	mu2				on mu2.ID = bac.BarrierStatus and mu2.Type = 'Code'
where		tmp.ProgrammeName = 'WHP Wales'
and			coalesce(nullif(mu1.Name,''),nullif(mu1.Description,''),'Unknown') like '%Tailor%'
and			mu2.Description != 'Complete'
)
,BarrierStartEndDates as (
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
where		tmp.ProgrammeName = 'WHP Wales'	
and			tmp.InOutWork = 'Unemployed'					-- Exclude InWork
and 		tmp.StartDate is not null
and			tmp.LeaveDate is null
and			tmp.CaseHashBin not in (select CaseHashBin from TailoredEngagement) 
and 		bac.BarrierEndDate > tmp.StartDate 				-- Only pick barriers which continue until after the start date
and 		((coalesce(nullif(mu1.Name,''),nullif(mu1.Description,''),'Unknown') like '%Disengage%')				
			  or (coalesce(nullif(mu1.Name,''),nullif(mu1.Description,''),'Unknown') like '%suspend engagement%'))
)
,CaseStartDate as (
-- Get start date for a case
select		tmp.CaseHashBin									as CaseHashBin
			,tmp.CaseHash									as CaseHash
			,'Start Date'									as ActivityName
			,min(tmp.StartDate)								as ActivityDate
			,null											as BarrierStartDate 
			,tmp.RecordSource								as RecordSource
from		stg.Meta_WorkflowEventsStaging					tmp
where		tmp.ProgrammeName = 'WHP Wales'	
and			tmp.InOutWork = 'Unemployed'					-- Exclude InWork
and 		tmp.StartDate is not null
and			tmp.LeaveDate is null
and			tmp.CaseHashBin not in (select CaseHashBin from TailoredEngagement) 
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
-- If a participant has completed the disengagement barrier, then we need to exclude the periods when disengagement barrier was effective
-- So BarrierStartDate needs to be included as an exit date
select		csd.CaseHashBin									as CaseHashBin
			,csd.CaseHash									as CaseHash
			,'Barrier Start Date'							as ActivityName
			,csd.BarrierStartDate							as ActivityCompleteDate 
			,csd.RecordSource								as RecordSource
from		CaseStartDate									csd
where		csd.BarrierStartDate is not null
)
,GetWorkflowActivity as (	-- Get start date, exit date, and all activities for a case
select		csd.CaseHashBin									as CaseHashBin
			,csd.CaseHash									as CaseHash
			,csd.ActivityName								as ActivityName
			,csd.ActivityDate								as ActivityDueDate
			,csd.RecordSource								as RecordSource
from		CaseStartDate									csd
join		CaseStartDate									csd1 on csd.CaseHashBin = csd1.CaseHashBin 		and csd1.ActivityName = 'Start Date'
where		csd.ActivityDate <= case when dateadd(day, 639, csd1.ActivityDate) > getdate()
									 then getdate()
									 else dateadd(day, 639, csd1.ActivityDate) 
								end
union
select		distinct 
			csd.CaseHashBin									as CaseHashBin
			,csd.CaseHash									as CaseHash
			,'Has Activity'									as ActivityName
			,cast(sac.ActivityDueDate as date)				as ActivityDueDate
			,csd.RecordSource								as RecordSource
from		CaseStartDate									csd
join		DV.LINK_case_Activity							lca on lca.CaseHash		= csd.CaseHashBin
join		DV.SAT_Activity_Adapt_Core						sac on sac.ActivityHash = lca.ActivityHash		and sac.IsCurrent = 1
left join 	DV.SAT_References_MDMultiNames					md	on md.id = sac.ActivityStatus				and md.IsCurrent  = 1	
where		sac.ActivityDueDate >= isnull(csd.ActivityDate, '1900-01-01')	-- Activity is between start and exit dates
and			sac.ActivityDueDate <= case	when dateadd(day, 639, csd.ActivityDate) > getdate()
										then getdate()
										else dateadd(day, 639, csd.ActivityDate) 
								   end
and			isnull(md.Description, '') != 'Cancelled'	
and			csd.ActivityName = 'Start Date'							   
-- Do not pick up activities which occurred while the participant was disengaged
and not exists (select		dis.CaseHash
				from		CaseStartDate					dis
				where		dis.CaseHash = csd.CaseHash
				and			sac.ActivityDueDate between dis.BarrierStartDate and dis.ActivityDate)
union
select		distinct 
			csd.CaseHashBin									as CaseHashBin
			,csd.CaseHash									as CaseHash
			,'Has Activity'									as ActivityName
			,cast(sca.CorrespondenceDate as date)			as ActivityDueDate
			,csd.RecordSource								as RecordSource
from		CaseStartDate									csd
left join	DV.LINK_Case_Correspondence						lcc on lcc.CaseHash = csd.CaseHashBin
left join	DV.SAT_Correspondence_Adapt_Core				sca on sca.CorrespondenceHash = lcc.CorrespondenceHash
left join 	DV.SAT_References_MDMultiNames					md	on md.id = sca.CorrespondenceMethod			and md.IsCurrent  = 1
where		isnull(md.Description, '') != 'BOT - FTA'
and			sca.CorrespondenceDate >= isnull(csd.ActivityDate, '1900-01-01') -- Activity is between start and exit dates
and			sca.CorrespondenceDate <= case when dateadd(day, 639, csd.ActivityDate) > getdate()
										   then getdate()
										   else dateadd(day, 639, csd.ActivityDate) 
								   end
and			csd.ActivityName = 'Start Date'
-- Do not pick up activities which occurred while the participant was disengaged
and not exists (select		inw.CaseHash
				from		CaseStartDate					inw
				where		inw.CaseHash = csd.CaseHash
				and			sca.CorrespondenceDate between inw.BarrierStartDate and inw.ActivityDate)
union
-- Get exit date (barrier start date) for a case
select		ced.CaseHashBin									as CaseHashBin
			,ced.CaseHash									as CaseHash
			,ced.ActivityName								as ActivityName
			,ced.ActivityCompleteDate						as ActivityDueDate 
			,ced.RecordSource								as RecordSource
from		CaseExitDate 									ced
union	-- For exit date, use start date + 639 days and put ActivityName as 'Missing Exit'
		-- If start date + 639 days is in future or if there is no start date, use today's date as exit date
select		csd.CaseHashBin									as CaseHashBin
			,csd.CaseHash									as CaseHash
			,'Missing Exit'									as ActivityName
			,case	when dateadd(day, 639, csd.ActivityDate) > getdate()
					then cast(getdate() as date)
					else dateadd(day, 639, csd.ActivityDate) 
			 end											as ActivityDueDate 
			,csd.RecordSource								as RecordSource
from		CaseStartDate									csd
where		csd.ActivityName = 'Start Date'
)
,CSS8_Base	as (
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
			, case 	when wf2.ActivityDueDate is null 
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
																	   and wf2.ActivityName = 'Has Activity'
) grp
where grp.NextActivityNameAfterDueDate is null
	-- Exlude records where either the current activity is 'Barrier Start Date' or 
	-- if participant has gone Disengaged before next activity due date
   or (grp.ActivityName != 'Barrier Start Date' and grp.NextActivityNameAfterDueDate != 'Barrier Start Date') 
   or (grp.NextActivityNameAfterDueDate = 'Barrier Start Date' and grp.NextActivityDateAfterDueDate > grp.NextActivityDueDate)
group by grp.CaseHashBin, grp.CaseHash, grp.ActivityName, grp.ActivityDate, grp.NextActivityDueDate, grp.NextActivityNameAfterDueDate, grp.RecordSource						
)
,CSS8_Complete as (
	select		 c8b.CaseHashBin
				,c8b.CaseHash
				,c8b.ActivityName
				,c8b.ActivityDate
				,c8b.NextActivityDueDate
				,c8b.NextActivityDateWithinDueDate
				,c8b.NextActivityDateAfterDueDate
				,c8b.NextActivityNameAfterDueDate
				,c8b.RecordSource	
	from		CSS8_Base										c8b
	where		c8b.ActivityName not in ('Missing Exit', 'Barrier Start Date') -- Exit date line gets generated in the below union
	union all
	-- Fill gaps between missing appointments
	select		 c8b.CaseHashBin
				,c8b.CaseHash
				,case	when	c8b.Date >= c8b.NextActivityDateAfterDueDate
								and c8b.NextActivityNameAfterDueDate not in ('Missing Exit', 'Has Activity')
						then	c8b.NextActivityNameAfterDueDate			-- If next earliest activity is the final exit activity then use actual exit activity name. This regenerates the exit line which is excluded in above union with correct dates
						else	'Missing Activity'
				 end											as ActivityName
				,null											as ActivityDate
 				,c8b.Date										as NextActivityDueDate
				,case	when	c8b.Date >= c8b.NextActivityDateAfterDueDate 			-- If the generated missing due date is after next earliest activity then use date for the next earliest activity as NextActivityDateWithinDueDate
								and c8b.NextActivityNameAfterDueDate != 'Missing Exit'	-- however if the next earliest activity is 'Missing Exit' then that means there was no next earliest activity and it should be null
						then	c8b.NextActivityDateAfterDueDate
						else	null										
				end												as NextActivityDateWithinDueDate
				, null											as NextActivityDateAfterDueDate
				, null											as NextActivityNameAfterDueDate
				,c8b.RecordSource								as RecordSource				
	from
	(
		select c8b.*, ddd.Date, row_number() over (partition by c8b.CaseHash, c8b.NextActivityDueDate, c8b.NextActivityDateAfterDueDate order by ddd.Date) rn
		from		CSS8_Base										c8b
		-- Get all working days from due date until the due date of next earliest activity
		join		dw.d_date										ddd on ddd.Date > c8b.NextActivityDueDate 
																		and ddd.Date < c8b.NextActivityDueDateAfterCurrentDueDate
																		and ddd.is_business_day = 1															
		where		c8b.NextActivityDateWithinDueDate is null		-- Identifies records where an activity hasn't taken place when it was due as we only need to generate missing gaps for these ones
		and			(    c8b.NextActivityNameAfterDueDate is null 
					-- Since Disengaged needs to be excluded, so the missing records need to be generated up until just prior to the 'Barrier Start Date'
					 or c8b.NextActivityNameAfterDueDate != 'Barrier Start Date'
					 or (c8b.NextActivityNameAfterDueDate = 'Barrier Start Date' and ddd.DATE < c8b.NextActivityDateAfterDueDate )) 
		and			c8b.ActivityName != 'Missing Exit'		-- Exit activity record is not needed because it gets regenerated while generating the missing records within this union
	) c8b where rn % @SLADuration = 0		-- Only pick up every @SLADuration working day
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
select		cs8.CaseHashBin									as CaseHashBin
			,cs8.CaseHash									as CaseHash
			,null											as EmployeeHashBin
			,null											as EmployeeHash
			,null											as AssignmentHashIfNeeded
			,cs8.NextActivityDateWithinDueDate				as WorkFlowEventDate
			-- For WorkFlowEventEstimatedStartDate, get previous WorkFlowEventDate. If null then get previous WorkFlowEventEstimatedEndDate.
			,case when cs8.ActivityName in ('Start Date', 'Barrier End Date') then cs8.ActivityDate
				  else coalesce(lag(cs8.NextActivityDateWithinDueDate, 1) over (partition by cs8.CaseHash order by cs8.NextActivityDueDate, isnull(cs8.NextActivityDateWithinDueDate, cs8.NextActivityDateAfterDueDate))
							   ,lag(cs8.NextActivityDueDate, 1) over (partition by cs8.CaseHash order by cs8.NextActivityDueDate, isnull(cs8.NextActivityDateWithinDueDate, cs8.NextActivityDateAfterDueDate)))			
			 end											as WorkFlowEventEstimatedStartDate
			,cs8.NextActivityDueDate						as WorkFlowEventEstimatedEndDate 
			,null											as InOutWork
			,'WHP Wales  -  CSS8'							as CSSName
			,cs8.RecordSource								as RecordSource
from		CSS8_Complete									cs8;

set @LoadStartMessage = concat('Wales CSS 8 Time Taken = ',(select cast((getdate()-@LoadStartTime) as time(0)) '[hh:mm:ss]'))
raiserror(@LoadStartMessage, 0, 1) with nowait;
set @LoadStartTime = getdate();

--------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------
-- Wales WHP CSS9 Rules --------------------------------------------------------------
--------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------

select		@SLADuration =	wfc.WorkFlowEventSLADuration *1
from		META.SAT_WorkFlowEventType_Core wfc
where		wfc.WorkFlowEventProgramme = 'WHP Wales'
and			wfc.WorkFlowEventCSSRelated = 'CSS9';

set 		@SLADuration = 20; -- Added temporarily because SLADuration in META.SAT_WorkFlowEventType_Core is not correct

with AssignmentLeaveAddedDate as (
----- Audit table date added of the assignment leave date
select      laa.AssignmentHash
			,cast(max(laa.AuditDate) as date)				as JobLeaveAddDate
from        DV.SAT_Assignment_LeaveAudit_Adapt_Core laa
where       laa.IsCurrent = 1
group by    laa.AssignmentHash
)
,AssignmentStartEndDates as (
select		tmp.CaseHashBin									as CaseHashBin
			,tmp.CaseHash									as CaseHash
			,'Assignment Leave Add Date'					as ActivityName
			,lad.JobLeaveAddDate							as ActivityDate
			,cast(sac.AssignmentStartDate as date)			as AssignmentStartDate 
			,tmp.RecordSource								as RecordSource
from		stg.Meta_WorkflowEventsStaging					tmp
join		DV.LINK_Case_Assignment							lca on lca.CaseHash			= tmp.CaseHashBin
join		DV.SAT_Assignment_Adapt_Core					sac on sac.AssignmentHash	= lca.AssignmentHash and sac.IsCurrent = 1
join		AssignmentLeaveAddedDate						lad on lad.AssignmentHash	= lca.AssignmentHash
where		tmp.ProgrammeName = 'WHP Wales'	
and			tmp.InOutWork = 'Unemployed'					-- Exclude InWork
and 		tmp.StartDate is not null 
and 		lad.JobLeaveAddDate > tmp.StartDate 			-- Only pick assignments which continue until after the start date
and			sac.AssignmentStartDate is not null
and			sac.AssignmentLeaveDate <= getdate()
)
,BarrierStartEndDates as (
select distinct tmp.CaseHashBin								as CaseHashBin
			,tmp.CaseHash									as CaseHash
			,'Barrier End Date'								as ActivityName
			,cast(bac.BarrierEndDate as date)				as ActivityDate
			,cast(bac.BarrierStartDate as date)				as BarrierStartDate 
			,tmp.RecordSource								as RecordSource
from		stg.Meta_WorkflowEventsStaging					tmp
join		DV.LINK_Case_Barriers							cba on cba.CaseHash	= tmp.CaseHashBin  
join		DV.SAT_Barriers_Adapt_Core						bac on bac.BarriersHash = cba.BarriersHash and bac.IsCurrent = 1
join		DV.SAT_References_MDMultiNames					mu1 on mu1.ID = bac.BarrierName and mu1.Type = 'Code'
where		tmp.ProgrammeName = 'WHP Wales'	
and			tmp.InOutWork = 'Unemployed'					-- Exclude InWork
and 		tmp.StartDate is not null
and 		bac.BarrierEndDate > tmp.StartDate 				-- Only pick barriers which continue until after the start date
and 		((coalesce(nullif(mu1.Name,''),nullif(mu1.Description,''),'Unknown') like '%Disengage%')				
			  or (coalesce(nullif(mu1.Name,''),nullif(mu1.Description,''),'Unknown') like '%suspend engagement%'))
)
,CaseStartDate as (
-- Get start date for a case
select		tmp.CaseHashBin									as CaseHashBin
			,tmp.CaseHash									as CaseHash
			,'Start Date'									as ActivityName
			,tmp.StartDate									as ActivityDate
			,NULL											as AssignmentOrBarrierStartDate
			,tmp.RecordSource								as RecordSource
from		stg.Meta_WorkflowEventsStaging					tmp
where		tmp.ProgrammeName = 'WHP Wales'	
and			tmp.InOutWork = 'Unemployed'					-- Exclude InWork
and 		tmp.StartDate is not null
union
-- If a participant has started a job and then left it, then we need to exclude that period because InWork is not included 
-- So AssignmentLeaveDate needs to be included as the start date, because date ranges need to be generated again after that date
-- Self-join is done because assignment start and end dates can overlap
select 		a.CaseHashBin									as CaseHashBin
			,a.CaseHash										as CaseHash
			,a.ActivityName									as ActivityName
			,isnull(b.ActivityDate, a.ActivityDate) 		as ActivityDate
			,min(isnull(case when b.AssignmentStartDate > a.AssignmentStartDate 
							 then a.AssignmentStartDate 
							 else b.AssignmentStartDate 
						end, a.AssignmentStartDate))  		as AssignmentOrBarrierStartDate
			,a.RecordSource									as RecordSource
from 		AssignmentStartEndDates							a
left join 	AssignmentStartEndDates							b on  a.CaseHash = b.CaseHash 
															  and a.ActivityDate > b.AssignmentStartDate 
															  and a.ActivityDate < b.ActivityDate 
group by a.CaseHashBin, a.CaseHash, a.ActivityName, isnull(b.ActivityDate, a.ActivityDate), a.RecordSource
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
						 end, a.BarrierStartDate))			as AssignmentOrBarrierStartDate
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
			,cast(sac.ActivityCompleteDate as date)			as ActivityCompleteDate 
			,csd.RecordSource								as RecordSource
from		CaseStartDate									csd
join		DV.LINK_Case_Activity							lca on lca.CaseHash = csd.CaseHashBin
join		DV.SAT_Activity_Adapt_Core						sac on sac.ActivityHash = lca.ActivityHash		and sac.IsCurrent = 1 and sac.ActivityName in ('Exit Interview', 'Exit Review') 
where		csd.AssignmentOrBarrierStartDate is null
and 		sac.ActivityCompleteDate is not null
union
-- We need to exclude following two scenarios:
	-- If a participant has started a job and then left it, then we need to exclude that period because InWork is not included 
	-- If a participant has completed the disengagement barrier, then we need to exclude the periods when disengagement barrier was effective
-- So AssignmentOrBarrierStartDate needs to be included as an exit date
select		csd.CaseHashBin									as CaseHashBin
			,csd.CaseHash									as CaseHash
			,'Assignment/Barrier Start Date'				as ActivityName
			,csd.AssignmentOrBarrierStartDate				as ActivityCompleteDate 
			,csd.RecordSource								as RecordSource
from		CaseStartDate									csd
where		csd.AssignmentOrBarrierStartDate is not null
) 	
,GetWorkflowActivity as (	-- Get start date, exit date, and all WFA activities for a case
-- Case start date
select		csd.CaseHashBin									as CaseHashBin
			,csd.CaseHash									as CaseHash
			,csd.ActivityName								as ActivityName
			,csd.ActivityDate								as ActivityCompleteDate
			,csd.RecordSource								as RecordSource
from		CaseStartDate									csd
join		CaseStartDate									csd1 on csd.CaseHashBin = csd1.CaseHashBin 		and csd1.ActivityName = 'Start Date'
left join	CaseExitDate									ced	 on ced.CaseHash 	= csd.CaseHash			and	ced.ActivityName = 'Exit Activity'	-- Get exit activity date
where		csd.ActivityDate <= isnull(ced.ActivityCompleteDate, 
										case	when dateadd(day, 639, csd1.ActivityDate) > getdate()
												then getdate()
												else dateadd(day, 639, csd1.ActivityDate) 
										end)
union all
-- Get all Work First Appraisal activities for a case between start and the final exit dates
select		distinct 
			csd.CaseHashBin									as CaseHashBin
			,csd.CaseHash									as CaseHash
			,'Has Activity'									as ActivityName
			,cast(sac.ActivityStartDate as date)			as ActivityCompleteDate
			,csd.RecordSource								as RecordSource
from		CaseStartDate									csd
join		DV.LINK_case_Activity							lca on lca.CaseHash		= csd.CaseHashBin
join		DV.SAT_Activity_Adapt_Core						sac on sac.ActivityHash = lca.ActivityHash		and sac.IsCurrent = 1		and (isnull(sac.ActivityName,'') like '%Work First Appraisal%' or isnull(sac.ActivityName,'') like '%Working First Appraisal%') 
join		DV.Dimension_References							dr1 on dr1.Code			= sac.ActivityStatus	and dr1.Description in ('Completed', 'Partially Completed', 'Confirmed', 'Not Started')
left join	CaseExitDate									ced	on ced.CaseHash		= csd.CaseHash			and	ced.ActivityName = 'Exit Activity'	-- Get exit activity date
where		sac.ActivityStartDate >= isnull(csd.ActivityDate, '1900-01-01')		-- Activity is between start and exit dates
and			sac.ActivityStartDate <= isnull(ced.ActivityCompleteDate, 
												case	when dateadd(day, 639, csd.ActivityDate) > getdate()
														then getdate()
														else dateadd(day, 639, csd.ActivityDate) 
												end) 
and			csd.ActivityName = 'Start Date'
-- Do not pick up activities which occurred while the participant was in work or disengaged
and not exists (select		inw.CaseHash
				from		CaseStartDate					inw
				where		inw.CaseHash = csd.CaseHash
				and			sac.ActivityStartDate between inw.AssignmentOrBarrierStartDate and inw.ActivityDate)
union all
-- Get exit date for a case
select		ced.CaseHashBin									as CaseHashBin
			,ced.CaseHash									as CaseHash
			,ced.ActivityName								as ActivityName
			,ced.ActivityCompleteDate						as ActivityCompleteDate 
			,ced.RecordSource								as RecordSource
from		CaseExitDate 									ced
union all	
-- For cases where there is no exit date, use start date + 639 days and put ActivityName as 'Missing Exit'
-- If start date + 639 days is in future or if there is no start date, use today's date as exit date
select distinct	
			 csd.CaseHashBin								as CaseHashBin
			,csd.CaseHash									as CaseHash
			,'Missing Exit'									as ActivityName
			,case	when dateadd(day, 639, csd.ActivityDate) > getdate()
					then cast(getdate() as date)
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
,CSS9_Base as (
-- If there are multiple activities within the due date range, only select the first activity
select grp.CaseHashBin, grp.CaseHash, grp.ActivityName, grp.ActivityDate, grp.NextActivityDueDate, min(grp.NextActivityDateWithinDueDate) as NextActivityDateWithinDueDate, max(grp.NextActivityDateAfterDueDate) as NextActivityDateAfterDueDate, grp.NextActivityNameAfterDueDate, max(grp.NextActivityDueDateAfterCurrentDueDate) as NextActivityDueDateAfterCurrentDueDate, grp.RecordSource
from
(
	select		wf1.CaseHashBin									as CaseHashBin
				,wf1.CaseHash									as CaseHash
				,wf1.ActivityName								as ActivityName
				,wf1.ActivityCompleteDate						as ActivityDate
				,wf1.NextActivityDueDate
				,NextActivityDateWithinDueDate = wf2.ActivityCompleteDate
				,wf1.NextActivityDateWithinDueDate1d
				,wf1.NextActivityDateWithinDueDate10wd
				-- Following three columns are used in the next CTE to generate records when there are missed activities 
				,case	when wf2.ActivityCompleteDate is null 
						then lead(wf1.ActivityCompleteDate, 1) over (partition by wf1.CaseHash order by wf1.ActivityCompleteDate asc, wf1.ActivityName desc) 
						else null
					end											as NextActivityDateAfterDueDate		-- If there is no activity within the current due date range, get activity date for the next earliest activity (whenever it took place)
				, case 	when wf2.ActivityCompleteDate is null 
						then lead(wf1.ActivityName, 1) over (partition by wf1.CaseHash order by wf1.ActivityCompleteDate asc, wf1.ActivityName desc) 
						else null
					end											as NextActivityNameAfterDueDate		-- If there is no activity within the current due date range, get activity name for the next earliest activity (whenever it took place)
				,case	when wf2.ActivityCompleteDate is null 
						then lead(wf1.NextActivityDueDate, 1) over (partition by wf1.CaseHash order by wf1.ActivityCompleteDate asc, wf1.ActivityName desc) 
						else null
				 end											as NextActivityDueDateAfterCurrentDueDate		-- If there is no activity within the current due date range, get activity due date for the next earliest activity (whenever it took place)
				,wf1.RecordSource								as RecordSource
	from
		(
		select		wf1.CaseHashBin									as CaseHashBin
					,wf1.CaseHash									as CaseHash
					,wf1.ActivityName								as ActivityName
					,wf1.ActivityCompleteDate						as ActivityCompleteDate
					,(select max ([Date])
						from   
							(
							select top(( @SLADuration )+0 ) [Date]
							from   dw.d_date
							where  [Date] > wf1.ActivityCompleteDate
								and is_business_day = 1
							order by [Date]
							) a
					)												as NextActivityDueDate
					,dateadd(day, 1, wf1.ActivityCompleteDate)		as NextActivityDateWithinDueDate1d
					,(select max ([Date])
						from   
							(
							select top(( @SLADuration )+0 ) [Date]
							from   dw.d_date
							where  [Date] > wf1.ActivityCompleteDate
								and is_business_day = 1
							order by [Date]
							) a
					)												as NextActivityDateWithinDueDate10wd
					,wf1.RecordSource								as RecordSource
		from		GetWorkflowActivity								wf1
		)															wf1
		left join	GetWorkflowActivity								wf2 on wf2.CaseHash = wf1.CaseHash			-- Get next activity which is within the current due date range
																	   and wf2.ActivityCompleteDate between 
																		   case when wf1.ActivityName in ('Start Date', 'Assignment Leave Add Date', 'Barrier End Date') 
																				then wf1.ActivityCompleteDate
																				else wf1.NextActivityDateWithinDueDate1d
																		   end 
																		   and wf1.NextActivityDateWithinDueDate10wd
																	   and wf2.ActivityName in ('Has Activity', 'Exit Activity')
) grp
where grp.NextActivityNameAfterDueDate is null
	-- Exlude records where either the current activity is 'Assignment/Barrier Start Date' or 
	-- if participant has gone InWork/Disengaged before next activity due date
   or (grp.ActivityName != 'Assignment/Barrier Start Date' and grp.NextActivityNameAfterDueDate != 'Assignment/Barrier Start Date') 
   or (grp.NextActivityNameAfterDueDate = 'Assignment/Barrier Start Date' and grp.NextActivityDateAfterDueDate > grp.NextActivityDueDate)
group by grp.CaseHashBin, grp.CaseHash, grp.ActivityName, grp.ActivityDate, grp.NextActivityDueDate, grp.NextActivityNameAfterDueDate, grp.RecordSource
)
,CSS9_Complete as (
select	  	 c9b.CaseHashBin
			,c9b.CaseHash
			,c9b.ActivityName
			,c9b.ActivityDate
			,c9b.NextActivityDueDate
			,c9b.NextActivityDateWithinDueDate
			,c9b.NextActivityDateAfterDueDate
			,c9b.NextActivityNameAfterDueDate
			,c9b.RecordSource	
from		CSS9_Base										c9b
where		c9b.ActivityName not in ('Exit Activity', 'Missing Exit', 'Barrier Start Date') 	-- Exit date line gets generated in the below union
union all
-- Fill gaps between missing WFA activities
select		 c9b.CaseHashBin
			,c9b.CaseHash
			,case	when	c9b.DATE >= c9b.NextActivityDateAfterDueDate
							and c9b.NextActivityNameAfterDueDate not in ('Missing Exit', 'Has Activity')
					then	c9b.NextActivityNameAfterDueDate			-- If next earliest activity is the final exit activity then use actual exit activity name. This regenerates the exit line which is excluded in above union with correct dates
					else	'Missing WFA'
			 end											as ActivityName
			,null											as ActivityDate
 			,c9b.DATE										as NextActivityDueDate
			,case	when	c9b.DATE >= c9b.NextActivityDateAfterDueDate 			-- If the generated missing due date is after next earliest activity then use date for the next earliest activity as NextActivityDateWithinDueDate
							and c9b.NextActivityNameAfterDueDate != 'Missing Exit'	-- however if the next earliest activity is 'Missing Exit' then that means there was no next earliest activity and it should be null
					then	c9b.NextActivityDateAfterDueDate
					else	null										
			end												as NextActivityDateWithinDueDate
			, null											as NextActivityDateAfterDueDate
			, null											as NextActivityNameAfterDueDate
			,c9b.RecordSource								as RecordSource
from
(
	select c9b.*, ddd.Date, row_number() over (partition by c9b.CaseHash, c9b.NextActivityDueDate, c9b.NextActivityDateAfterDueDate order by ddd.Date) rn
	from		CSS9_Base										c9b
	-- Get all working days from due date until the due date of next earliest activity
	join		dw.d_date										ddd on ddd.Date > c9b.NextActivityDueDate 
																	and ddd.Date < c9b.NextActivityDueDateAfterCurrentDueDate
																	and ddd.is_business_day = 1															
	where		c9b.NextActivityDateWithinDueDate is null		-- Identifies records where an activity hasn't taken place when it was due as we only need to generate missing gaps for these ones
	and			(   c9b.NextActivityNameAfterDueDate is null 
				-- Since InWork/Disengaged needs to be excluded, so the missing records need to be generated up until just prior to the 'Assignment/Barrier Start Date'
				 or c9b.NextActivityNameAfterDueDate != 'Assignment/Barrier Start Date'
				 or (c9b.NextActivityNameAfterDueDate = 'Assignment/Barrier Start Date' and ddd.DATE < c9b.NextActivityDateAfterDueDate )) 
	and			c9b.ActivityName not in ('Exit Activity', 'Missing Exit') 		-- Exit activity record is not needed because it gets regenerated while generating the missing records within this union
) c9b where rn % @SLADuration = 0		-- Only pick up every @SLADuration working day			
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
select		 cs9.CaseHashBin								as CaseHashBin
			,cs9.CaseHash									as CaseHash
			,null											as EmployeeHashBin
			,null											as EmployeeHash
			,null											as AssignmentHashIfNeeded
			,cs9.NextActivityDateWithinDueDate				as WorkFlowEventDate
			-- For WorkFlowEventEstimatedStartDate, get previous WorkFlowEventDate. If null then get previous WorkFlowEventEstimatedEndDate.
			,case when cs9.ActivityName in ('Start Date', 'Assignment Leave Add Date', 'Barrier End Date') then cs9.ActivityDate
				  else coalesce(lag(cs9.NextActivityDateWithinDueDate, 1) over (partition by cs9.CaseHash order by cs9.NextActivityDueDate, isnull(cs9.NextActivityDateWithinDueDate, cs9.NextActivityDateAfterDueDate))
							   ,lag(cs9.NextActivityDueDate, 1) over (partition by cs9.CaseHash order by cs9.NextActivityDueDate, isnull(cs9.NextActivityDateWithinDueDate, cs9.NextActivityDateAfterDueDate)))			
			 end											as WorkFlowEventEstimatedStartDate
			,cs9.NextActivityDueDate						as WorkFlowEventEstimatedEndDate 
			,null											as InOutWork
			,'WHP Wales  -  CSS9'							as CSSName
			,cs9.RecordSource								as RecordSource
from		CSS9_Complete									cs9;


set @LoadStartMessage = concat('Wales CSS 9 Time Taken = ',(select cast((getdate()-@LoadStartTime) as time(0)) '[hh:mm:ss]'))
raiserror(@LoadStartMessage, 0, 1) with nowait;
set @LoadStartTime = getdate();

--------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------
-- Wales WHP CSS10 Rules -------------------------------------------------------------
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
select		 tmp.CaseHashBin									 as CaseHashBin
			,tmp.CaseHash										 as CaseHash
			,null												 as EmployeeHashBin
			,null												 as EmployeeHash
			,null												 as AssignmentHashIfNeeded
			,min(fta.BotFTADate)								 as WorkFlowEventDate
			,sac.ActivityDueDate								 as WorkFlowEventEstimatedStartDate 
			,(select	max(gdt.[Date])	as [Date]
			 from		(select top (select						 wfc.WorkFlowEventSLADuration *1
									 from						 meta.SAT_WorkFlowEventType_Core wfc
									 where						 wfc.WorkFlowEventProgramme = 'WHP Wales'
									 and						 wfc.WorkFlowEventCSSRelated = 'CSS10')	ddd.[Date]
						 from		DW.d_date ddd
						 where		ddd.[Date] > sac.ActivityDueDate
						 and		ddd.is_business_day		= 1
						 order by	ddd.[Date]) gdt)			 as WorkFlowEventEstimatedEndDate
			,tmp.InOutWork										 as InOutWork
			,'WHP Wales  -  CSS10'								 as CSSName
			,tmp.RecordSource									 as RecordSource
from		stg.Meta_WorkflowEventsStaging						 tmp
-- Get all activities against a case
join		DV.LINK_Case_Activity								 lca on lca.CaseHash		= tmp.CaseHashBin
join		DV.SAT_Activity_Adapt_Core							 sac on lca.ActivityHash	= sac.ActivityHash and sac.IsCurrent = 1 and sac.ActivityDueDate >= tmp.StartDate
join		DV.Dimension_References								 dr1 on dr1.Code			= sac.ActivityStatus	
left join	(select			cor.CaseHash
						   ,cast(cac.CorrespondenceDate as date) as BotFTADate
				from		DV.link_case_Correspondence			 cor
				join		DV.SAT_Correspondence_Adapt_Core	 cac on cac.CorrespondenceHash = cor.CorrespondenceHash and cac.IsCurrent = 1
				join 		DV.SAT_References_MDMultiNames		 md	 on md.id = cac.CorrespondenceMethod
				where		md.Description = 'BOT - FTA'	
			)													fta  on fta.CaseHash		= tmp.CaseHashBin and fta.BotFTADate >= ActivityDueDate
where		tmp.LeaveDate is null        
and			tmp.InOutWork = 'Unemployed'
and			(DR1.Description in ('Not Started', 'Partially Completed')
			or (sac.ActivityCompleteDate is null
				and cast(sac.ActivityDueDate as DATE) <= cast(getdate() as DATE)))
and		tmp.ProgrammeName = 'WHP Wales'
group by tmp.CaseHashBin								
		,tmp.CaseHash										
		,sac.ActivityDueDate								
		,tmp.InOutWork										
		,tmp.RecordSource;

set @LoadStartMessage = concat('Wales CSS 10 Time Taken = ',(select cast((getdate()-@LoadStartTime) as time(0)) '[hh:mm:ss]'))
raiserror(@LoadStartMessage, 0, 1) with nowait;
set @LoadStartTime = getdate();

--------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------
-- Wales WHP CSS11 Rules --------------------------------------------------------------
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
select		tmp.CaseHashBin										as CaseHashBin
			,tmp.CaseHash										as CaseHash
			,null												as EmployeeHashBin
			,null												as EmployeeHash
			,null												as AssignmentHashIfNeeded
			,act.ActivityCompleteDate							as WorkFlowEventDate
			,asg.WorkFlowEventEstimatedStartDate 				as WorkFlowEventEstimatedStartDate
			,asg.WorkFlowEventEstimatedEndDate					as WorkFlowEventEstimatedEndDate
			,tmp.InOutWork										as InOutWork
			,'WHP Wales  -  CSS11'								as CSSName
			,tmp.RecordSource									as RecordSource
from		stg.Meta_WorkflowEventsStaging					tmp
join
(	-- Get all assignments against a case
	select 
			 asg.CaseHash
			,asg.AssignmentHash
			,asg.PriorWorkingDay as WorkFlowEventEstimatedStartDate
			,asg.WorkFlowEventEstimatedEndDate
	from
	(
		select
			 lca.CaseHash
			,lca.AssignmentHash
			--,cast(dateadd(month,((year(sac.AssignmentAddDate) - 1900) * 12) + month(sac.AssignmentAddDate), -1) as date) as WorkFlowEventEstimatedEndDate
			,CASE WHEN DATEPART(DW, DATEADD(DD, 1, sac.AssignmentAddDate)) = 7 
				  THEN 
						Cast(DATEADD(DD, 2, sac.AssignmentAddDate) as Date)
				 ELSE 
						Cast(DATEADD(DD, 1, sac.AssignmentAddDate) as Date)
				 END WorkFlowEventEstimatedEndDate
			,dat.Date as PriorWorkingDay
			,row_number() over (partition by lca.AssignmentHash order by dat.date_skey desc) as PriorWorkingDayCount
		from 	  DV.LINK_Case_Assignment 		lca
		join 	  DV.SAT_Assignment_Adapt_Core 	sac on sac.AssignmentHash = lca.AssignmentHash and sac.IsCurrent = 1
		left join dwh.dim_date 					dat	on dat.[Date] between dateadd(dd, -20, sac.AssignmentAddDate) and sac.AssignmentAddDate and dat.is_business_day = 1
		where 	  sac.AssignmentStartDate is not null 
		and 	  isnull(sac.AssignmentStartClaimYear,'') not like 'DNC%'
	) asg 
	where asg.PriorWorkingDayCount = 10 or asg.PriorWorkingDay is null
) asg	on tmp.CaseHashBin = asg.CaseHash
left join
(	-- Get all workplace plan activities against a case
	select distinct
		  lcav.CaseHash
		, cast(saac.ActivityCompleteDate as date) as ActivityCompleteDate
	from DV.LINK_Case_Activity 					  lcav
	join DV.SAT_Activity_Adapt_Core 			  saac on lcav.ActivityHash = saac.ActivityHash and saac.IsCurrent = 1 
	where saac.ActivityName like '%Workplace Plan Appointment%'
) act	on asg.CaseHash = act.CaseHash and act.ActivityCompleteDate between asg.WorkFlowEventEstimatedStartDate and asg.WorkFlowEventEstimatedEndDate
where	tmp.ProgrammeName = 'WHP Wales';

set @LoadStartMessage = concat('Wales CSS 11 Time Taken = ',(select cast((getdate()-@LoadStartTime) as time(0)) '[hh:mm:ss]'))
raiserror(@LoadStartMessage, 0, 1) with nowait;
set @LoadStartTime = getdate();

--------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------
-- Wales WHP CSS12 Rules --------------------------------------------------------------
--------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------

select		@SLADuration =	wfc.WorkFlowEventSLADuration *1
from		META.SAT_WorkFlowEventType_Core wfc
where		wfc.WorkFlowEventProgramme = 'WHP Wales'
and			wfc.WorkFlowEventCSSRelated = 'CSS12';

with AssignmentLeaveAddedDate as (
----- Audit table date added of the assignment leave date
select      laa.AssignmentHash
			,cast(max(laa.AuditDate) as date)       as JobLeaveAddDate
from        DV.SAT_Assignment_LeaveAudit_Adapt_Core laa
where       laa.IsCurrent = 1
group by    laa.AssignmentHash
)
,BarrierStartEndDates as (
select distinct	tmp.CaseHashBin								as CaseHashBin
			,tmp.CaseHash									as CaseHash
			,sac.AssignmentHash								as AssignmentHash
			,'Barrier End Date'								as ActivityName
			,cast(bac.BarrierEndDate as date)				as ActivityDate
			,lad.JobLeaveAddDate							as JobLeaveDate
			,case when bac.BarrierStartDate > sac.AssignmentStartVerificationDate
				  then cast(bac.BarrierStartDate as date)				
				  else cast(sac.AssignmentStartVerificationDate as date)	
			end												as BarrierStartDate 
			,dateadd(day,639
					,cast(sac.AssignmentStartVerificationDate as date)) as StartDate639
			,tmp.RecordSource								as RecordSource
from		stg.Meta_WorkflowEventsStaging					tmp
join		DV.LINK_Case_Assignment							lca on lca.CaseHash			= tmp.CaseHashBin
join		DV.SAT_Assignment_Adapt_Core					sac on sac.AssignmentHash	= lca.AssignmentHash and sac.IsCurrent = 1
join		DV.LINK_Case_Barriers							cba on cba.CaseHash			= tmp.CaseHashBin  
join		DV.SAT_Barriers_Adapt_Core						bac on bac.BarriersHash 	= cba.BarriersHash and bac.IsCurrent = 1
join		DV.SAT_References_MDMultiNames					mu1 on mu1.ID = bac.BarrierName and mu1.Type = 'Code'
left join	AssignmentLeaveAddedDate						lad on lad.AssignmentHash	= lca.AssignmentHash
where		tmp.ProgrammeName = 'WHP Wales'	
and			tmp.InOutWork = 'Employed'					-- Include InWork
and 		tmp.StartDate is not null
and			tmp.LeaveDate is null
and			sac.AssignmentStartVerificationDate is not null
and			isnull(sac.AssignmentStartClaimYear,'') not like 'DNC%'
and 		isnull(sac.AssignmentLeaveDate, getdate()) > sac.AssignmentStartVerificationDate
and 		bac.BarrierEndDate > sac.AssignmentStartVerificationDate -- Only pick barriers which continue until after the job has started
and 		((coalesce(nullif(mu1.Name,''),nullif(mu1.Description,''),'Unknown') like '%Disengage%')				
			  or (coalesce(nullif(mu1.Name,''),nullif(mu1.Description,''),'Unknown') like '%suspend engagement%'))
)
,JobVerifiedDate as (
-- Get job verified date for each assignment as the start date
select		tmp.CaseHashBin									   as CaseHashBin
			,tmp.CaseHash									   as CaseHash
			,sac.AssignmentHash								   as AssignmentHash
			,'Job Verified Date'							   as ActivityName
			,cast(sac.AssignmentStartVerificationDate as date) as ActivityDate
			,lad.JobLeaveAddDate							   as JobLeaveDate
			,null											   as BarrierStartDate
			,tmp.RecordSource								   as RecordSource
from		stg.Meta_WorkflowEventsStaging					   tmp
join		DV.LINK_Case_Assignment							   lca on lca.CaseHash			= tmp.CaseHashBin
join		DV.SAT_Assignment_Adapt_Core					   sac on sac.AssignmentHash	= lca.AssignmentHash and sac.IsCurrent = 1
left join	AssignmentLeaveAddedDate						   lad on lad.AssignmentHash	= lca.AssignmentHash
where		tmp.ProgrammeName = 'WHP Wales'	
and			tmp.InOutWork = 'Employed'						-- Include InWork
and 		tmp.StartDate is not null
and			tmp.LeaveDate is null
and			sac.AssignmentStartVerificationDate is not null
and			isnull(sac.AssignmentStartClaimYear,'') not like 'DNC%'
and 		isnull(sac.AssignmentLeaveDate, getdate()) > sac.AssignmentStartVerificationDate
union
-- If a participant has completed the disengagement barrier, then we need to exclude the periods when disengagement barrier was effective
-- So BarrierEndDate needs to be included as the start date, because date ranges need to be generated again after that date
-- Self-join is done because barrier start and end dates can overlap
select		a.CaseHashBin									as CaseHashBin
			,a.CaseHash										as CaseHash
			,a.AssignmentHash								as AssignmentHash
			,a.ActivityName									as ActivityName
			,isnull(b.ActivityDate, a.ActivityDate)			as ActivityDate
			,null											as JobLeaveDate
			,min(isnull(case when b.BarrierStartDate > a.BarrierStartDate 
							 then a.BarrierStartDate 
							 else b.BarrierStartDate 
						 end, a.BarrierStartDate))			as BarrierStartDate
			,a.RecordSource									as RecordSource
from 	  BarrierStartEndDates								a
left join BarrierStartEndDates								b on  a.AssignmentHash = b.AssignmentHash
															  and a.ActivityDate   > b.BarrierStartDate 
															  and a.ActivityDate   < b.ActivityDate 
-- Only include as start date if the barrier ended before the exit date (because if the barrier continued until the exit date then we do not need to start re-generating periods after the barrier ended)															  
where 	 a.ActivityDate < isnull(a.JobLeaveDate, a.StartDate639)
group by a.CaseHashBin, a.CaseHash, a.AssignmentHash, a.ActivityName, isnull(b.ActivityDate, a.ActivityDate), a.RecordSource
)
,JobExitDate as (
-- Get job leave date for each assignment as the final exit date
select		jvd.CaseHashBin									as CaseHashBin
			,jvd.CaseHash									as CaseHash
			,AssignmentHash									as AssignmentHash
			,'Exit Activity'								as ActivityName
			,jvd.JobLeaveDate								as ActivityDate
			,jvd.RecordSource								as RecordSource
from		JobVerifiedDate									jvd
where		jvd.ActivityName = 'Job Verified Date'
and 		jvd.JobLeaveDate is not null
union
-- If a participant has completed the disengagement barrier, then we need to exclude the periods when disengagement barrier was effective
-- So BarrierStartDate needs to be included as an exit date
select		jvd.CaseHashBin									as CaseHashBin
			,jvd.CaseHash									as CaseHash
			,AssignmentHash									as AssignmentHash
			,'Barrier Start Date'							as ActivityName
			,jvd.BarrierStartDate							as ActivityDate 
			,jvd.RecordSource								as RecordSource
from		JobVerifiedDate									jvd
where		jvd.ActivityName = 'Barrier End Date'
and 		jvd.BarrierStartDate is not null
) 
,GetWorkflowActivity as (	-- Get start date, exit date, and all activities for a case
select		jvd.CaseHashBin									as CaseHashBin
			,jvd.CaseHash									as CaseHash
			,jvd.AssignmentHash								as AssignmentHash
			,jvd.ActivityName								as ActivityName
			,jvd.ActivityDate								as ActivityDueDate
			,jvd.RecordSource								as RecordSource
from		JobVerifiedDate									jvd
join		JobVerifiedDate									jvd1 on jvd1.AssignmentHash = jvd.AssignmentHash 	and jvd1.ActivityName = 'Job Verified Date'
left join	JobExitDate										jed	 on jed.AssignmentHash = jvd.AssignmentHash 	and	jed.ActivityName = 'Exit Activity'	-- Get exit activity date
where		jvd.ActivityDate <= isnull(jed.ActivityDate, 
										case	when dateadd(day, 639, jvd1.ActivityDate) > getdate()
												then getdate()
												else dateadd(day, 639, jvd1.ActivityDate) 
										end)
union
select		distinct 
			jvd.CaseHashBin									as CaseHashBin
			,jvd.CaseHash									as CaseHash
			,jvd.AssignmentHash								as AssignmentHash
			,'Has Activity'									as ActivityName
			,cast(sac.ActivityDueDate as date)				as ActivityDueDate
			,jvd.RecordSource								as RecordSource
from		JobVerifiedDate									jvd
join		DV.LINK_case_Activity							lca on lca.CaseHash		  = jvd.CaseHashBin
join		DV.SAT_Activity_Adapt_Core						sac on sac.ActivityHash   = lca.ActivityHash	and sac.IsCurrent = 1
left join	DV.Dimension_References							dr1 on dr1.Code			  = sac.ActivityStatus	
left join	JobExitDate										jed	on jed.AssignmentHash = jvd.AssignmentHash  and jed.ActivityName = 'Exit Activity'	-- To get job leave date as the final exit date
where		sac.ActivityDueDate >= isnull(jvd.ActivityDate, '1900-01-01')	-- Activity is between start and exit dates
and			sac.ActivityDueDate <= isnull(jed.ActivityDate, 
											case	when dateadd(day, 639, jvd.ActivityDate) > getdate()
													then getdate()
													else dateadd(day, 639, jvd.ActivityDate) 
											end) 
and			isnull(dr1.Description, '') != 'Cancelled'
and			jvd.ActivityName = 'Job Verified Date'
-- Do not pick up activities which occurred while the participant was disengaged
and not exists (select		dis.CaseHash
				from		JobVerifiedDate					dis
				where		dis.AssignmentHash = jvd.AssignmentHash
				and			sac.ActivityDueDate between dis.BarrierStartDate and dis.ActivityDate)											
union
select		distinct 
			jvd.CaseHashBin									as CaseHashBin
			,jvd.CaseHash									as CaseHash
			,jvd.AssignmentHash								as AssignmentHash
			,'Has Activity'									as ActivityName
			,cast(sca.CorrespondenceDate as date)			as ActivityDueDate
			,jvd.RecordSource								as RecordSource
from		JobVerifiedDate									jvd
left join	DV.LINK_Case_Correspondence						lcc on lcc.CaseHash = jvd.CaseHashBin
left join	DV.SAT_Correspondence_Adapt_Core				sca on sca.CorrespondenceHash = lcc.CorrespondenceHash	and sca.IsCurrent = 1
left join	JobExitDate										jed	on jed.AssignmentHash = jvd.AssignmentHash 			and jed.ActivityName = 'Exit Activity'	-- To get job leave date as the final exit date
where		sca.CorrespondenceDate is not null
and			sca.CorrespondenceDate >= isnull(jvd.ActivityDate, '1900-01-01') -- Activity is between start and exit dates
and			sca.CorrespondenceDate <= isnull(jed.ActivityDate, 
											case	when dateadd(day, 639, jvd.ActivityDate) > getdate()
													then getdate()
													else dateadd(day, 639, jvd.ActivityDate) 
											end)
and			jvd.ActivityName = 'Job Verified Date'											
-- Do not pick up activities which occurred while the participant was disengaged
and not exists (select		dis.CaseHash
				from		JobVerifiedDate					dis
				where		dis.AssignmentHash = jvd.AssignmentHash
				and			sca.CorrespondenceDate between dis.BarrierStartDate and dis.ActivityDate)
union
-- Get exit date for a case
select		jed.CaseHashBin									as CaseHashBin
			,jed.CaseHash									as CaseHash
			,jed.AssignmentHash								as AssignmentHash
			,jed.ActivityName								as ActivityName
			,jed.ActivityDate								as ActivityDueDate 
			,jed.RecordSource								as RecordSource
from		JobExitDate										jed
union	-- For cases where there is no exit date, use start date + 639 days and put ActivityName as 'Missing Exit'
		-- If start date + 639 days is in future or if there is no start date, use today's date as exit date
select		jvd.CaseHashBin									as CaseHashBin
			,jvd.CaseHash									as CaseHash
			,jvd.AssignmentHash								as AssignmentHash
			,'Missing Exit'									as ActivityName
			,case	when dateadd(day, 639, jvd.ActivityDate) > getdate()
					then cast(getdate() as date)
					else dateadd(day, 639, jvd.ActivityDate) 
			 end											as ActivityDueDate 
			,jvd.RecordSource								as RecordSource
from		JobVerifiedDate									jvd
where		-- Exclude cases where there is an exit date
not exists	(select		jed.CaseHash
			from		JobExitDate							jed
			where		jed.AssignmentHash = jvd.AssignmentHash
			and 		jed.ActivityName = 'Exit Activity')
and			jvd.ActivityName = 'Job Verified Date'
)
,CSS12_Base	as (
-- If there are multiple activities within the due date range, only select the first activity
select grp.CaseHashBin, grp.CaseHash, grp.AssignmentHash, grp.ActivityName, grp.ActivityDate, grp.NextActivityDueDate, min(grp.NextActivityDateWithinDueDate) as NextActivityDateWithinDueDate, max(grp.NextActivityDateAfterDueDate) as NextActivityDateAfterDueDate, grp.NextActivityNameAfterDueDate, max(grp.NextActivityDueDateAfterCurrentDueDate) as NextActivityDueDateAfterCurrentDueDate, grp.RecordSource
from (
	select	wf1.CaseHashBin
			, wf1.CaseHash
			, wf1.AssignmentHash
			, wf1.ActivityName
			, wf1.ActivityDate
			, wf1.NextActivityDueDate
			, NextActivityDateWithinDueDate = wf2.ActivityDueDate
			, wf1.NextActivityDateWithinDueDate1d
			, wf1.NextActivityDateWithinDueDate10wd
			-- Following three columns are used in the next CTE to generate records when there are missed activities 
			,case	when wf2.ActivityDueDate is null 
					then lead(wf1.ActivityDate, 1) over (partition by wf1.AssignmentHash order by wf1.ActivityDate asc, wf1.ActivityName desc) 
					else null
				end											as NextActivityDateAfterDueDate		-- If there is no activity within the current due date range, get activity date for the next earliest activity (whenever it took place)
			, case 	when wf2.ActivityDueDate is null 
					then lead(wf1.ActivityName, 1) over (partition by wf1.AssignmentHash order by wf1.ActivityDate asc, wf1.ActivityName desc) 
					else null
				end											as NextActivityNameAfterDueDate		-- If there is no activity within the current due date range, get activity name for the next earliest activity (whenever it took place)
			,case	when wf2.ActivityDueDate is null 
					then lead(wf1.NextActivityDueDate, 1) over (partition by wf1.AssignmentHash order by wf1.ActivityDate asc, wf1.ActivityName desc) 
					else null
			 end											as NextActivityDueDateAfterCurrentDueDate		-- If there is no activity within the current due date range, get activity due date for the next earliest activity (whenever it took place)
			, wf1.RecordSource	
	from
		(
		select		wf1.CaseHashBin									as CaseHashBin
					,wf1.CaseHash									as CaseHash
					,wf1.AssignmentHash								as AssignmentHash
					,wf1.ActivityName								as ActivityName
					,wf1.ActivityDueDate							as ActivityDate
					,(select max ([Date])
						from   
							(
							select top(( @SLADuration )+0 ) [Date]
							from   DW.d_date
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
							from   DW.d_date
							where  [Date] > wf1.ActivityDueDate
								and is_business_day = 1
							order by [Date]
							) a
					)												as NextActivityDateWithinDueDate10wd
					,wf1.RecordSource								as RecordSource
		from		GetWorkflowActivity								wf1
		)															wf1
		left join	GetWorkflowActivity								wf2 on wf2.AssignmentHash = wf1.AssignmentHash			-- Get next activity which is within the current due date range
																	   and wf2.ActivityDueDate between 
																		   case when wf1.ActivityName in ('Job Verified Date', 'Barrier End Date') 
																				then wf1.ActivityDate
																				else wf1.NextActivityDateWithinDueDate1d
																		   end 
																		   and wf1.NextActivityDateWithinDueDate10wd
																	   and wf2.ActivityName = 'Has Activity'
) grp
where grp.NextActivityNameAfterDueDate is null
	-- Exlude records where either the current activity is 'Barrier Start Date' or 
	-- if participant has gone Disengaged before next activity due date
   or (grp.ActivityName != 'Barrier Start Date' and grp.NextActivityNameAfterDueDate != 'Barrier Start Date') 
   or (grp.NextActivityNameAfterDueDate = 'Barrier Start Date' and grp.NextActivityDateAfterDueDate > grp.NextActivityDueDate)
group by grp.CaseHashBin, grp.CaseHash, grp.AssignmentHash, grp.ActivityName, grp.ActivityDate, grp.NextActivityDueDate, grp.NextActivityNameAfterDueDate, grp.RecordSource						
)
,CSS12_Complete as (
	select	  	 c12b.CaseHashBin
				,c12b.CaseHash
				,c12b.AssignmentHash
				,c12b.ActivityName
				,c12b.ActivityDate
				,c12b.NextActivityDueDate
				,c12b.NextActivityDateWithinDueDate
				,c12b.NextActivityDateAfterDueDate
				,c12b.NextActivityNameAfterDueDate
				,c12b.RecordSource	
	from		CSS12_Base										c12b
	where		c12b.ActivityName not in ('Exit Activity', 'Missing Exit', 'Barrier Start Date')		-- Exit date line gets generated in the below union
	and	not		(c12b.NextActivityNameAfterDueDate = 'Exit Activity' and c12b.NextActivityDueDate >= isnull(c12b.NextActivityDateAfterDueDate, '9999-12-31')) -- Exclude records where exit date falls between the date period
	union all
	-- Fill gaps between missing appointments
	select		 c12b.CaseHashBin
				,c12b.CaseHash
				,c12b.AssignmentHash
				,case	when	c12b.DATE >= c12b.NextActivityDateAfterDueDate
								and c12b.NextActivityNameAfterDueDate not in ('Missing Exit', 'Has Activity')
						then	c12b.NextActivityNameAfterDueDate			-- If next earliest activity is the final exit activity then use actual exit activity name. This regenerates the exit line which is excluded in above union with correct dates
						else	'Missing Activity'
				 end											as ActivityName
				,null											as ActivityDate
 				,c12b.DATE										as NextActivityDueDate
				,case	when	c12b.DATE >= c12b.NextActivityDateAfterDueDate 			-- If the generated missing due date is after next earliest activity then use date for the next earliest activity as NextActivityDateWithinDueDate
								and c12b.NextActivityNameAfterDueDate != 'Missing Exit'	-- however if the next earliest activity is 'Missing Exit' then that means there was no next earliest activity and it should be null
						then	c12b.NextActivityDateAfterDueDate
						else	null										
				end												as NextActivityDateWithinDueDate
				, null											as NextActivityDateAfterDueDate
				, null											as NextActivityNameAfterDueDate
				,c12b.RecordSource								as RecordSource
	from
	(
		select c12b.*, ddd.date, row_number() over (partition by c12b.AssignmentHash, c12b.NextActivityDueDate, c12b.NextActivityDateAfterDueDate order by ddd.date) rn
		from	CSS12_Base										c12b
		-- Get all working days from due date until the due date of next earliest activity
		join	dw.d_date										ddd on ddd.DATE > c12b.NextActivityDueDate 
																	and ddd.DATE < c12b.NextActivityDueDateAfterCurrentDueDate
																	and ddd.is_business_day = 1															
		where	c12b.NextActivityDateWithinDueDate is null		-- Identifies records where an activity hasn't taken place when it was due as we only need to generate missing gaps for these ones
		and		(    c12b.NextActivityNameAfterDueDate is null 
				-- Since Disengaged needs to be excluded, so the missing records need to be generated up until just prior to the 'Barrier Start Date'
				or c12b.NextActivityNameAfterDueDate != 'Barrier Start Date'
				or (c12b.NextActivityNameAfterDueDate = 'Barrier Start Date' and ddd.DATE < c12b.NextActivityDateAfterDueDate )) 
		and		c12b.ActivityName not in ('Exit Activity', 'Missing Exit')	-- Exit activity record is not needed because it gets regenerated while generating the missing records within this union
	) c12b where rn % @SLADuration = 0		-- Only pick up every @SLADuration working day
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
select		cs12.CaseHashBin								as CaseHashBin
			,cs12.CaseHash									as CaseHash
			,null											as EmployeeHashBin
			,null											as EmployeeHash
			,AssignmentHash									as AssignmentHashIfNeeded
			,cs12.NextActivityDateWithinDueDate				as WorkFlowEventDate
			-- For WorkFlowEventEstimatedStartDate, get previous WorkFlowEventDate. If null then get previous WorkFlowEventEstimatedEndDate.
			,case when cs12.ActivityName in ('Job Verified Date', 'Barrier End Date') then cs12.ActivityDate
				  else coalesce(lag(cs12.NextActivityDateWithinDueDate, 1) over (partition by cs12.AssignmentHash order by cs12.NextActivityDueDate, isnull(cs12.NextActivityDateWithinDueDate, cs12.NextActivityDateAfterDueDate))
							   ,lag(cs12.NextActivityDueDate, 1) over (partition by cs12.AssignmentHash order by cs12.NextActivityDueDate, isnull(cs12.NextActivityDateWithinDueDate, cs12.NextActivityDateAfterDueDate)))			
			 end											as WorkFlowEventEstimatedStartDate
			,cs12.NextActivityDueDate						as WorkFlowEventEstimatedEndDate 
			,null											as InOutWork
			,'WHP Wales  -  CSS12'							as CSSName
			,cs12.RecordSource								as RecordSource
from		CSS12_Complete									cs12;

set @LoadStartMessage = concat('Wales CSS 12 Time Taken = ',(select cast((getdate()-@LoadStartTime) as time(0)) '[hh:mm:ss]'))
raiserror(@LoadStartMessage, 0, 1) with nowait;
set @LoadStartTime = getdate();

--------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------
-- Wales WHP CSS13 Rules -------------------------------------------------------------
--------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------
with AssignmentLeaveAddedDate as (
----- Audit table date added of the assignment leave date
select      laa.AssignmentHash
			,max(laa.AuditDate)        as JobLeaveAddDate
from        DV.SAT_Assignment_LeaveAudit_Adapt_Core laa
where       laa.IsCurrent = 1
group by    laa.AssignmentHash
),
Scenario1InWork as	(
----- Scenario 1: In Work at 456 days (to be excluded from Scenario 1)
select distinct	tmp.CaseHash
from		stg.Meta_WorkflowEventsStaging		tmp
join		DV.LINK_Case_Assignment				lca on lca.CaseHash			= tmp.CaseHashBin
join		DV.SAT_Assignment_Adapt_Core		sac on sac.AssignmentHash	= lca.AssignmentHash and sac.IsCurrent = 1
left join	AssignmentLeaveAddedDate			lad on lad.AssignmentHash	= sac.AssignmentHash
where		tmp.ProgrammeName = 'WHP Wales'
and			tmp.StartDate is not null
and 		(tmp.LeaveDate is null or tmp.LeaveReason = 'Particpant Returned to DWP - End of Provision')
and 		(    sac.AssignmentStartDate between tmp.StartDate and dateadd(dd,456,tmp.StartDate) 
			 and (lad.JobLeaveAddDate is null or lad.JobLeaveAddDate > dateadd(dd,456,tmp.StartDate))
			)
),
Scenario2InWork as	(
----- Scenario 2: In Work at 639 days (to be excluded from Scenario 2)
select distinct	tmp.CaseHash
from		stg.Meta_WorkflowEventsStaging		tmp
join		DV.LINK_Case_Assignment				lca on lca.CaseHash			= tmp.CaseHashBin
join		DV.SAT_Assignment_Adapt_Core		sac on sac.AssignmentHash	= lca.AssignmentHash and sac.IsCurrent = 1
left join	AssignmentLeaveAddedDate			lad on lad.AssignmentHash	= sac.AssignmentHash
where		tmp.ProgrammeName = 'WHP Wales'
and			tmp.StartDate is not null
and 		(tmp.LeaveDate is null or tmp.LeaveReason = 'Particpant Returned to DWP - End of Provision')
and 		(    sac.AssignmentStartDate between tmp.StartDate and dateadd(dd,639,tmp.StartDate) 
			 and (lad.JobLeaveAddDate is null or lad.JobLeaveAddDate > dateadd(dd,639,tmp.StartDate))
			)
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
select		CaseHashBin
			,CaseHash
			,null											as EmployeeHashBin
			,null											as EmployeeHash
			,null											as AssignmentHashIfNeeded
			,WorkFlowEventDate
			---- StartDate should be 9wd earlier if Due date is scenario1 or 
			,
				(select min ([Date])
				from   
					(
					select top(( 10 )+0 ) [Date]
					from   DW.d_date
					where  [Date] <= WorkFlowEventEstimatedEndDate
						and is_business_day = 1
						and [Date] != '1900-01-01'
					order by [Date] desc
					) a
				) 
			as WorkFlowEventEstimatedStartDate 
			,WorkFlowEventEstimatedEndDate
			,InOutWork
			,CSSName
			,RecordSource
from (
	select		tmp.CaseHashBin									as CaseHashBin
				,tmp.CaseHash									as CaseHash
				,cs13.DocUploadedDate							as WorkFlowEventDate
				---- StartDate should be 9wd earlier if Due date is scenario1 or 
				,tmp.StartDate									as WorkFlowEventEstimatedStartDate 
				,wfe.DueDate									as WorkFlowEventEstimatedEndDate
				,tmp.InOutWork									as InOutWork
				,'WHP Wales  -  CSS13'							as CSSName
				,tmp.RecordSource								as RecordSource
	from		stg.Meta_WorkflowEventsStaging					tmp	
	join		(select		ass.CaseHash						as CaseHash
							--We are using max because we don't have Document by Assignment so the grain has to be at 'Case' level to match the success criteria
							,max(ass.DueDate)					as DueDate
				from		(select		tmp.CaseHash
										,case	when (lad.JobLeaveAddDate <= dateadd(dd,456,tmp.StartDate) and sc1.CaseHash is null) or (lca.CaseHash is null and dateadd(dd,456,tmp.StartDate) <= getdate())	-- OutOfWorkDay456
												then dateadd(dd,456,tmp.StartDate)	  
											
												when lad.JobLeaveAddDate > dateadd(dd,456,tmp.StartDate) and lad.JobLeaveAddDate < dateadd(dd,639,tmp.StartDate) and sc2.CaseHash is null -- OutOfWorkBetweenDay456and639
												then (select	max(gdt.[Date])	as [Date]
													  from	(select top (select	wfc.WorkFlowEventSLADuration *1
																			from	META.SAT_WorkFlowEventType_Core wfc
																			where	wfc.WorkFlowEventProgramme = 'WHP Wales'
																			and		wfc.WorkFlowEventCSSRelated = 'CSS13')   ddd.[Date]
																from		DW.d_date ddd
																where		ddd.is_business_day = 1
																and			ddd.[Date] > lad.JobLeaveAddDate
																order by	ddd.[Date]) gdt)
										end									as DueDate
							from		stg.Meta_WorkflowEventsStaging		tmp
							left join	DV.LINK_Case_Assignment				lca on lca.CaseHash			= tmp.CaseHashBin
							left join	AssignmentLeaveAddedDate			lad on lad.AssignmentHash	= lca.AssignmentHash
							left join	Scenario1InWork						sc1 on sc1.CaseHash			= tmp.CaseHash
							left join	Scenario2InWork						sc2 on sc2.CaseHash			= tmp.CaseHash
							where		tmp.ProgrammeName = 'WHP Wales'
							and			tmp.StartDate is not null
							and 		(tmp.LeaveDate is null or tmp.LeaveReason = 'Particpant Returned to DWP - End of Provision')
										--	  Participant is out of work between program start date and Day 456 (Scneario 1)
										-- or participant is out of work between Day 456 and 639 (Scneario 2)
							and			(	 (lad.JobLeaveAddDate <= dateadd(dd,456,tmp.StartDate) and sc1.CaseHash is null)
										  or (lad.JobLeaveAddDate > dateadd(dd,456,tmp.StartDate)  and lad.JobLeaveAddDate < dateadd(dd,639,tmp.StartDate) and sc2.CaseHash is null)
										  or (lca.CaseHash is null and dateadd(dd,456,tmp.StartDate) <= getdate())
										)
							)			ass
				group by	ass.CaseHash)						wfe on wfe.CaseHash		= tmp.CaseHash		
	left join	(select		tmp.CaseHash						as CaseHash
							,min(ddu.UploadedDate)				as DocUploadedDate
				from		stg.Meta_WorkflowEventsStaging		tmp
				left join	DV.LINK_Case_DocumentUpload			cdu on cdu.CaseHash = tmp.CaseHashBin
				left join	DV.SAT_DocumentUpload_Adapt_Core	ddu on ddu.DocumentUploadHash = cdu.DocumentUploadHash and ddu.IsCurrent = 1
				where        (isnull(ddu.DocumentName,'')        like '%Exit%Report%'
				or            isnull(ddu.DocumentDescription,'') like '%Exit%Report%')
				group by	tmp.CaseHash)						cs13 on cs13.CaseHash	= tmp.CaseHash		
	where		tmp.ProgrammeName = 'WHP Wales'
	and			tmp.ReferralDate <= '2022-10-31'
	) qry;

set @LoadStartMessage = concat('Wales CSS 13 Time Taken = ',(select cast((getdate()-@LoadStartTime) as time(0)) '[hh:mm:ss]'))
raiserror(@LoadStartMessage, 0, 1) with nowait;
set @LoadStartTime = getdate();