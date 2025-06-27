CREATE VIEW [dwh].[dim_Fact_AssignmentEarnings] 
AS 
-- Author: 
-- Create date: DD/MM/YYY
-- Ticket Reference:  <Dev Ops Ticket Reference>
-- Description: <Description regarding object>
-- Revisions:
-- 16/08/2023 - <MK> - <25421> - <Earnings Threshold is now gone up to 4334.72 which rounded to 4335 as agreed with Paul Walters>
select
	Casehash
	,min(WorkingDayKey) as ProjectedOutcomeDate
from
	(select
		Casehash
		,WorkingDayKey
		,(Working_Hours * Hourly_Rate) Earnings
		,sum((Working_Hours * Hourly_Rate)) over(partition by CaseHash order by WorkingDayKey) as cuml
	from 
		DV.Fact_AssignmentEarnings
	where 
		([Working_Hours] * [Hourly_Rate]) <> 0 ) as a
WHERE
	cuml >= 4335 -- 16/08/23 <MK> <25421>
group by 
	Casehash

union all

--Now to manage those that will not pass thrreshold in the next 12 months.  Rather than chooing an arbitarty year and expanng each assignment out by day that far we'll just estiamte based on weekly
--rate and weeks to threshold
select
	a.CaseHash
	--below calulation finds how much is left to get to threshold (accounting for past and next 12 months earnings as per fact table), then dividing that 'remaining' total by current open assignment
	--weekly rate (this is aggregated as participants may have more than one current assingment.  Then we add the cumber of weeks remaing to the current upto date (usually a year from today) and 
	--format to yyyymmmdd to match above (original query) output of projected date.  This is more an esitimate and dependant on day of the wek run and employment schedules may be a week out.  But as
	--the by day calculation in fact table is a year in advance the margin for error on the more basic calculation here is acceptable.
	--Added case statement as one instance had more weeks than there are until 31st Dec 9999 so caused overflow in data add function.
	,case
		when ceiling((4335 - a.total_earnings_in_period) / sum(c.HourlyRate * c.WeeklyHours)) > 100000 then '30000101'
		else format(dateadd(week, ceiling((4335 - a.total_earnings_in_period) / sum(c.HourlyRate * c.WeeklyHours)), cast(cast(a.upto_date as varchar) as date)), 'yyyyMMdd') 
	end as ProjectedOutcomeDate
from
	(select  --taking all of those in the by day fact table (DV.Fact_AssignmentEarnings) that will not pass threshold in 12 months
		caseHash
		,max(workingDayKey) as upto_date
		,sum(working_hours * hourly_rate) as total_earnings_in_period  --using the calculation of total earning as far as it goes
	from
		DV.Fact_AssignmentEarnings
	group by
		caseHash
	having
		sum(working_hours * hourly_rate) < 4335) as a
left outer join
	(select  --gets all earning patterns and associated cases to innner join above query which identifies those that will not hit threshold in next 12 months
		hr.AssignmentEarningPatternHash
		,hr.AssignmentEarningPatternKey
		,a.AssignmentHash
		,ca.CaseHash
		,hr.Reference
		,hr.EffectFrom
		,coalesce(hr.EffectTo, a.WorkTrialEndDate)  as EffectTo
		,hr.HourlyRate
		,hr.WeeklyHours
		,md.description as 'Status'
	from 
		DV.SAT_AssignmentEarningPattern_Adapt_Core hr
	inner join 
		DV.Dimension_References md 
	on	md.code = hr.status
	left outer join 
		dv.link_Assignment_AssignmentEarningPattern as l 
	on	hr.AssignmentEarningPatternHash = l.AssignmentEarningPatternHash
	left outer join 
		dv.SAT_Assignment_Adapt_Core as a 
	on	l.AssignmentHash = a.AssignmentHash 
	and hr.IsCurrent = a.IsCurrent
	left outer join
		DV.link_case_assignment as ca
	on
		a.AssignmentHash = ca.AssignmentHash
	where
		hr.iscurrent = 1
	and md.[description] <> 'Soft Deleted') as c
on
	convert(char(66), a.caseHash, 1) = convert(char(66), c.caseHash, 1)
where
	EffectTo is null  --only want existing assignments
and (hourlyRate * weeklyHours) > 0 --and only assignments that pay
group by
	a.CaseHash
	,a.upto_date
	,a.total_earnings_in_period;