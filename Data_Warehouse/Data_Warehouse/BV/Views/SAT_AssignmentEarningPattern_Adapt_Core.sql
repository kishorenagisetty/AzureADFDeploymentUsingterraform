
CREATE VIEW [BV].[SAT_AssignmentEarningPattern_Adapt_Core] AS with d1 as(
SELECT distinct 
	AssignmentEarningPatternHash AS [AssignmentEarningPatternHash],
	AssignmentKey as AssignmentKey,
	AssignmentHash as AssignmentHash,
	'ADAPT' AS Program,
	'Hourly' AS SalaryUnit,
	HourlyRate AS HourlyRate,
	WeeklyHours as HoursPerWeek,
	DailyHours AS DailyHours,

	[DayOfWeek],
	CASE 
		WHEN [DayOfWeek] = 'Monday' THEN 1
		WHEN [DayOfWeek] = 'Tuesday' THEN 2
		WHEN [DayOfWeek] = 'Wednesday' THEN 3
		WHEN [DayOfWeek] = 'Thursday' THEN 4
		WHEN [DayOfWeek] = 'Friday' THEN 5
		WHEN [DayOfWeek] = 'Saturday' THEN 6
		WHEN [DayOfWeek] = 'Sunday' THEN 7
		END AS DayNumber,
	CAST(HourlyRate*DailyHours AS DECIMAL(15,2)) AS DailyRate,
	'Actual' AS DailyRateType,
	CAST(EffectFrom AS DATE) as EffectFrom,
	CAST(EffectTo AS DATE) AS EffectTo,
	DATEDIFF(Day,EffectFrom,ISNULL(EffectTo,GETDATE())) AS [Days],
	JobStartDate AS JobStartDate,
	JobLeaveDate AS JobLeaveDate,
	0 AS CaseHMRCEarningsBracket,
	0 AS CaseEarningsAtTrackingEnd
FROM
	(
		Select 
		a.AssignmentEarningPatternHash,
		c.AssignmentHash,
		b.AssignmentKey,
		a.Monday,
		a.Tuesday,
		a.Wednesday,
		a.Thursday,
		a.Friday,
		a.Saturday,
		a.Sunday,
		a.HourlyRate,
		a.WeeklyHours,
		a.EffectFrom,
		a.EffectTo
		,b.AssignmentStartDate as JobStartDate,
		b.AssignmentLeaveDate AS JobLeaveDate
	
		FROM 
			DV.HUB_AssignmentEarningPattern as d 
			left join
			DV.SAT_AssignmentEarningPattern_Adapt_Core as a
			on d.AssignmentEarningPatternHash = a.AssignmentEarningPatternHash
			LEFT JOIN
			[DV].[LINK_Assignment_AssignmentEarningPattern] as c
			ON a.AssignmentEarningPatternHash = c.AssignmentEarningPatternHash
			LEFT JOIN
			DV.SAT_Assignment_Adapt_Core as b
			on c.AssignmentHash = b.AssignmentHash
			) p 
		UNPIVOT
			(DailyHours FOR [DayOfWeek] IN (Monday, Tuesday, Wednesday, Thursday, Friday, Saturday, Sunday)
	) as unpvt
	),

	F1 as (
	SELECT	
		CONCAT_WS('|','ADAPT',CAST(S.Programme_ID AS INT)) AS Programme_ID
		,S.WorkStatus
		,S.AuditDateTime
		,ROW_NUMBER() OVER (PARTITION BY S.Programme_ID ORDER BY S.AuditDateTime ASC) RN
	FROM	
		ADAPT.RemployCreated_ProgrammeWorkStatusAudit	AS S
		INNER JOIN DV.SAT_Case_Adapt_Core			AS P 
		ON CONCAT_WS('|','ADAPT',CAST(S.Programme_ID AS INT)) = P.CaseKey
),
F2 as (
	SELECT	
		F1.Programme_ID
		,F1.WorkStatus
		,F2.AuditDateTime FurloughStartDate
		,F2.AuditDateTime FurloughEndDate
		,ROW_NUMBER() OVER (PARTITION BY F1.Programme_ID ORDER BY F2.AuditDateTime ASC) RN

	FROM 
		F1 AS F1
		LEFT JOIN F1 as F2
		ON F1.Programme_ID = F2.Programme_ID 
		AND F2.RN = F1.RN+1
		WHERE 
			F1.WorkStatus = 'Furlough Job Retention Scheme'
),
F3 AS (
	SELECT	
		F2.Programme_ID
		,F2.WorkStatus
		,CASE WHEN F2.RN = 1 THEN '18 Mar 2020' ELSE F2.FurloughStartDate END AS FurloughStartDate
		,F2.FurloughEndDate

	FROM F2
),
F4 as (
	SELECT	DISTINCT 
		Programme_ID	AS Programme_ID,
		[Date]			AS FurloughDate,
		0.8				AS Factor
	FROM F3
	INNER JOIN DW.D_Date P 
	ON P.[Date] >= FurloughStartDate 
	AND ([Date] <= FurloughEndDate OR FurloughEndDate IS NULL)
),
final as 
(
	SELECT	a.[AssignmentEarningPatternHash]
			,f4.FurloughDate
			,CASE	WHEN f4.FurloughDate > A.[EffectTo]
					OR f4.FurloughDate > A.JobLeaveDate
					OR f4.FurloughDate < A.JobStartDate
				THEN 0
				ELSE A.[DailyRate]
					* COALESCE(F4.Factor,1)
			END AS EarningsToDate
			
 

FROM 
	d1 as a
	LEFT JOIN
	( 
		select distinct
			max(a.AssignmentHash) as assignmentkey,
			c.CaseKey
		 
		from DV.SAT_Assignment_Adapt_Core as a 
			left join 
			DV.LINK_Case_Assignment as b
		on a.AssignmentHash = b.AssignmentHash
		LEFT JOIN DV.SAT_Case_Adapt_Core as c
		on b.CaseHash = c.CaseHash
		group by c.CaseKey
		
	) as b
	on a.AssignmentKey = b.AssignmentKey
	LEFT JOIN F4 as f4
	ON F4.Programme_ID = b.CaseKey


)

	select distinct 
    a.[AssignmentEarningPatternHash] AS [AssignmentEarningPatternHash],
	a.AssignmentHash AS [AssignmentHash],
	CONCAT_WS('|',TRIM(a.[Assignmentkey]),[DayNumber]) AS EarningsKey,
	a.AssignmentKey,
	a.Program,
	a.SalaryUnit,
	a.HourlyRate,
	5 AS EarningPatternDaysPerWeek,
	CASE WHEN DATENAME(month,a.EffectFrom) is null then 'Unknown' else  DATENAME(month,a.EffectFrom) end as MonthOfYear,
	a.DailyHours,
	CAST(b.EarningsToDate AS DECIMAL(15,2))*Cast([Days] AS INT) as EarningsToDate,
	a.HoursPerWeek,
	a.[DayOfWeek],
	a.DayNumber,
	a.DailyRate,
	a.DailyRateType,
	COALESCE(a.EffectFrom,b.furloughdate) AS EffectFrom,
	CASE WHEN CAST(a.EffectTo AS DATE)  is null then CAST('1900-01-01' AS DATE) else  CAST(a.EffectTo AS DATE) end AS EffectTo,
	a.[Days],
	CASE WHEN a.JobStartDate  IS NULL THEN CAST('1900-01-01' AS DATE) ELSE a.JobStartDate END as JobStartDate,
	CASE WHEN a.JobLeaveDate IS NULL THEN CAST('1900-01-01' AS DATE) ELSE a.JobLeaveDate END as JobLeaveDate, 
	CASE When b.FurloughDate is not null then 1 else 0 end as IsFurlough, 
		CASE
		WHEN CAST(b.EarningsToDate AS DECIMAL(15,2))*Cast([Days] AS INT) is null or CAST(b.EarningsToDate AS DECIMAL(15,2))*Cast([Days] AS INT) = 0 THEN 'No Earnings'
		WHEN CAST(b.EarningsToDate AS DECIMAL(15,2))*Cast([Days] AS INT) > 0 and CAST(b.EarningsToDate AS DECIMAL(15,2))*Cast([Days] AS INT) < 1000 THEN 'Less than £1000'
		WHEN CAST(b.EarningsToDate AS DECIMAL(15,2))*Cast([Days] AS INT) >= 1000 and CAST(b.EarningsToDate AS DECIMAL(15,2))*Cast([Days] AS INT) < 2000 THEN 'Less than £1000'
		WHEN CAST(b.EarningsToDate AS DECIMAL(15,2))*Cast([Days] AS INT) > 0 and CAST(b.EarningsToDate AS DECIMAL(15,2))*Cast([Days] AS INT) < 1000 THEN 'Less than £1000'
		WHEN CAST(b.EarningsToDate AS DECIMAL(15,2))*Cast([Days] AS INT) > 2000 THEN 'Threshold Acheived'
		END	AS CaseEarningstoDateBracket,
	0 AS CaseHMRCEarningsBracket,
	0 AS PredictedJobOutcomeDate,
	0 AS CaseEarningsAtTrackingEnd  
	from d1 as a
	inner join
	final as b
	on CONCAT_WS('|',TRIM(a.[AssignmentEarningPatternHash]),[DayNumber]) = CONCAT_WS('|',TRIM(b.[AssignmentEarningPatternHash]),[DayNumber])
	and b.EarningsToDate <> 0;
GO


