CREATE VIEW [ADAPT].[LINK_Vacancy_Submission] AS SELECT 
	CONCAT_WS('|', 'ADAPT', CAST(vac.job_id AS INT))	as VacancyKey,
	CONCAT_WS('|', 'ADAPT', CAST(sub.shortlist AS INT)) as SubmissionKey,
	'ADAPT.PROP_JOB_GEN' AS RecordSource,
	vac.ValidFrom,
	vac.ValidTo,
	vac.IsCurrent
FROM		ADAPT.PROP_JOB_GEN		vac
INNER JOIN  ADAPT.PROP_X_SHORT_CAND sub		ON vac.Reference = sub.job and sub.IsCurrent = 1;