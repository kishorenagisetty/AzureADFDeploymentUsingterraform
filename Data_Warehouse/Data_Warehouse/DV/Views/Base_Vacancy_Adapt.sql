CREATE VIEW [DV].[Base_Vacancy_Adapt] AS SELECT
	CONVERT(CHAR(66),V.VacancyHash,1)						AS VacancyHash,
	V.RecordSource											AS RecordSource,
	VC.VacancyReferenceKey									AS VacancyReferenceKey,
	V_ST.[Description]										AS VacancyStatus,
	VC.VacancyJobTitle										AS VacancyJobTitle,
	CAST(NULL AS NVARCHAR(MAX))								AS VacancyDuties,
	CAST(NULL AS NVARCHAR(MAX))								AS VacancyDetails,
	CAST(NULL AS NVARCHAR(MAX))								AS VacancyPersonSpec,
	CAST(NULL AS NVARCHAR(MAX))								AS VacancyApplicationDetails,
	V_RV.[Description]										AS ReasonForVacancy,
	VC.VacancyDepartment									AS VacancyDepartment,
	CASE 
		WHEN VC.VacancyIsExclusive	= ' ' OR VC.VacancyIsExclusive	= ''
			THEN 'Unknown'
		ELSE VC.VacancyIsExclusive
	END														AS VacancyIsExclusive,
	V_RT.[Description]										AS VacancyReportsTo,
	V_CT.[Description]										AS VacancyContractType,
	VC.VacancyCRBCheckRequired								AS VacancyCRBCheckRequired,
	V_PF.[Description]										AS VacancyPayFrequency,
	VC.VacancyWeekendWorkRequired							AS VacancyWeekendWorkRequired,
	VC.VacancyNightWorkRequired								AS VacancyNightWorkRequired,
	VC.VacancyShiftWorkRequired								AS VacancyShiftWorkRequired,
	V_SOC.[Description]										AS VacancySOCCode,
	V_AM.[Description]										AS VacancyApplicationMethod,
	V_OC.[Description]										AS JobOppotunityCategory,
	VC.VacancyContractedWeeklyHours							AS VacancyContractedWeeklyHours,
	CAST(VC.VacancyEmployerReference AS NVARCHAR(MAX))		AS VacancyEmployerReference,
	CAST(V_SO.[Description] AS NVARCHAR(MAX))				AS VacancySource,
	CAST(VC.VacancyPositionsRemaining AS NVARCHAR(MAX))		AS VacancyPositionsRemaining,
	VC.VacancyDrivingLicenceRequired						AS VacancyDrivingLicenceRequired,			
	CAST(VC.VacancyOriginalNumberRequired AS INT)			AS VacancyOriginalNumberRequired,
	VC.VacancySalaryCurrency								AS VacancySalaryCurrency,
	V_IP.[Description]										AS VacancyInvoicePoint,
	V_WH.[Description]										AS VacancyWorkingHours,
	CAST(VAJ.VacancyMinimumEducationLevel AS INT)			AS VacancyMinimumEducationLevel,
	VAJ.VacancyPaymentInterval								AS VacancyPaymentInterval,
	V_P.[Description]										AS VacancyPermanence,
	V_WC.[Description]										AS VacancyWageCategory,
	CAST(NULL AS NVARCHAR(MAX))								AS VacancySkillsRequired,
	CAST(NULL AS NVARCHAR(MAX))								AS VacancyLocationDetails,
	CAST(NULL AS NVARCHAR(MAX))								AS VacancyProjectID,
	CAST(NULL AS NVARCHAR(MAX))								AS VacancyVersionNo,
	CAST(NULL AS NVARCHAR(MAX))								AS VacancyJobBrokerManaged,
	CAST(NULL AS NVARCHAR(MAX))								AS VacancyContact,
	VC.VacancyAddUser										AS VacancyAddUser
	
FROM
	DV.HUB_Vacancy V
	INNER JOIN DV.SAT_Vacancy_Adapt_Core AS VC 
	ON V.VacancyKey = VC.VacancyKey 
	AND VC.IsCurrent = 1
	INNER JOIN
	DV.SAT_Vacancy_Adapt_Job				AS VAJ
	ON V.VacancyKey = VAJ.VacancyKey
	AND VAJ.IsCurrent = 1
	LEFT JOIN DV.Dimension_References		AS V_RV 
	ON V_RV.Code = VC.ReasonForVacancy 
	AND V_RV.ReferenceSource = 'ADAPT.MD_MULTI_NAMES' 
	AND V_RV.Category = 'Code'
	LEFT JOIN DV.Dimension_References		AS V_ST 
	ON V_ST.Code = VC.VacancyStatus 
	AND V_ST.ReferenceSource = 'ADAPT.MD_MULTI_NAMES' 
	AND V_ST.Category = 'Code'
	LEFT JOIN DV.Dimension_References		AS V_RT 
	ON V_RT.Code = VC.VacancyReportsTo 
	AND V_RT.ReferenceSource = 'ADAPT.MD_MULTI_NAMES' 
	AND V_RT.Category = 'Code'
	LEFT JOIN DV.Dimension_References		AS V_CT 
	ON V_CT.Code = VC.VacancyContractType 
	AND V_CT.ReferenceSource = 'ADAPT.MD_MULTI_NAMES' 
	AND V_CT.Category = 'Code'
	LEFT JOIN DV.Dimension_References		AS V_PF 
	ON V_PF.Code = VC.VacancyPayFrequency 
	AND V_PF.ReferenceSource = 'ADAPT.MD_MULTI_NAMES' 
	AND V_PF.Category = 'Code'
	LEFT JOIN DV.Dimension_References		AS V_SOC 
	ON V_SOC.Code = VC.VacancySOCCode 
	AND V_SOC.ReferenceSource = 'ADAPT.MD_MULTI_NAMES' 
	AND V_SOC.Category = 'Code'
	LEFT JOIN DV.Dimension_References		AS V_AM 
	ON V_AM.Code = VC.VacancyApplicationMethod 
	AND V_AM.ReferenceSource = 'ADAPT.MD_MULTI_NAMES' 
	AND V_AM.Category = 'Code'
	LEFT JOIN DV.Dimension_References		AS V_OC 
	ON V_OC.Code = VC.JobOppotunityCategory 
	AND V_OC.ReferenceSource = 'ADAPT.MD_MULTI_NAMES' 
	AND V_OC.Category = 'Code'
	LEFT JOIN DV.Dimension_References		AS V_SO 
	ON V_SO.Code = VC.VacancySource 
	AND V_SO.ReferenceSource = 'ADAPT.MD_MULTI_NAMES' 
	AND V_SO.Category = 'Code'
	LEFT JOIN DV.Dimension_References		AS V_IP 
	ON V_IP.Code = VC.VacancyInvoicePoint 
	AND V_IP.ReferenceSource = 'ADAPT.MD_MULTI_NAMES' 
	AND V_IP.Category = 'Code'
	LEFT JOIN DV.Dimension_References		AS V_WH 
	ON V_WH.Code = VAJ.VacancyWorkingHours 
	AND V_WH.ReferenceSource = 'ADAPT.MD_MULTI_NAMES' 
	AND V_WH.Category = 'Code'
	LEFT JOIN DV.Dimension_References		AS V_P 
	ON V_P.Code = VAJ.VacancyPermanence 
	AND V_P.ReferenceSource = 'ADAPT.MD_MULTI_NAMES' 
	AND V_P.Category = 'Code'
	LEFT JOIN DV.Dimension_References		AS V_WC 
	ON V_WC .Code = VAJ.VacancyWageCategory 
	AND V_WC .ReferenceSource = 'ADAPT.MD_MULTI_NAMES' 
	AND V_WC .Category = 'Code'
	WHERE V.RecordSource = 'ADAPT.PROP_JOB_GEN';
GO



