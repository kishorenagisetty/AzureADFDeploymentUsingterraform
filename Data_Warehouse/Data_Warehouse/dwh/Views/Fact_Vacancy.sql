
CREATE VIEW [dwh].[Fact_Vacancy] 
AS 
/*--================================================================================
 Author			: 
 Created Date   :
 Created Ticket#:
 Description	: To get all the vacancy details from the Adapt system and this view is consumed in the cube.
 Revisions:
 04/07/2023-SK-#25924-Adding a new column VacancyKey and removing the 'ADAPT|' character in the data as per the request.
 06/07/2023-SK-#25924-Removing the 'ADAPT|' character in the VacancyReferenceKey data as per the request.
 07/07/2023 <MK> <26320> <Added Employment Org Name>
 19/10/2023-<SK>-<29188> - <Adding 1 column related to IconiReference>
 07/11/2023 - <MK> - <29869> - <Added one additional column - Vacancy Category>
 14/11/2023 - <MK> - <29869> - <Amended code slightly to rectify typo error>
--==================================================================================*/
select		convert(char(66),isnull(vac.VacancyHash,cast(0x0 as binary(32))),1)		as VacancyHash
			,vac.VacancyHash														as VacancyHashBin
			,REPLACE(sva.VacancyReferenceKey,'ADAPT|','')							as VacancyReferenceKey --06/07/2023-SK-#25924
			,REPLACE(sva.VacancyKey,'ADAPT|','')									as VacancyKey --04/07/2023-SK-#25924
			,cast(sva.ExpectedStartDate as date)									as ExpectedStartDate
			,cast(sva.VacancyOpenToDate as date)									as VacancyOpenToDate
			,cast(vaj.VacancyOpenFromDate as date)									as VacancyOpenFromDate
			,vaj.VacancyNumberRemaining												as VacancyNumberRemaining
			,vaj.VacancyOnTargetEarnings											as VacancyOnTargetEarnings
			,vaj.VacancyNumberExternallyFilled										as VacancyNumberExternallyFilled
			,vaj.VacancyNumberInternallyFilled										as VacancyNumberInternallyFilled
			,vaj.VacancyNumberRequired												as VacancyNumberRequired
			,vaj.HourlyRate															as HourlyRate
			,vaj.VacancySalaryFrom													as VacancySalaryFrom
			,vaj.VacancySalaryTo													as VacancySalaryTo
			,eac.EmploymentSiteBlacklisted											as EmploymentSiteBlacklisted
			,eac.EmploymentSiteName													as EmploymentSiteName
			,eac.EmploymentSiteWebsiteAddress										as EmploymentSiteWebsiteAddress
			,eac.EmploymentJobSector												as EmploymentJobSector
			,eac.EmploymentOrgName													as EmploymentOrgName  -- 07/07/23 <MK> <26320>
			,eac.IconiReference														as IconiReference	  --19/10/2023-<SK>-<29188>
			,sva.VacancyDrivingLicenceRequired										as VacancyDrivingLicenceRequired
			,sva.VacancyJobTitle													as VacancyJobTitle
			,sva.VacancyDetails														as VacancyDetails
			,sva.VacancyAddDate														as VacancyAddDate
			,sva.VacancyOwner														as VacancyOwner
			,sva.Town																as Town
			,sva.PostCode															as PostCode
			,mu1.Description														as EmploymentSiteRegion
			,mu2.Description														as EmploymentSiteSIC
			,mu3.Description														as EmploymentSiteStatus
			,mu4.Description														as VacancyPayFrequency
			,mu5.Description														as VacancySOCCode
			,mu6.Description														as VacancyWageCategory
			,mu7.Description														as VacancyWorkingHours
			,mu8.Description														as VacancyCategory     --07/11/23 <MK> <29869>
			,case when ass.VacancyHash is not null then 1 end						as AssignmentLink
			,assg.Vacancy_JobStarts													as Vacancy_JobStarts
			,assg.Vacancy_JobStartscurMonth											as Vacancy_JobStartsCurMonth
			,assg.Vacancy_JobStartscurQTR											as Vacancy_JobStartsCurQTR
			,assg.Vacancy_JobStartscurYear											as Vacancy_JobStartsCurYear
			,assg.Vacancy_JobOutcomes												as Vacancy_JobOutcomes
			,assg.Vacancy_JobOutcomescurMonth										as Vacancy_JobOutcomesCurMonth
			,assg.Vacancy_JobOutcomescurQTR											as Vacancy_JobOutcomesCurQTR
			,assg.Vacancy_JobOutcomescurYear										as Vacancy_JobOutcomesCurYear
from		DV.HUB_Vacancy						vac
left join	DV.SAT_Vacancy_Adapt_Core			sva on sva.VacancyHash = vac.VacancyHash and sva.IsCurrent = 1
left join	DV.SAT_Vacancy_Adapt_Job			vaj on vaj.VacancyHash = vac.VacancyHash and vaj.IsCurrent = 1
left join	(select distinct * from DV.LINK_EmploymentSite_Vacancy) lev on lev.VacancyHash = vac.VacancyHash
left join	DV.SAT_EmploymentSite_Adapt_Core	eac on eac.EmploymentSiteHash = lev.EmploymentSiteHash	and eac.IsCurrent = 1
left join	DV.SAT_References_MDMultiNames		mu1 on mu1.ID = eac.EmploymentSiteRegion				and mu1.IsCurrent = 1  and mu1.Type = 'Code'
left join	DV.SAT_References_MDMultiNames		mu2 on mu2.ID = eac.EmploymentSiteSIC					and mu2.IsCurrent = 1  and mu2.Type = 'Code'
left join	DV.SAT_References_MDMultiNames		mu3 on mu3.ID = eac.EmploymentSiteStatus				and mu3.IsCurrent = 1  and mu3.Type = 'Code'
left join	DV.SAT_References_MDMultiNames		mu4 on mu4.ID = sva.VacancyPayFrequency					and mu4.IsCurrent = 1  and mu4.Type = 'Code'
left join	DV.SAT_References_MDMultiNames		mu5 on mu5.ID = sva.VacancySOCCode						and mu5.IsCurrent = 1  and mu5.Type = 'Code'
left join	DV.SAT_References_MDMultiNames		mu6 on mu6.ID = vaj.VacancyWageCategory					and mu6.IsCurrent = 1  and mu6.Type = 'Code'
left join	DV.SAT_References_MDMultiNames		mu7 on mu7.ID = vaj.VacancyWorkingHours					and mu7.IsCurrent = 1  and mu7.Type = 'Code'
left join	DV.SAT_References_MDMultiNames		mu8 on mu8.ID = sva.JobOppotunityCategory				and mu8.IsCurrent = 1  and mu8.Type = 'Code' -- 14/11/23  <MK>  <29869>
left join	(select distinct VacancyHash from DV.LINK_Vacancy_Assignment)	ass on ass.VacancyHash = vac.VacancyHash
left join	(select lva.vacancyhash
				   ,count(saac.AssignmentStartDate)																																						   Vacancy_JobStarts
				   ,sum(case when year(saac.AssignmentStartDate) 			 = year(getdate()) and month(saac.AssignmentStartDate) = month(getdate()) 									then 1 else 0 end) Vacancy_JobStartsCurMonth
				   ,sum(case when year(saac.AssignmentStartDate) 			 = year(getdate()) and saac.AssignmentStartDate <= getdate()  												then 1 else 0 end) Vacancy_JobStartsCurYear
				   ,sum(case when year(saac.AssignmentStartDate) 			 = year(getdate()) and datepart(quarter,saac.AssignmentStartDate) = datepart(quarter,getdate())  			then 1 else 0 end) Vacancy_JobStartsCurQTR
				   ,count(saac.AssignmentOutcomeOneClaimedDate)																																			   Vacancy_JobOutcomes
				   ,sum(case when year(saac.AssignmentOutcomeOneClaimedDate) = year(getdate()) and month(saac.AssignmentOutcomeOneClaimedDate) = month(getdate()) 						then 1 else 0 end) Vacancy_JobOutcomesCurMonth
				   ,sum(case when year(saac.AssignmentOutcomeOneClaimedDate) = year(getdate()) and saac.AssignmentOutcomeOneClaimedDate <= getdate()  									then 1 else 0 end) Vacancy_JobOutcomesCurYear
				   ,sum(case when year(saac.AssignmentOutcomeOneClaimedDate) = year(getdate()) and datepart(quarter,saac.AssignmentOutcomeOneClaimedDate) = datepart(quarter,getdate()) then 1 else 0 end) Vacancy_JobOutcomesCurQTR
			from DV.Link_Vacancy_Assignment   	lva
			join DV.SAT_Assignment_Adapt_Core 	saac on lva.assignmenthash = saac.assignmenthash
			group by lva.vacancyhash)			assg  on assg.VacancyHash    = vac.VacancyHash
where		vac.RecordSource = 'ADAPT.PROP_JOB_GEN';



