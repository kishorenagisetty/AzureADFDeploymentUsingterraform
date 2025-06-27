CREATE VIEW [ADAPT].[SAT_Vacancy_Adapt_Core] AS (


SELECT
	CONCAT_WS('|','ADAPT',CAST(J.JOB_ID AS INT))	AS VacancyKey,
	CONCAT_WS('|','ADAPT',CAST(J.REFERENCE AS INT))	AS VacancyReferenceKey,
	J.[STATUS]										AS VacancyStatus,
	J.JOB_TITLE										AS VacancyJobTitle,
	J.START_DT										AS ExpectedStartDate,
	J.REASON										AS ReasonForVacancy,
	DOC.DOCUMENT									AS VacancyDetails,
	J.DEPT_CODE										AS VacancyDepartment,
	J.INVP											AS VacancyInvoicePoint,
	J.XCLUSIVE										AS VacancyIsExclusive,
	J.REPORT_TO										AS VacancyReportsTo,
	J.JOB_TYPE										AS VacancyContractType,
	ET.CREATEDDATE									AS VacancyAddDate,
	J.CLOSED_DT										AS VacancyOpenToDate,
	J.CRB											AS VacancyCRBCheckRequired,
	J.REC_VAC										AS VacancyDrivingLicenceRequired,
	J.PAY_FREQ										AS VacancyPayFrequency,
	J.WEEKENDS										AS VacancyWeekendWorkRequired,
	J.NIGHTS										AS VacancyNightWorkRequired,
	J.SHIFTS										AS VacancyShiftWorkRequired,
	J.JOB_EXCLUSIV									AS JobOppotunityCategory,
	J.CONTR_WK_HRS									AS VacancyContractedWeeklyHours,
	J.SOC_CODE										AS VacancySOCCode,
	J.LMS_REF										AS VacancyEmployerReference,
	J.APP_METH										AS VacancyApplicationMethod,
	J.JOB_SRC										AS VacancySource,
	J.REMVACANCIES									AS VacancyPositionsRemaining,
	J.WORK_HRS										AS VacancyWoringkHours,
	J.ORL_REQ										AS VacancyOriginalNumberRequired,
	J.Currency										AS VacancySalaryCurrency,
	U.FullName									    AS VacancyAddUser,
	U1.FullName										AS VacancyOwner,
	PA.TOWN											AS Town,
	PA.POST_CODE									AS PostCode,
	J.ValidFrom										AS ValidFrom,
	J.ValidTo										AS ValidTo,
	J.IsCurrent										AS IsCurrent

FROM
ADAPT.PROP_JOB_GEN		AS J	
INNER JOIN ADAPT.ENTITY_TABLE ET ON ET.ENTITY_ID = J.REFERENCE AND ET.IsCurrent = 1
LEFT OUTER JOIN [ADAPT].[vw_zSysUsers] U ON U.UserID = ET.CREATED_BY AND U.IsCurrent = 1
LEFT OUTER JOIN 
(
	SELECT *, ROW_NUMBER() OVER (PARTITION BY REFERENCE ORDER BY BISUNIQUEID DESC) AS RN
	FROM  ADAPT.PROP_ADDRESS
	WHERE POST_CODE IS NOT NULL
)   PA	ON	PA.REFERENCE = J.REFERENCE	  AND PA.IsCurrent = 1  AND PA.RN = 1
LEFT JOIN ADAPT.vw_Documents_PSA DOC	ON DOC.Owner_ID = J.REFERENCE	AND DOC.Doc_Name = 'Vacancy Details'	AND DOC.IsCurrent = 1
LEFT JOIN 
(
	SELECT REFERENCE, CONSULTANT, ROW_NUMBER() OVER (PARTITION BY REFERENCE ORDER BY BISUNIQUEID DESC) AS RN
	FROM   ADAPT.PROP_OWN_CONS
	WHERE  IsCurrent = 1
)    O	ON O.REFERENCE = J.REFERENCE	  AND O.RN = 1
LEFT JOIN ADAPT.vw_zSysUsers	 U1		ON U1.UserID = O.CONSULTANT		AND U1.IsCurrent = 1
);
GO

