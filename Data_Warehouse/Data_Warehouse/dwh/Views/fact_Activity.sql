CREATE VIEW [dwh].[fact_Activity] AS select			'ADAPT.PROP_ACTIVITY_GEN'													as RecordSource
				,cas.CaseHash																as CaseHash
				,convert(char(66),isnull(aac.ActivityHash,cast(0x0 as binary(32))),1)		as ActivityHash
				,convert(char(66),isnull(hashbytes('SHA2_256',cast(aac.ActivityType as varchar)),cast(0x0 as binary(32))),1)	as ActivityTypeHash
				,convert(char(66),isnull(hashbytes('SHA2_256',cast(aac.ActivityStatus as varchar)),cast(0x0 as binary(32))),1)	as ActivityStatusHash
				,nullif(mu1.Description,'')													as ActivityStatus
				,cast(aac.ActivityStartDate as date)										as ActivityStartDate
				,cast(aac.ActivityCompleteDate as date)										as ActivityCompleteDate
				,cast(aac.ActivityDueDate as date)											as ActivityDueDate
				,case when cast(aac.ActivityDueDate as date) is not null then
					(select		count(ddd.[Date_Skey]) 
					from		dwh.dim_Date ddd 
					where		ddd.[Date] > cast(aac.ActivityDueDate as date) 
					and			ddd.[Date] <= isnull(cast(aac.ActivityCompleteDate as date),getdate())
					and			Is_Business_Day = 1)
				 end																		as ActivityWorkingDaysDueDateToCompleteOrToday
				,aac.ActivityIsMandatory													as ActivityIsMandatory
				,aac.ActivityIsLTURelated													as ActivityIsLTURelated
				,aac.ActivityIsNEORelated													as ActivityIsNEORelated
				,aac.ActivityHoursScheduled * 60											as BookedDurationMinutes
				,convert(char(66),isnull(par.ParticipantHash ,cast(0x0 as binary(32))),1)	as ParticipantHash
				,aac.ActivityName															as ActivityName
				,nullif(mu2.Description,'')													as ActivityContactMethod
				,nullif(mu3.Description,'')													as ActivityType
				,case	when cast(aac.ActivityDueDate as date) is null then null
						when cast(aac.ActivityDueDate as date) <= cast(getdate() as date)
							 and cast(aac.ActivityCompleteDate as date) is null
							 and nullif(mu1.Description,'') = 'Overdue' --This was cas.CaseStatus
							 and cas.LeaveDate is null then 1
				 end																		as ActivityIsOverdue
				,case	when cast(aac.ActivityDueDate as date) >= cast(getdate() as date) 
							 and cast(aac.ActivityCompleteDate as date) is null then 1
				 end																		as ActivityIsInFuture
				,case	when cast(aac.ActivityDueDate as date) = cast(getdate() as date) then 1
				 end																		as ActivityIsduetodayflag
				,case	when cast(aac.ActivityStartDate as date) >= cast(getdate() -10 as date) then 1
						when cast(aac.ActivityCompleteDate as date) >= cast(getdate() -10 as date) then 1
				 end																		as IsActivityInLast10Days
				,case	when aac.ActivityName = 'Work First Appraisal'
							 and cast(aac.ActivityCompleteDate as date) is not null then 1
				 end																		as CompletedWorkFirstAppraisal
				,case	when aac.ActivityName = 'Workplace Plan Appointment'
							 and cast(aac.ActivityDueDate as date) is not null then 1
				 end																		as EstimatedWPPDate
				,case	when aac.ActivityName = 'Workplace Plan Appointment'
							 and cast(aac.ActivityCompleteDate as date) is not null then 1
				 end																		as CompletedWPPDate
from			dwh.fact_Case								cas
join			DV.LINK_Case_Activity						lac on lac.casehash		= cas.CaseHashBin
join			DV.LINK_Case_Participant					par	on par.CaseHash		= cas.CaseHashBin
join			(select		saa.*
							,row_number() over (partition by saa.ActivityHash order by saa.ActivityHash, saa.ActivityCompleteDate desc, saa.ActivityDueDate desc, saa.ActivityStartDate desc) as rn
				from		DV.SAT_Activity_Adapt_Core		saa
				where		saa.IsCurrent = 1)				aac on aac.ActivityHash	= lac.ActivityHash			and aac.rn = 1
left join		DV.SAT_Entity_SoftDelete_Adapt_Core			sda on sda.EntityHash	= aac.ActivityHash			and sda.IsCurrent = 1
left join		DV.SAT_References_MDMultiNames				mu1 on mu1.ID			= aac.ActivityStatus		and mu1.IsCurrent = 1  and mu1.Type = 'Code'
left join		DV.SAT_References_MDMultiNames				mu2 on mu2.ID			= aac.ActivityContactMethod	and mu2.IsCurrent = 1  and mu2.Type = 'Code'
left join		DV.SAT_References_MDMultiNames				mu3 on mu3.ID			= aac.ActivityType			and mu3.IsCurrent = 1  and mu3.Type = 'Code'
where			sda.EntityKey is null;