CREATE VIEW [DV].[Fact_Vacancy]
AS SELECT
	CONVERT(CHAR(66),ISNULL(V.VacancyHash,CAST(0x0 AS BINARY(32))),1)				AS VacancyHash,
	--Removed (set to default hash value) directly from this fact table to ensure no dulicate vacancies, to be revisted at a later date to remove in the BV layer
	--CONVERT(CHAR(66),ISNULL(VA.AssignmentHash,CAST(0x0 AS BINARY(32))),1)			AS AssignmentHash,

	------------------------------------------------------------------------------------------------------------
	---Whoever did the above change did not realise the cube/reorts need this field - Paul hannelly 03/11/2022
	--This will create duplicates in F_Vacancy (which is correct, because this table has Vacancy and Assignmnets in it.)
	------------------------------------------------------------------------------------------------------------
	--CONVERT(CHAR(66),CAST(0x0 AS BINARY(32)) ,1)									AS AssignmentHash,
	CONVERT(CHAR(66),ISNULL(VA.AssignmentHash,CAST(0x0 AS BINARY(32))),1)			AS AssignmentHash,
	------------------------------------------------------------------------------------------------------------

	CONVERT(CHAR(66),ISNULL(EV.EmploymentSiteHash,CAST(0x0 AS BINARY(32))),1)		AS EmploymentSiteHash,
	--CAST(CONVERT(CHAR(8),JCG.JobCategoryGroupKey,112) AS INT)						AS JobCategoryGroupKey,
	CAST(CONVERT(CHAR(8),VC.VacancyOpenToDate,112) AS INT)							AS VacancyOpenToDateKey,
	CAST(CONVERT(CHAR(8),VAJ.VacancyOpenFromDate,112) AS INT)						AS VacancyOpenFromDateKey,
	CAST(CONVERT(CHAR(8),VC.ExpectedStartDate,112) AS INT)							AS VacancyExpectedStartDate,
	VAJ.VacancyNumberExternallyFilled												AS VacancyNumberExternallyFilled, 
	VAJ.VacancyNumberInternallyFilled												AS VacancyNumberInternallyFilled, 
	VAJ.VacancyNumberRequired														AS VacancyNumberRequired, 
	VAJ.VacancyNumberRemaining														AS VacancyNumberRemaining, 
	VAJ.VacancySalaryFrom															AS VacancySalaryFrom, 
	VAJ.VacancySalaryTo																AS VacancySalaryTo, 
	VAJ.VacancyOnTargetEarnings														AS VacancyOnTargetEarnings 
FROM 
	DV.HUB_Vacancy V
	LEFT JOIN
	DV.SAT_Vacancy_Adapt_Core												AS VC
	ON V.VacancyHash = VC.VacancyHash
	AND VC.IsCurrent = 1
	--See comment 
	--LEFT JOIN DV.LINK_Vacancy_Assignment									AS VA 
	--ON V.VacancyHash = VA.VacancyHash
	------------------------------------------------------------------------------------------------------------------------------------
	---As per coments in the select above, this has been put back using 'ValidFrom' field for unique values - Paul hannelly 03/11/2022
	------------------------------------------------------------------------------------------------------------------------------------
	left join (select		Vacancy_AssignmentHash	
							,VacancyHash	
							,AssignmentHash	
							,RecordSource	
							,min(ValidFrom) as ValidFrom
				from		DV.LINK_Vacancy_Assignment
				group by	Vacancy_AssignmentHash	
							,VacancyHash	
							,AssignmentHash	
							,RecordSource)									as VA ON VA.VacancyHash = V.VacancyHash																					  
	------------------------------------------------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------------------------------


	------------------------------------------------------------------------------------------------------------
	---EV.IsCurrent does not exist, so replaced with min value on 'ValidFrom' field - Paul hannelly 03/11/2022
	------------------------------------------------------------------------------------------------------------
	--LEFT JOIN DV.LINK_EmploymentSite_Vacancy								AS EV 
	--ON V.VacancyHash = EV.VacancyHash --AND EV.IsCurrent = 1
	left join (select		EmploymentSite_VacancyHash	
							,EmploymentSiteHash	
							,VacancyHash	
							,RecordSource	
							,min(ValidFrom) as ValidFrom
				from		DV.LINK_EmploymentSite_Vacancy
				group by	EmploymentSite_VacancyHash	
							,EmploymentSiteHash	
							,VacancyHash	
							,RecordSource)									as EV ON V.VacancyHash = EV.VacancyHash --AND EV.IsCurrent = 1
	------------------------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------
	
	--Joining to JobCategory was also casuing some duplicate issues so has also been removed, possibly needing revisiting
	--LEFT JOIN DV.LINK_Vacancy_JobCategory									AS JCV 
	--ON V.VacancyHash = JCV.VacancyHash
	--LEFT JOIN DV.BRIDGE_JobCategory										AS JCG -- ALTER jobCategory to add group
	--ON JCG.JobCategoryGroupKey = V.JobCategoryGroupKey
	LEFT JOIN DV.SAT_Vacancy_Adapt_Job										AS VAJ 
	ON V.VacancyHash = VAJ.VacancyHash
	AND VAJ.IsCurrent = 1

WHERE V.RecordSource = 'ADAPT.PROP_JOB_GEN'

UNION ALL

SELECT
	CONVERT(CHAR(66),ISNULL(V.VacancyHash,CAST(0x0 AS BINARY(32))),1)				AS VacancyHash,
	--As comment for Adapt
	--CONVERT(CHAR(66),ISNULL(L_VA.AssignmentHash,CAST(0x0 AS BINARY(32))),1)		AS AssignmentHash,
	CONVERT(CHAR(66),CAST(0x0 AS BINARY(32)) ,1)									AS AssignmentHash,
	CONVERT(CHAR(66),ISNULL(L_EV.EmploymentSiteHash,CAST(0x0 AS BINARY(32))),1)		AS EmploymentSiteHash,
	--CAST(CONVERT(CHAR(8),JCG.JobCategoryGroupKey,112) AS INT)						AS JobCategoryGroupKey,
	CAST(CONVERT(CHAR(8),S_VIC.VacancyAddDate,112) AS INT)							AS VacancyAddedDate,
	CAST(CONVERT(CHAR(8),RIGHT(S_VIC.VacancyOpenToDate,4)*10000+
								RIGHT(LEFT(S_VIC.VacancyOpenToDate,5),2)*100+
								LEFT(S_VIC.VacancyOpenToDate,2),112) AS INT)		AS VacancyClosingDate,
	NULL																			AS VacancyExpectedStartDate,
	NULL																			AS VacancyNumberExternallyFilled, 
	ISNULL(S_VIC.VacancyNumberInternallyFilled,0)									AS VacancyNumberInternallyFilled, 
	S_VIC.VacancyNumberRequired														AS VacancyNumberRequired, 
	CASE WHEN ISNULL(S_VIC.VacancyNumberInternallyFilled,0) > 0 THEN
		S_VIC.VacancyNumberRequired - ISNULL(S_VIC.VacancyNumberInternallyFilled,0)
		ELSE S_VIC.VacancyNumberRequired END										AS VacancyNumberRemaining,
	S_VIC.VacancySalaryFrom															AS VacancySalaryFrom, 
	NULL 																			AS VacancySalaryTo, 
	NULL																			AS VacancyOnTargetEarnings 

FROM 
	DV.HUB_Vacancy V
	LEFT JOIN DV.SAT_Vacancy_Iconi_Core										AS S_VIC
	ON V.VacancyHash = S_VIC.VacancyHash AND S_VIC.IsCurrent = 1
	--LEFT JOIN DV.LINK_Vacancy_Assignment									AS L_VA
	--ON V.VacancyHash = L_VA.VacancyHash
	LEFT JOIN DV.LINK_EmploymentSite_Vacancy								AS L_EV 
	ON V.VacancyHash = L_EV.VacancyHash
WHERE V.RecordSource = 'ICONI.Vacancy';