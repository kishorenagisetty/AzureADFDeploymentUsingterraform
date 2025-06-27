CREATE VIEW [ICONI].[SAT_Vacancy_Iconi_Core] AS WITH CTE_SuccessfulInterest AS (
SELECT
	VI.vai_vacancy_id AS VacancyID
	,SUM(CASE WHEN VI.vai_outcome_1 = 'Successful' THEN 1 ELSE 0 END) AS VacancyNumberInternallyFilled
FROM ICONI.vBIRestart_Vacancy V
LEFT JOIN ICONI.vBIRestart_VacancyInterest VI
ON V.vacancy_id = VI.vai_vacancy_id
WHERE VI.vai_vacancy_id IS NOT NULL
GROUP BY VI.vai_vacancy_id
)
SELECT 
CONCAT_WS('|','ICONI',V.vacancy_id) AS VacancyKey,
V.vac_notes AS VacancyNotes,
V.vac_job_description AS VacancyJobDescription,
V.vac_person_specification AS VacancyPersonSpec,
V.vac_added_date AS VacancyAddDate,
V.vac_added_by_user_id AS VacancyAddUser,
V.vac_paid_by AS PaidBy,
V.vac_application_process AS VacancyApplicationDetails,
V.vac_closing_date AS VacancyOpenToDate,
V.vac_hrs_per_week AS VacancyContractedWeeklyHours,
V.vac_job_title AS VacancyJobTitle,
V.vac_contract_type AS VacancyContractType,
V.vac_duration AS VacancyDuration,
V.vac_status AS VacancyStatus,
V.vac_working_pattern AS VacancyWorkingPattern,
V.vac_no_oppor AS VacancyNumberRequired,
VI.VacancyNumberInternallyFilled,
V.vac_salary_from AS VacancySalaryFrom,
V.vac_skills_required AS VacancySkillsRequired,
V.vac_salary_unit AS VacancySalaryUnit,
V.vac_location AS VacancyLocationDetails,
V.vac_project_id AS VacancyProjectID,
V.vac_version_no AS VacancyVersionNo,
V.vac_job_broker_managed AS VacancyJobBrokerManaged,
V.vac_account_manager_user_id AS VacancyAcctMgrUserID,
--V.vac_contact AS VacancyContact,
V.ValidFrom,
V.ValidTo,
V.IsCurrent
FROM ICONI.vBIRestart_Vacancy as V
LEFT JOIN CTE_SuccessfulInterest VI
ON V.vacancy_id = VI.VacancyID;
GO

