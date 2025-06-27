CREATE VIEW [ADAPT].[SAT_Vacancy_Job_Adapt_Core]
AS (


Select
	CONCAT_WS('|','ADAPT',CAST(J2.JOB_ID AS INT))	AS VacancyKey,
	J2.JOB_ID										AS VacancyReference,
	J.HOURS_TYPE									AS VacancyWorkingHours,
	J.NO_REQ										AS VacancyNumberRequired,
	J.NO_REMAIN										AS VacancyNumberRemaining,
	J.SAL_FROM										AS VacancySalaryFrom,
	J.SAL_TO										AS VacancySalaryTo,
	J.OTE											AS VacancyOnTargetEarnings,
	J.OPEN_SINCE									AS VacancyOpenFromDate,
	J.EDUC_LEVEL									AS VacancyMinimumEducationLevel,
	J.PAY_INT										AS VacancyPaymentInterval,
	J.EXT_FILLED									AS VacancyNumberExternallyFilled,
	J.NO_SOFAR										AS VacancyNumberInternallyFilled,
	J.TEMPPERM										AS VacancyPerformance,
	J.WAGE_CAT										AS VacancyWageCategory,
	J.ValidFrom										AS ValidFrom,
	J.ValidTo										AS ValidTo,
	J.IsCurrent										AS IsCurrent

FROM
	ADAPT.PROP_PJOB_GEN						AS J
	LEFT JOIN
	ADAPT.PROP_JOB_GEN						AS J2
	ON J2.REFERENCE = J.REFERENCE


);