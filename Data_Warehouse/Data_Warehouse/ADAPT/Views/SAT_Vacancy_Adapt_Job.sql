CREATE VIEW [ADAPT].[SAT_Vacancy_Adapt_Job] AS (


Select
	CONCAT_WS('|','ADAPT',CAST(J2.JOB_ID AS INT))	AS VacancyKey,
	J2.JOB_ID										AS VacancyReference,
	J.HOURS_TYPE									AS VacancyWorkingHours,
	J.NO_REQ										AS VacancyNumberRequired,
	J.NO_REMAIN										AS VacancyNumberRemaining,
	CAST(JB.Salary_From	AS DECIMAL(10,2))			AS HourlyRate,
	CAST(J.SAL_FROM	AS DECIMAL(10,2))				AS VacancySalaryFrom,
	CAST(J.SAL_TO AS DECIMAL(10,2))					AS VacancySalaryTo,
	CAST(J.OTE AS DECIMAL(10,2))					AS VacancyOnTargetEarnings,
	J.OPEN_SINCE									AS VacancyOpenFromDate,
	J.EDUC_LEVEL									AS VacancyMinimumEducationLevel,
	J.PAY_INT										AS VacancyPaymentInterval,
	J.EXT_FILLED									AS VacancyNumberExternallyFilled,
	J.NO_SOFAR										AS VacancyNumberInternallyFilled,
	J.TEMPPERM										AS VacancyPermanence,
	J.WAGE_CAT										AS VacancyWageCategory,
	J.ValidFrom										AS ValidFrom,
	J.ValidTo										AS ValidTo,
	J.IsCurrent										AS IsCurrent

FROM
	ADAPT.PROP_PJOB_GEN						AS J
	LEFT JOIN
	ADAPT.PROP_JOB_GEN						AS J2
	ON J2.REFERENCE = J.REFERENCE AND J2.IsCurrent = 1
	LEFT JOIN ADAPT.PROP_JOB_JOBBOARD		AS JB
	ON JB.PRIMREF = J.REFERENCE	  AND JB.Iscurrent = 1

);