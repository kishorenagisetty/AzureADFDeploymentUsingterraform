CREATE VIEW [dwh].[fact_WorkflowEvents] 
AS 
-- Author: 
-- Create date: DD/MM/YYY
-- Ticket Reference:  <Dev Ops Ticket Reference>
-- Description: <Description regarding object>
-- Revisions:
-- 12/07/2023 - <MK> - <25518> - <Exclude cases from CSS 13 where participant has only one exit report for WHP Wales>
-- 18/07/2023 - <MK> - <25518> - <Requirement is now changed to show cases as Unsuccessful and Not Excluded>
-- 06/11/2023 - <MK> - <29909> - <Pioner Wales Added for CSS 7 Exclusions>
-- 17/01/2024 - <MK> - <30981> - <Pioner Wales Added for CSS 8 Exclusions>
-- 26/01/2024 - <MK> - <30352> - <CSS 13A Exclusions Added>

select			css.CaseHashBin															as CaseHashBin
				,css.CaseHash															as CaseHash
				,css.EmployeeHashBin													as EmployeeHashBin
				,css.EmployeeHash														as EmployeeHash
				,css.EmployeeName														as EmployeeName
				,css.WorkFlowEventDate													as WorkFlowEventDate
				,css.WorkFlowEventEstimatedStartDate									as WorkFlowEventEstimatedStartDate
				,css.WorkFlowEventEstimatedEndDate										as WorkFlowEventEstimatedEndDate
				,css.InOutWork															as InOutWork
				,css.RecordSource														as RecordSource
				,css.CSSName															as CSSName
				,css.IncludeExclude														as IncludeExclude
				,case	when	css.WorkFlowEventDate is null 
								and css.WorkFlowEventEstimatedEndDate >= cast(getdate() as date) 
								and css.IncludeExclude = 'Include'
						then	1 
				 end																	as InProgress
				,case	when	css.WorkFlowEventDate is null
						then	null
						when	css.WorkFlowEventEstimatedEndDate is null
						then	null
						When    css.CSSName = 'WHP Wales  -  CSS13'								-- 18/07/23 <MK> <25518> <CSS 13 Success criteria changed as per req>
                                and css.WorkFlowEventDate <= css.WorkFlowEventEstimatedEndDate
								and css.IncludeExclude = 'Include'                                               
                                and OneExit.NoOfExits > 1 
                        then	1
						When	css.CSSName <> 'WHP Wales  -  CSS13'							-- 18/07/23 <MK> <25518> <CSS 13 Success criteria changed as per req>
                                and css.WorkFlowEventDate <= css.WorkFlowEventEstimatedEndDate
								and css.IncludeExclude = 'Include'        
						then	1
				 end																	as Successful
				,case	when	css.WorkFlowEventEstimatedEndDate is null 
						then	null
						when	css.WorkFlowEventDate is not null
								and css.WorkFlowEventDate > css.WorkFlowEventEstimatedEndDate
								and css.IncludeExclude = 'Include'
						then	1 
						when	css.WorkFlowEventDate is null
								and css.WorkFlowEventEstimatedEndDate < cast(getdate() as date) 
								and css.IncludeExclude = 'Include'
						then	1 
						when	css.CSSName = 'WHP Wales  -  CSS13'								-- 18/07/23 <MK> <25518> <CSS 13 UnSuccessful criteria changed as per req>
                                and OneExit.NoOfExits = 1
								and css.IncludeExclude = 'Include'
						then	1 
				 end																	as UnSuccessful
				,case	when	(case	when	css.WorkFlowEventDate is null 
												and css.WorkFlowEventEstimatedEndDate >= cast(getdate() as date) 
												and css.IncludeExclude = 'Include'
										then	1 
								end ) = 1 then 'InProgress'
						when	(case	when	css.WorkFlowEventDate is null
										then	null
										when	css.WorkFlowEventEstimatedEndDate is null
										then	null
										When    css.CSSName = 'WHP Wales  -  CSS13'								-- 18/07/23 <MK> <25518> <CSS 13 Success criteria changed as per req>
                                                and css.WorkFlowEventDate <= css.WorkFlowEventEstimatedEndDate
												and css.IncludeExclude = 'Include'                                               
                                                and OneExit.NoOfExits > 1 
                                        then	1
										When	css.CSSName <> 'WHP Wales  -  CSS13'							-- 18/07/23 <MK> <25518> <CSS 13 Success criteria changed as per req>
                                                and css.WorkFlowEventDate <= css.WorkFlowEventEstimatedEndDate
												and css.IncludeExclude = 'Include'        
										then	1
								 end ) = 1 then 'Successful'
						when	(case	when	css.WorkFlowEventEstimatedEndDate is null 
										then	null
										when	css.WorkFlowEventDate is not null
												and css.WorkFlowEventDate > css.WorkFlowEventEstimatedEndDate
												and css.IncludeExclude = 'Include'
										then	1 
										when	css.WorkFlowEventDate is null
												and css.WorkFlowEventEstimatedEndDate < cast(getdate() as date) 
												and css.IncludeExclude = 'Include'
										then	1 
										when	css.CSSName = 'WHP Wales  -  CSS13'								-- 18/07/23 <MK> <25518> <CSS 13 UnSuccessful criteria changed as per req>
                                                and OneExit.NoOfExits = 1
								                and css.IncludeExclude = 'Include'
						                then	1 
								 end ) = 1 then 'UnSuccessful'
						when	css.IncludeExclude = 'Exclude'
								then 'Excluded'
						else	'Excluded'
				end																		as CSSStatus
				,case	when	css.WorkFlowEventEstimatedEndDate = cast(getdate() + 1 as date)
								and css.WorkFlowEventDate is null
								and css.IncludeExclude = 'Include'
						then	1
				 end																	as DueNext24Hours
				,row_number() over (order by css.CaseHashBin)							as UniqueWFID
from
(
select			wmc.CaseHashBin															as CaseHashBin
				,wmc.CaseHash															as CaseHash
				,wmc.EmployeeHashBin													as EmployeeHashBin
				,isnull(wmc.EmployeeHash,cas.EmployeeHash)								as EmployeeHash
				,isnull(em1.EmployeeName,em2.EmployeeName)								as EmployeeName
				,wmc.WorkFlowEventDate													as WorkFlowEventDate
				,wmc.WorkFlowEventEstimatedStartDate									as WorkFlowEventEstimatedStartDate
				,wmc.WorkFlowEventEstimatedEndDate										as WorkFlowEventEstimatedEndDate
				,wmc.InOutWork															as InOutWork
				,wmc.RecordSource														as RecordSource
				,wmc.CSSName															as CSSName
				,case 
					when	wmc.CSSName = 'WHP Wales  -  CSS1' 
							and (cas.LeaveDate is not null and cas.StartDate is null) 
					then	'Exclude'
					when	wmc.CSSName = 'WHP Wales  -  CSS6' 
							and (cas.StartDate is null) 
					then	'Exclude'
					when	wmc.CSSName In  ('WHP Wales  -  CSS7', 'Pioneer Wales  -  CSS7') -- <MK> <29909> <Pioner Wales Added>
							and ((cas.LeaveDate is not null and cas.StartDate is null)
							or (cas.LeaveDate is null and cas.StartDate is null))
					then	'Exclude'
					when	wmc.CSSName In ('WHP Wales  -  CSS8', 'Pioneer Wales  -  CSS8') -- <MK> <30981> <Pioneer Wales Added>
							and dis.IsDisengaged is not null--Exclude because disengaged
					then	'Exclude' 
					when	wmc.CSSName In ('WHP Wales  -  CSS8', 'Pioneer Wales  -  CSS8') -- <MK> <30981> <Pioneer Wales Added>
							and cas.StartDate is null --Exclude because off programme
					then	'Exclude' 
					when	wmc.CSSName In ('WHP Wales  -  CSS8', 'Pioneer Wales  -  CSS8') -- <MK> <30981> <Pioneer Wales Added>
							and cas.LeaveDate is not null --Exclude because off programme
					then	'Exclude' 
					when	wmc.CSSName In ('WHP Wales  -  CSS8', 'Pioneer Wales  -  CSS8') -- <MK> <30981> <Pioneer Wales Added>
							and cas.LastJobLeaveDate is null and FirstJobStartDate is not null --Exclude because still in work 
					then	'Exclude'
					when	wmc.CSSName = 'WHP Wales  -  CSS9' 
							and (cas.IsDisengaged is not null      --Exclude because disengaged
							or (cas.LastJobLeaveDate is null and FirstJobStartDate is not null) --Exclude because still in work
							or cas.LeaveDate is not null)		   --Exclude because programme leaver
					then	'Exclude'
					when	wmc.CSSName = 'WHP Wales  -  CSS10' 
							and dis.IsDisengaged is not null
					then	'Exclude' 
					when	wmc.CSSName = 'WHP Wales  -  CSS10'
							and cas.LeaveDate is not null 
							and cas.FirstJobStartDate is not null
							and dis.IsDisengaged is not null
					then	'Exclude'
					when	wmc.CSSName = 'WHP Wales  -  CSS12' 
							and dis.IsDisengaged is not null--Exclude because disengaged
					then	'Exclude' 
					when	wmc.CSSName = 'WHP Wales  -  CSS12' 
							and cas.StartDate is null --Exclude because off programme
					then	'Exclude' 
					when	wmc.CSSName = 'WHP Wales  -  CSS12' 
							and cas.LeaveDate is not null --Exclude because off programme
					then	'Exclude' 
					when	wmc.CSSName = 'WHP Wales  -  CSS12' 
							and cas.LastJobLeaveDate is not null --Exclude because not in work
					then	'Exclude'
					when	wmc.CSSName = 'WHP Wales  -  CSS13A'  -- 26/01/24 <MK> <30352> 
							and excl.CaseHashBin is not null	  -- Exclude bec's Terminally ill or Passed Away Or Moved out of UK
					Then    'Exclude'
					when	wmc.CSSName = 'WHP London  -  CSS6' 
							and (dis.IsDisengaged is not null
							or cas.LeaveDate is not null)
					then	'Exclude'
					when	wmc.CSSName = 'WHP London  -  CSS7' 
							and (dis.IsDisengaged is not null
							or cas.LeaveDate is not null)
					then	'Exclude'
					when	wmc.CSSName = 'WHP London  -  CSS8' 
							and (dis.IsDisengaged is not null
							or cas.LeaveDate is not null)
					then	'Exclude'
					when	wmc.CSSName = 'WHP London  -  CSS9' 
							and (cas.IsDisengaged is not null    --Exclude because disengaged
							or (cas.LastJobLeaveDate is null and FirstJobStartDate is not null) --Exclude because still in work
							or cas.LeaveDate is not null)
					then	'Exclude'
					when	wmc.CSSName = 'WHP London  -  CSS10' 
							and (dis.IsDisengaged is not null
							or cas.LeaveDate is not null)
					then	'Exclude' 
					when	wmc.CSSName = 'WHP London  -  CSS11' 
							and (cas.IsDisengaged is not null    --Exclude because disengaged
							or (cas.LastJobLeaveDate is null and FirstJobStartDate is not null) --Exclude because still in work
							or cas.LeaveDate is not null)
					then	'Exclude'
					when	wmc.CSSName = 'WHP London  -  CSS12' 
							and (cas.IsDisengaged is not null    --Exclude because disengaged
							or (cas.LastJobLeaveDate is null and FirstJobStartDate is not null) --Exclude because still in work
							or cas.LeaveDate is not null)
					then	'Exclude'
					when	wmc.CSSName = 'WHP London  -  CSS14' 
							and ((cas.LastJobLeaveDate is null and FirstJobStartDate is not null) --Exclude because still in work
							or cas.LeaveDate is not null)
					then	'Exclude'
					when	wmc.CSSName = 'WHP London  -  CSS15' 
							and (dis.IsDisengaged is not null --Exclude because disengaged
							or cas.LeaveDate is not null)
					then	'Exclude'
					when	wmc.CSSName = 'WHP London  -  CSS16' 
							and (cas.IsDisengaged is not null    --Exclude because disengaged
							or cas.LastJobLeaveDate is not null --Exclude because job leaver
							or cas.LeaveDate is not null)
					then	'Exclude'
					when	wmc.CSSName = 'WHP London  -  CSS17' 
							and (cas.IsDisengaged is not null    --Exclude because disengaged
							or (cas.LastJobLeaveDate is null and FirstJobStartDate is not null)) --Exclude because still in work
							--or cas.LeaveDate is not null)
					then	'Exclude'
					else	'Include'
				end														as IncludeExclude
from			DV.SAT_WorkFlowEvents_Meta_Core_New						wmc
join			dwh.fact_case											cas on cas.CaseHashBin = wmc.CaseHashBin
left join		dwh.dim_Employee										em1 on em1.EmployeeHash = wmc.EmployeeHash
left join		dwh.dim_Employee										em2 on em2.EmployeeHash	= cas.EmployeeHash
left join		(select		distinct bar.CaseHash,1	as IsDisengaged
				from		dwh.fact_Barrier			bar
				where		bar.BarrierIsDisengagement	= 1
				and			bar.IsOpenBarrier = 1)						dis on dis.CaseHash =  cas.CaseHash
 Left join ( Select CaseHashBin
			From stg.Meta_WorkflowEventsStaging	
			Where LeaveReason in ('Deceased (Early Completer)','Health Issues ie Terminal Condition','Participant Moved Out of UK')
			Group by CaseHashBin
			) excl														on wmc.CaseHashbin = excl.CaseHashBin
--Where			convert(char(66),cas.CaseHash,1) <> '0x0000000000000000000000000000000000000000000000000000000000000000'				-- 18/07/23 <MK> <25518> <Added this to remove default blank casehash>
) css
Left Join		(select			tmp.CaseHash							as CaseHash,
				Count(distinct cdu.DocumentUploadHash)					as NoOfExits
				from	stg.Meta_WorkflowEventsStaging					tmp
				join	DV.LINK_Case_DocumentUpload						cdu on cdu.CaseHash = tmp.CaseHashBin
				join	DV.SAT_DocumentUpload_Adapt_Core				ddu on ddu.DocumentUploadHash = cdu.DocumentUploadHash and ddu.IsCurrent = 1
				where       
				tmp.ProgrammeName = 'WHP Wales'
				and
				(isnull(ddu.DocumentName,'')        like '%Exit%Report%'
				or isnull(ddu.DocumentDescription,'') like '%Exit%Report%')
				group by	tmp.CaseHash
				
				)														OneExit On OneExit.CaseHash = css.CaseHash