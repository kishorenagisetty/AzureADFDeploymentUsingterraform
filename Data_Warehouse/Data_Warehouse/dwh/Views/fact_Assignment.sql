
CREATE VIEW [dwh].[fact_Assignment] 
AS 

-- Author: Mohmed Kapadia
-- Modified date: 05/07/2023
-- Ticket Reference:  <25856>
-- Description: <DWH fact table for Assignments>
-- Revisions:
-- 05/07/23 - <MK> - <25856> - <Added AssignmentIDNumber for reporting requirement>
-- 26/07/23 - <SK> - <25513> - <Added ContractType column for reporting requirement and also changed all the keywords to caps for standardization>
-- 11/10/23 - <SK> - <27217> - <Added 3 columns for Joboutcomes for FSS>
-- 12/12/23 - <MK> - <30351> - <Added Job Start Verification Date>

WITH		GetFirsts AS
				  
(
SELECT		lca.CaseHash
			,lca.AssignmentHash
			,CAST(aac.AssignmentStartDate AS DATE) AS FirstJobStartDate
			,ROW_NUMBER() OVER (PARTITION BY lca.CaseHash ORDER BY lca.CaseHash, cast(aac.AssignmentStartClaimDate AS DATE)) AS rn
FROM		DV.SAT_Assignment_Adapt_Core		  aac
JOIN		DV.LINK_Case_Assignment				  lca ON lca.AssignmentHash		 = aac.AssignmentHash 
JOIN		DV.SAT_Case_Adapt_Core				  cac ON cac.CaseHash			 = lca.CaseHash				   and cac.IsCurrent = 1
LEFT JOIN	DV.SAT_Entity_SoftDelete_Adapt_Core   sda ON sda.EntityKey		     = aac.AssignmentReference	   and sda.IsCurrent = 1
JOIN		DV.LINKSAT_Case_Assignment_Adapt_Core lsc ON lsc.Case_AssignmentHash = lca.Case_AssignmentHash	   and lsc.IsCurrent = 1
WHERE		aac.IsCurrent = 1
AND			sda.EntityKey is null
AND			CAST(aac.AssignmentStartDate AS DATE) IS NOT NULL
AND			(ISNULL(aac.AssignmentStartClaimYear,'') LIKE '%/%' or ISNULL(aac.AssignmentStartClaimYear,'') LIKE '%CTD%')
--AND			convert(char(66),isnull(lca.CaseHash ,cast(0x0 as binary(32))),1)= '0x3DE402F505057E64BC8211A40B49E192C10EB44825D9722398590A20BC750DAB'
),			GetLast AS
(
SELECT		lca.CaseHash
			,lca.AssignmentHash
			,CAST(aac.AssignmentStartDate AS DATE) as FirstJobStartDate
			,ROW_NUMBER() OVER (PARTITION BY lca.CaseHash ORDER BY lca.CaseHash, cast(aac.AssignmentStartClaimDate AS DATE) DESC) AS rn
FROM		DV.SAT_Assignment_Adapt_Core		  aac
JOIN		DV.LINK_Case_Assignment				  lca ON lca.AssignmentHash		 = aac.AssignmentHash 
JOIN		DV.SAT_Case_Adapt_Core				  cac ON cac.CaseHash			 = lca.CaseHash				and cac.IsCurrent = 1
LEFT JOIN	DV.SAT_Entity_SoftDelete_Adapt_Core	  sda ON sda.EntityKey			 = aac.AssignmentReference	and sda.IsCurrent = 1
JOIN		DV.LINKSAT_Case_Assignment_Adapt_Core lsc ON lsc.Case_AssignmentHash = lca.Case_AssignmentHash	and lsc.IsCurrent = 1
WHERE		aac.IsCurrent = 1
AND			sda.EntityKey is null
AND			cast(aac.AssignmentStartDate AS DATE) is not null
AND			(isnull(aac.AssignmentStartClaimYear,'') like '%/%' or isnull(aac.AssignmentStartClaimYear,'') like '%CTD%')
--and			convert(char(66),isnull(lca.CaseHash ,cast(0x0 as binary(32))),1)= '0x0905873B3F8F58F7EFE0B690CCF4D3F3BCEDFAD873F01DB0CD6C498D96383A9F'
),			GetAssignments AS
(
SELECT		aac.AssignmentHash															AS AssignmentHashBin
			,CONVERT(CHAR(66),ISNULL(aac.AssignmentHash ,CAST(0X0 AS BINARY(32))),1)	AS AssignmentHash
			,lca.CaseHash																AS CaseHashBin
			,CONVERT(CHAR(66),ISNULL(lca.CaseHash ,cast(0x0 AS BINARY(32))),1)			AS CaseHash
			,vas.VacancyHash															AS VacancyHashBin
			,CONVERT(CHAR(66),ISNULL(vas.VacancyHash ,CAST(0X0 AS BINARY(32))),1)		AS VacancyHash
			,aac.AssignmentKey															AS AssignmentKey
			,Right(aac.AssignmentKey, CHARINDEX('|',(REVERSE(aac.AssignmentKey))) -1)	AS AssignmentIDNumber  -- 05/07/23 <MK> <25856>
			,aac.AssignmentReference													AS AssignmentReference
			,aac.AssignmentTitle														AS AssignmentTitle
			,CAST(aac.AssignmentLeaveDate AS DATE)										AS AssignmentLeaveDate
			,CAST(laa.AuditDate AS DATE)												AS AssignmentLeaveAddDate
			,aac.AssignmentType															AS AssignmentType
			,aac.AssignmentLeaveReason													AS AssignmentLeaveReason
			,aac.AssignmentIndustry														AS AssignmentIndustry
			,aac.AssignmentStatus														AS AssignmentStatus
			,CAST(aac.AssignmentStartDate AS DATE)										AS AssignmentStartDate
			,CAST(aac.AssignmentAddDate AS DATE)										AS AssignmentAddDate
			,CAST(aac.AssignmentStartVerificationDate AS DATE)							AS AssignmentStartVerificationDate -- 12/12/23 - <MK> - <30351>
			,CAST(aac.AssignmentStartClaimDate AS DATE)									AS AssignmentStartClaimDate
			,CAST(aac.AssignmentOutcomeOneClaimedDate AS DATE)							AS AssignmentOutcomeOneClaimedDate   -- 11/10/23 - <SK> - <27217>
			,CAST(aac.AssignmentOutcomeTwoClaimedDate AS DATE)							AS AssignmentOutcomeTwoClaimedDate   -- 11/10/23 - <SK> - <27217>
			,CAST(aac.AssignmentOutcomeThreeClaimedDate AS DATE)						AS AssignmentOutcomeThreeClaimedDate -- 11/10/23 - <SK> - <27217>
			,aac.WeeklyHours															AS WeeklyHours
			,aac.ContractedHours														AS ContractedHours
			,ac.[description]															as AssignmentStartContractType -- 26/07/23 <SK> <25513>
			,eau.EmployeeName															AS JobOwningAdvisor
			,eac.EmploymentSiteName														AS EmploymentSiteName
			,eac.EmploymentOrgName														AS EmploymentOrgName
			,CASE 
				WHEN cast(aac.AssignmentStartDate AS DATE) is null 
				THEN null
				WHEN cast(aac.AssignmentLeaveDate AS DATE) is not null 
				THEN datediff(day,cast(aac.AssignmentStartDate AS DATE),cast(aac.AssignmentLeaveDate AS DATE))
				ELSE datediff(day,cast(aac.AssignmentStartDate AS DATE),cast(getdate() AS DATE))
			 END																		AS EmploymentDays
			,CASE WHEN isnull(aac.AssignmentStartClaimYear, 'DNC') like '%DNC%' 
				  THEN 1 
				  ELSE 0 
			 END																		AS JobOutcomeOneClaimedDate_IsDNC
			,ROW_NUMBER() OVER (PARTITION BY aac.AssignmentHash ORDER BY aac.AssignmentHash, aac.AssignmentStartClaimDate DESC) AS rn
FROM		DV.SAT_Assignment_Adapt_Core		aac
JOIN		DV.LINK_Case_Assignment				lca ON lca.AssignmentHash		   = aac.AssignmentHash 
JOIN		DV.SAT_Case_Adapt_Core				cac ON cac.CaseHash				   = lca.CaseHash				and cac.IsCurrent = 1
LEFT JOIN	DV.SAT_Entity_SoftDelete_Adapt_Core sda ON sda.EntityKey			   = aac.AssignmentReference	and sda.IsCurrent = 1
LEFT JOIN	DV.LINK_Case_Referral				ref ON ref.CaseHash				   = lca.CaseHash
LEFT JOIN	DV.LINK_Referral_Programme			pro ON pro.ReferralHash			   = ref.ReferralHash
LEFT JOIN	(SELECT DISTINCT * FROM DV.LINK_Vacancy_Assignment)		vas ON vas.AssignmentHash		= aac.AssignmentHash 
LEFT JOIN	(SELECT DISTINCT * FROM DV.LINK_EmploymentSite_Vacancy)	eva ON eva.VacancyHash			= vas.VacancyHash
LEFT JOIN	DV.SAT_EmploymentSite_Adapt_Core	eac ON eac.employmentSiteHash	   = eva.employmentSiteHash	and eac.IsCurrent = 1
LEFT JOIN	DV.SAT_Employee_Adapt_Core			eau ON eau.UserRefKey			   = 'ADAPT|' + cast(aac.AssignmentOwningEmployee AS VARCHAR(25))		and eau.IsCurrent = 1
LEFT JOIN	DV.SAT_Assignment_LeaveAudit_Adapt_Core laa ON laa.AssignmentHash	   = aac.AssignmentHash		    and	laa.IsCurrent = 1 
JOIN		DV.LINKSAT_Case_Assignment_Adapt_Core   lsc ON lsc.Case_AssignmentHash = lca.Case_AssignmentHash	and lsc.IsCurrent = 1
LEFT JOIN   (SELECT ac.Code_Id,mm.Description FROM ADAPT.Codes ac JOIN ADAPT.MD_MULTI_NAMES mm ON mm.Id = ac.code_Id WHERE ac.IsCurrent = 1) ac  ON aac.AssignmentStartContractType = ac.[CODE_ID] -- 26/07/23 <SK> <25513>
WHERE		aac.IsCurrent = 1
AND			sda.EntityKey is null
--and			(isnull(aac.AssignmentStartClaimYear,'') like '%/%' or isnull(aac.AssignmentStartClaimYear,'') like '%CTD%')
--and convert(char(66),isnull(aac.AssignmentHash ,cast(0x0 as binary(32))),1) = '0x6A05750A1FDCCE195E444FA37015A90C556DB2569EF4709467E56C2479058945'
)
SELECT		DISTINCT 
			ass.AssignmentHashBin
			,ass.AssignmentHash
			,ass.CaseHashBin
			,ass.CaseHash
			,ass.VacancyHashBin
			,ass.VacancyHash
			,ass.AssignmentKey
			,ass.AssignmentIDNumber
			,ass.AssignmentReference
			,ass.AssignmentTitle
			,ass.AssignmentLeaveDate
			,ass.AssignmentLeaveAddDate
			,ass.AssignmentType
			,ass.AssignmentLeaveReason
			,ass.AssignmentIndustry
			,ass.AssignmentStatus
			,ass.AssignmentStartDate
			,ass.AssignmentAddDate
			,ass.AssignmentStartVerificationDate -- 12/12/23 - <MK> - <30351>
			,ass.AssignmentStartClaimDate
			,ass.AssignmentOutcomeOneClaimedDate   -- 11/10/23 - <SK> - <27217>
			,ass.AssignmentOutcomeTwoClaimedDate   -- 11/10/23 - <SK> - <27217>
			,ass.AssignmentOutcomeThreeClaimedDate -- 11/10/23 - <SK> - <27217>
			,ass.WeeklyHours
			,ass.ContractedHours
			,ass.AssignmentStartContractType -- 26/07/23 <SK> <25513>
			,ass.JobOwningAdvisor
			,ass.EmploymentSiteName
			,ass.EmploymentOrgName
			,CASE WHEN gft.rn = 1 THEN 1 ELSE null END AS IsFirstJob
			,CASE WHEN gft.rn = 1 THEN null 
				  ELSE CASE WHEN ass.AssignmentStartDate is not null THEN 1 END
				  END AS IsSubJob
			,CASE WHEN gfl.rn = 1 THEN 1 ELSE null END AS IsLastJob
			,ass.EmploymentDays
			,ass.JobOutcomeOneClaimedDate_IsDNC
FROM		GetAssignments						ass
LEFT JOIN	GetFirsts							gft ON gft.AssignmentHash = ass.AssignmentHashBin and gft.rn=1
LEFT JOIN	GetLast								gfl ON gfl.AssignmentHash = ass.AssignmentHashBin and gfl.rn=1
WHERE		ass.rn = 1;
GO
