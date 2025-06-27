CREATE VIEW [BV].[SAT_AssignmentEarningPattern_Iconi_Core]
AS with

cte_job_level_outcome as (

	SELECT [EngID]
	,Outcome_id
	,[eng_tran_individual_id]
		  ,[most_recent_job_start]
		  ,[most_recent_job_start_type] = CASE WHEN most_recent_job_start = 1 THEN ISNULL([out_job_type],'Employed') ELSE NULL END
		  ,[out_earn_entity_id]
		  ,[out_earn_salary_amount]
		  ,LEFT([out_earn_salary_unit],20) [out_earn_salary_unit]
		  ,[out_earn_hours_per_week]
		  ,[out_earn_hours_per_day] = ([out_earn_hours_per_week] / 5)
		  ,[out_earn_hourly_rate] = isnull(([EDR] /(nullif([out_earn_hours_per_week],0) / 5)),0)
		  ,[out_earn_date_from]
		  ,[out_earn_date_to]
		  ,[eng_left_date]
		  ,[out_earn_elapsed_days] = CASE WHEN DATEDIFF(DAY,[out_earn_date_from],CASE WHEN [out_earn_date_to]='1900-01-01' THEN GETDATE() ELSE [out_earn_date_to] END)=0 THEN
										(DATEDIFF(DAY,[out_earn_date_from],CASE WHEN [out_earn_date_to]='1900-01-01' THEN GETDATE() ELSE [out_earn_date_to] END)+1)
									ELSE
										(DATEDIFF(DAY,[out_earn_date_from],CASE WHEN [out_earn_date_to]='1900-01-01' THEN GETDATE() ELSE [out_earn_date_to] END))
									END
		  ,[EDR]
		  ,[EarningsToDate]
		  ,[total_earnings_to_date] = sum([EarningsToDate]) over (partition by eng_tran_individual_id)

	FROM (

		SELECT 'ENG'+cast(src.[engagement_id] as varchar) as [EngID]
		      ,outcome_id
			  ,src.[eng_tran_individual_id]
			  ,[most_recent_job_start] = rank() over (partition by engagement_id, eng_tran_individual_id order by out_earn_date_from desc)
			  ,row_number() over (partition by src.engagement_id, out_earn_entity_id order by outcome_earnings_id desc) rn
			  ,src.[out_job_type]
			  ,[out_earn_entity_id]
			  ,[out_earn_salary_amount]
			  ,[out_earn_salary_unit]
			  ,[out_earn_hours_per_week]
			  ,[out_earn_date_from]
			  ,[out_earn_date_to]
			  ,src.[eng_left_date]
			  ,CASE 
			  WHEN out_earn_salary_unit='Hourly'
			  THEN
					([out_earn_hours_per_week]/7) * [out_earn_salary_amount]
			   WHEN out_earn_salary_unit ='Weekly' 
			   THEN
					[out_earn_salary_amount]/7
			   WHEN out_earn_salary_unit  ='Fortnightly' 
			   THEN
					[out_earn_salary_amount]/14

 

			   WHEN out_earn_salary_unit  ='Monthly' 
			   THEN
					[out_earn_salary_amount]/30

 

			 WHEN out_earn_salary_unit  ='Yearly' 
			   THEN
					([out_earn_salary_amount]/12)/30

 

			 WHEN out_earn_salary_unit  ='Daily' 
			   THEN
					([out_earn_hours_per_week]/7.5/7) * [out_earn_salary_amount]

 

			  END as EDR,
			  CASE WHEN out_earn_salary_unit ='Hourly'
			  THEN
					CASE WHEN DATEDIFF(DAY,[out_earn_date_from],CASE WHEN [out_earn_date_to]='1900-01-01' THEN GETDATE() ELSE [out_earn_date_to] END)=0 THEN
							(([out_earn_hours_per_week]/7) * (DATEDIFF(DAY,[out_earn_date_from],CASE WHEN [out_earn_date_to]='1900-01-01' THEN GETDATE() ELSE [out_earn_date_to] END)+1)) * ([out_earn_salary_amount])
						ELSE
							(([out_earn_hours_per_week]/7) * (DATEDIFF(DAY,[out_earn_date_from],CASE WHEN [out_earn_date_to]='1900-01-01' THEN GETDATE() ELSE [out_earn_date_to] END))) * ([out_earn_salary_amount])
					END

 

					WHEN out_earn_salary_unit ='Weekly' THEN

 

					CASE WHEN DATEDIFF(DAY,[out_earn_date_from],CASE WHEN [out_earn_date_to]='1900-01-01' THEN GETDATE() ELSE [out_earn_date_to] END)=0 THEN
							(([out_earn_salary_amount]/7) * (DATEDIFF(DAY,[out_earn_date_from],CASE WHEN [out_earn_date_to]='1900-01-01' THEN GETDATE() ELSE [out_earn_date_to] END)+1)) 
						ELSE
							(([out_earn_salary_amount]/7) * (DATEDIFF(DAY,[out_earn_date_from],CASE WHEN [out_earn_date_to]='1900-01-01' THEN GETDATE() ELSE [out_earn_date_to] END))) 
					END

 

					WHEN out_earn_salary_unit ='Fortnightly' THEN

 

					CASE WHEN DATEDIFF(DAY,[out_earn_date_from],CASE WHEN [out_earn_date_to]='1900-01-01' THEN GETDATE() ELSE [out_earn_date_to] END)=0 THEN
							(([out_earn_salary_amount]/14) * (DATEDIFF(DAY,[out_earn_date_from],CASE WHEN [out_earn_date_to]='1900-01-01' THEN GETDATE() ELSE [out_earn_date_to] END)+1)) 
						ELSE
							(([out_earn_salary_amount]/14) * (DATEDIFF(DAY,[out_earn_date_from],CASE WHEN [out_earn_date_to]='1900-01-01' THEN GETDATE() ELSE [out_earn_date_to] END))) 
					END

 


					WHEN out_earn_salary_unit ='Monthly' THEN

 

					CASE WHEN DATEDIFF(DAY,[out_earn_date_from],CASE WHEN [out_earn_date_to]='1900-01-01' THEN GETDATE() ELSE [out_earn_date_to] END)=0 THEN
							(([out_earn_salary_amount]/30) * (DATEDIFF(DAY,[out_earn_date_from],CASE WHEN [out_earn_date_to]='1900-01-01' THEN GETDATE() ELSE [out_earn_date_to] END)+1)) 
						ELSE
							(([out_earn_salary_amount]/30) * (DATEDIFF(DAY,[out_earn_date_from],CASE WHEN [out_earn_date_to]='1900-01-01' THEN GETDATE() ELSE [out_earn_date_to] END))) 
					END

 

						WHEN out_earn_salary_unit ='Yearly' THEN

 

					CASE WHEN DATEDIFF(DAY,[out_earn_date_from],CASE WHEN [out_earn_date_to]='1900-01-01' THEN GETDATE() ELSE [out_earn_date_to] END)=0 THEN
							((([out_earn_salary_amount]/12)/30) * (DATEDIFF(DAY,[out_earn_date_from],CASE WHEN [out_earn_date_to]='1900-01-01' THEN GETDATE() ELSE [out_earn_date_to] END)+1)) 
						ELSE
							((([out_earn_salary_amount]/12)/30) * (DATEDIFF(DAY,[out_earn_date_from],CASE WHEN [out_earn_date_to]='1900-01-01' THEN GETDATE() ELSE [out_earn_date_to] END))) 
					END

 

					 WHEN out_earn_salary_unit ='Daily'
			  THEN
					CASE WHEN DATEDIFF(DAY,[out_earn_date_from],CASE WHEN [out_earn_date_to]='1900-01-01' THEN GETDATE() ELSE [out_earn_date_to] END)=0 THEN
							(([out_earn_hours_per_week]/7.5/7) * (DATEDIFF(DAY,[out_earn_date_from],CASE WHEN [out_earn_date_to]='1900-01-01' THEN GETDATE() ELSE [out_earn_date_to] END)+1)) * ([out_earn_salary_amount])
						ELSE
							(([out_earn_hours_per_week]/7.5/7) * (DATEDIFF(DAY,[out_earn_date_from],CASE WHEN [out_earn_date_to]='1900-01-01' THEN GETDATE() ELSE [out_earn_date_to] END))) * ([out_earn_salary_amount])
					END

			  END as EarningsToDate

	FROM (
		  	select
			engagement_id
			, eng_tran_individual_id
			, eng_left_date
			, out_engagement_id
			, out_employer_organisation_id
			, out_date
			, out_job_type
			, out_site_id
			, outcome_id
			, out_advisor_user_id
			, out_left_date
			, out_reason_for_leaving
			, out_added_date
			from (
				select 
					engagement_id
					, eng_tran_individual_id
					, eng_left_date
					, out_engagement_id
					, out_employer_organisation_id
					, out_date
					, out_job_type
					, out_site_id
					, outcome_id
					, out_advisor_user_id
					, out_left_date
					, out_reason_for_leaving
					, out_added_date
					, rn = 	row_number() over (partition by out_engagement_id, out_employer_organisation_id, out_date ORDER BY outcome_id DESC)
				from [ICONI].[vBIRestart_Outcome] job
				inner join [ICONI].[vBIRestart_Engagement] eng 
				on job.out_engagement_id = eng.engagement_id
				where out_type='Job Start'
				) rnk
			where (rn = 1)
		) src
		INNER JOIN [ICONI].[vBICommon_Outcome_Earnings]			[out_earn]
		ON [out_earn].out_earn_entity_id = src.outcome_id

) s
WHERE (rn = 1)
),

final as (
SELECT
	
CONCAT_WS('|','ICONI', CAST(Outcome_id AS INT)) as AssignmentKey
,[projected_outcome_date] =  cast(cast(format(MAX(CASE 
									WHEN [most_recent_job_start_type] = 'Self Employed' AND [most_recent_job_start] = 1  THEN
										CASE 
										WHEN DATEDIFF(dd, [out_earn_date_from], ISNULL([eng_left_date],[out_earn_date_to])) <= 181 THEN NULL --check length of position against eng_left_Date and out_earn_Date_to (if less than 181 then outcome is NULL)
										ELSE Dateadd(dd, ceiling((3706.56 - [total_earnings_to_date]) / [EDR]), cast(getDate() as Date))
										END
									WHEN [most_recent_job_start_type] = 'Employed' AND [most_recent_job_start] = 1 THEN
										CASE 
										WHEN ISNULL([EDR],0) = 0 THEN NULL
										WHEN [eng_left_date] IS NOT NULL THEN NULL
										ELSE Dateadd(dd, ceiling((3706.56 - [total_earnings_to_date]) / [EDR]),  cast(getDate() as Date))
										END
									END),'yyyymmdd') as varchar(8)) as int)
,MAX(round([total_earnings_to_date],2)) as [total_earnings_to_date]


FROM cte_job_level_outcome
WHERE [most_recent_job_start] = 1
GROUP BY outcome_id)
,
[months] as
(
select
Month_Name_Long,
max(Day_Of_Month) as Days_In_Month
from
DW.D_Date
where
Month_Number between 1 and 12
group by
Month_Name_Long
)
,

february as
(
select 
Year_Number,
max(Day_Of_Month) as Days_In_Month
from
DW.D_Date d 
where month_name_long = 'February'
group by 
Year_Number
),

[Dates] as
(
select
[Date],
Day_Name_Long,
d.month_name_long,
Day_Of_Month,
F.days_in_month,
d.Month_Number,
d.Year_Number

from
DW.D_Date d 
join months m on 
m.month_Name_long = d. month_name_long
join february F on
F.Year_Number = d.Year_Number
where
Day_Name_Long in
('Monday',
'Tuesday',
'Wednesday',
'Thursday',
'Friday',
'Saturday',
'Sunday')
)
,

monthdata_prelim as
(
select distinct
I.AssignmentEarningPatternKey,
EarningPatternEffectiveFrom,
case when EarningPatternEffectiveTo = '1900-01-01' then cast(getDate() as Date) else EarningPatternEffectiveTo end as EarningPatternEffectiveTo


from
DV.SAT_AssignmentEarningPattern_Iconi_Core I
left join Dates d on 
d.Date between EarningPatternEffectiveFrom and case when EarningPatternEffectiveTo = '1900-01-01' then cast(getDate() as Date) else EarningPatternEffectiveTo end
--where I.AssignmentEarningPatternKey = 'ICONI|97'
)
,


monthData as
(
select distinct
I.AssignmentEarningPatternKey,
case when Datefromparts(d.Year_Number,d.Month_Number,01) < mdp.EarningPatternEffectiveFrom then mdp.EarningPatternEffectiveFrom else Datefromparts(d.Year_Number,d.Month_Number,01) end as EarningPatternEffectiveFrom,
case when Datefromparts(d.Year_Number,d.Month_Number,d.Days_In_Month) > mdp.EarningPatternEffectiveto then mdp.EarningPatternEffectiveto else Datefromparts(d.Year_Number,d.Month_Number,d.Days_In_Month) end as EarningPatternEffectiveTo,
d.month_name_long,
d.Month_Number,
d.Year_Number,
d.days_in_month

from
DV.SAT_AssignmentEarningPattern_Iconi_Core I
left join monthdata_prelim mdp on
mdp.AssignmentEarningPatternKey = I.AssignmentEarningPatternKey
left join Dates d on
d.Date between mdp.EarningPatternEffectiveFrom 
and
mdp.EarningPatternEffectiveTo
--where I.assignmentkey = 'ICONI|97'
where d.Year_Number is not null
),


AssignmentHash as (
Select 
distinct
a.AssignmentEarningPatternHash,
c.AssignmentHash
		
	
FROM 
DV.SAT_AssignmentEarningPattern_Iconi_Core as a
LEFT JOIN
[DV].[LINK_Assignment_AssignmentEarningPattern] as c
ON a.AssignmentEarningPatternhash = c.AssignmentEarningPatternhash
LEFT JOIN
DV.SAT_Assignment_Iconi_Core as b
on c.AssignmentHash = b.AssignmentHash)


select
distinct
ISNULL(E.AssignmentEarningPatternHash,CAST(0x0 AS BINARY(32))) as AssignmentEarningPatternHash,
ISNULL(A.AssignmentHash,CAST(0x0 AS BINARY(32))) AS [AssignmentHash],
I.AssignmentEarningPatternKey,
AEP.AssignmentKey,
'ICONI' as Programme,
I.EarningPatternPaymentFrequency,
cast(I.EarningPatternPaymentAmount as numeric(18,2)) as EarningPatternPaymentAmount,
isnull(EarningPatternDaysPerWeek,7) as EarningPatternDaysPerWeek,
md.month_name_long as MonthOfYear,
cast(I.EarningPatternWeeklyHours/isnull(EarningPatternDaysPerWeek,7) as numeric(4,2)) as EarningPatternDailyHours,
cast(isnull(F.[total_earnings_to_Date],0.00) as numeric (18,2)) as EarningsToDate,
I.EarningPatternWeeklyHours,
d.Day_Name_Long as EarningsPatternDayOfWeek,
	CASE 
		WHEN d.Day_Name_Long = 'Monday' THEN 1
		WHEN d.Day_Name_Long = 'Tuesday' THEN 2
		WHEN d.Day_Name_Long = 'Wednesday' THEN 3
		WHEN d.Day_Name_Long = 'Thursday' THEN 4
		WHEN d.Day_Name_Long = 'Friday' THEN 5
		WHEN d.Day_Name_Long = 'Satdurday' THEN 6
		WHEN d.Day_Name_Long = 'Sunday' THEN 7
		END AS DayNumber,
cast(
round(
case when I.EarningPatternPaymentFrequency = 'Yearly' then I.EarningPatternPaymentAmount / 365 -- right
when I.EarningPatternPaymentFrequency = 'Monthly' then I.EarningPatternPaymentAmount / md.days_in_month -- right
when I.EarningPatternPaymentFrequency = 'Weekly' then I.EarningPatternPaymentAmount /isnull(EarningPatternDaysPerWeek,7)  -- right
when I.EarningPatternPaymentFrequency = 'Daily' then I.EarningPatternPaymentAmount -- right
when I.EarningPatternPaymentFrequency = 'Hourly' then I.EarningPatternPaymentAmount * (I.EarningPatternWeeklyHours/isnull(EarningPatternDaysPerWeek,7)) -- right
END
,2)
as float ) as EarningPatternDailyRate,
'Averaged' as EarningPatternDailyRateType,
md.EarningPatternEffectiveFrom,
md.EarningPatternEffectiveTo,
DateDiff(dd,md.EarningPatternEffectiveFrom,md.EarningPatternEffectiveTo) + 1 as [EarningPatternDays],
'' as JobStartDate,
'' as JobLeaveDate,
0 as IsFurlough,

		CASE
		WHEN CAST(F.[total_earnings_to_Date] AS DECIMAL(15,2))*Cast(DateDiff(dd,md.EarningPatternEffectiveFrom,md.EarningPatternEffectiveTo) + 1 AS INT) is null or CAST(F.[total_earnings_to_Date] AS DECIMAL(15,2))*Cast(DateDiff(dd,md.EarningPatternEffectiveFrom,md.EarningPatternEffectiveTo) + 1 AS INT) = 0 THEN 'No Earnings'
		WHEN CAST(F.[total_earnings_to_Date] AS DECIMAL(15,2))*Cast(DateDiff(dd,md.EarningPatternEffectiveFrom,md.EarningPatternEffectiveTo) + 1 AS INT) > 0 and CAST(F.[total_earnings_to_Date] AS DECIMAL(15,2))*Cast(DateDiff(dd,md.EarningPatternEffectiveFrom,md.EarningPatternEffectiveTo) + 1 AS INT) < 1000 THEN 'Less than £1000'
		WHEN CAST(F.[total_earnings_to_Date] AS DECIMAL(15,2))*Cast(DateDiff(dd,md.EarningPatternEffectiveFrom,md.EarningPatternEffectiveTo) + 1 AS INT) >= 1000 and CAST(F.[total_earnings_to_Date] AS DECIMAL(15,2))*Cast(DateDiff(dd,md.EarningPatternEffectiveFrom,md.EarningPatternEffectiveTo) + 1 AS INT) < 2000 THEN 'Less than £1000'
		WHEN CAST(F.[total_earnings_to_Date] AS DECIMAL(15,2))*Cast(DateDiff(dd,md.EarningPatternEffectiveFrom,md.EarningPatternEffectiveTo) + 1 AS INT) > 0 and CAST(F.[total_earnings_to_Date] AS DECIMAL(15,2))*Cast(DateDiff(dd,md.EarningPatternEffectiveFrom,md.EarningPatternEffectiveTo) + 1 AS INT) < 1000 THEN 'Less than £1000'
		WHEN CAST(F.[total_earnings_to_Date] AS DECIMAL(15,2))*Cast(DateDiff(dd,md.EarningPatternEffectiveFrom,md.EarningPatternEffectiveTo) + 1 AS INT) > 2000 THEN 'Threshold Acheived'
		END	AS CaseEarningstoDateBracket,

'' as CaseHMRCEarningsBracket,
F.Projected_outcome_Date as PredictedJobOutcomeDate,
'' as CaseEarningsAtTrackingEnd


from
DV.SAT_AssignmentEarningPattern_Iconi_Core I
left join DV.HUB_AssignmentEarningPattern E on
E.AssignmentEarningPatternHash = I.AssignmentEarningPatternHash
left join [ICONI].[LINK_Assignment_AssignmentEarningPattern] AEP on
AEP.AssignmentEarningPatternKey = I.AssignmentEarningPatternkey
left join monthdata md on
md.AssignmentEarningPatternKey = I.AssignmentEarningPatternKey
left join final F on 
F.Assignmentkey = AEP.AssignmentKey
join AssignmentHash A on 
A.AssignmentEarningPatternHash = I.AssignmentEarningPatternHash

CROSS APPLY
(
SELECT distinct Day_Name_Long FROM Dates d
) d;
