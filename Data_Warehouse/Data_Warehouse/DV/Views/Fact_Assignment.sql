CREATE VIEW [DV].[Fact_Assignment] AS WITH FirstJobStarts AS 
(
SELECT * FROM 
(
SELECT
DISTINCT
dc.CaseHash,da.AssignmentHash,da.AssignmentStartClaimDate,ROW_NUMBER() OVER (PARTITION BY dc.CaseKey ORDER BY da.AssignmentStartClaimDate ASC) AS RN, 1 AS 'JS_Marker'
FROM DV.SAT_Assignment_Adapt_Core da 
INNER JOIN DV.LINK_Case_Assignment lca ON lca.AssignmentHash = da.AssignmentHash 
INNER JOIN DV.SAT_Case_Adapt_Core dc ON dc.CaseHash = lca.CaseHash AND dc.IsCurrent = 1
LEFT JOIN DV.SAT_Entity_SoftDelete_Adapt_Core SESAC ON SESAC.EntityKey = da.AssignmentReference AND SESAC.IsCurrent = 1
WHERE
(da.AssignmentStartClaimYear LIKE '%/%' OR da.AssignmentStartClaimYear LIKE '%CTD%')
AND SESAC.EntityKey IS NULL
AND da.IsCurrent = 1
)t
WHERE t.RN = 1
),JobLeaveAddDate AS
(
SELECT 
AssignmentHash
,MAX(AuditDate) AS JobLeaveAddDate
FROM DV.SAT_Assignment_LeaveAudit_Adapt_Core saac
WHERE
saac.IsCurrent = 1
GROUP BY
AssignmentHash
)
,LatestJob AS 
(
SELECT * FROM 
(
SELECT
dc.CaseHash,da.AssignmentHash,da.AssignmentStartClaimDate,ROW_NUMBER() OVER (PARTITION BY dc.CaseKey ORDER BY da.AssignmentStartClaimDate DESC) AS RN, 1 AS 'LJ_Marker'
FROM DV.SAT_Assignment_Adapt_Core da 
INNER JOIN DV.LINK_Case_Assignment lca ON lca.AssignmentHash = da.AssignmentHash 
INNER JOIN DV.SAT_Case_Adapt_Core dc ON dc.CaseHash = lca.CaseHash AND dc.IsCurrent = 1
LEFT JOIN DV.SAT_Entity_SoftDelete_Adapt_Core SESAC ON SESAC.EntityKey = da.AssignmentReference AND SESAC.IsCurrent = 1
WHERE 
SESAC.EntityKey IS NULL
AND da.IsCurrent = 1
) t
WHERE t.RN = 1
),Joboutcomes AS 
(
SELECT 
da.AssignmentHash
,da.AssignmentOutcomeOneClaimedDate
FROM DV.SAT_Assignment_Adapt_Core da 
INNER JOIN DV.LINK_Case_Assignment lca ON lca.AssignmentHash = da.AssignmentHash 
INNER JOIN DV.SAT_Case_Adapt_Core dc ON dc.CaseHash = lca.CaseHash AND dc.IsCurrent = 1
LEFT JOIN DV.SAT_Entity_SoftDelete_Adapt_Core SESAC ON SESAC.EntityKey = da.AssignmentReference AND SESAC.IsCurrent = 1
WHERE
(da.AssignmentStartClaimYear LIKE '%/%' OR da.AssignmentStartClaimYear LIKE '%CTD%')
AND da.AssignmentOutcomeOneClaimYear <> 'DWP'
AND SESAC.EntityKey IS NULL
AND da.IsCurrent = 1
),Assignments AS 
(
SELECT
CASE WHEN ASAT.AssignmentHash IS NULL THEN CONVERT(CHAR(66),CAST(0x0 AS BINARY(32)),1) ELSE CONVERT(CHAR(66), CAST(ASAT.AssignmentHash  AS BINARY(32)) ,1) 
END AS AssignmentHash
,'ADAPT.PROP_ASSIG_GEN' AS RecordSource
,C.CaseHash
,ASAT.AssignmentKey
,CASE WHEN V.VacancyHash IS NULL THEN CONVERT(CHAR(66),CAST(0x0 AS BINARY(32)),1) ELSE CONVERT(CHAR(66), CAST(V.VacancyHash AS BINARY(32)) ,1) 
 END AS VacancyHash
,CONVERT(CHAR(66), COALESCE(es.employmentSiteHash,CAST(0x0 AS BINARY(32))),1) AS employmentSiteHash
,CONVERT(CHAR(66), CAST(0x0 AS BINARY(32)) ,1) AS RequestingSiteEmployeeKey
,CASE WHEN ASAT.AssignmentStartDate IS NULL THEN -1 ELSE  CAST(CONVERT(CHAR(8),ASAT.AssignmentStartDate,112) AS INT)	
 END AS AssignmentStartDateKey
,CASE WHEN ASAT.AssignmentAddDate IS NULL THEN -1 ELSE CAST(CONVERT(CHAR(8),ASAT.AssignmentAddDate,112) AS INT) 
 END AS AssignmentAddDateKey
,CASE WHEN ASAT.AssignmentLeaveDate IS NULL THEN -1 ELSE  CAST(CONVERT(CHAR(8),ASAT.AssignmentLeaveDate,112) AS INT)	
 END AS AssignmentLeaveDateKey
,CASE WHEN ASAT.AssignmentStartVerificationDate IS NULL THEN -1 ELSE CAST(CONVERT(CHAR(8),ASAT.AssignmentStartVerificationDate,112) AS INT)									
 END AS AssignmentStartVerificationDateKey
,CASE WHEN ASAT.AssignmentOutcomeTwoVerificationDate IS NULL THEN -1 ELSE CAST(CONVERT(CHAR(8),ASAT.AssignmentOutcomeTwoVerificationDate,112) AS INT)						
 END AS AssignmentOutcomeTwoVerificationDateKey
,CASE WHEN ASAT.AssignmentOutcomeTwoFailedDate IS NULL THEN -1 ELSE CAST(CONVERT(CHAR(8),ASAT.AssignmentOutcomeTwoFailedDate,112) AS INT)									
 END AS AssignmentOutcomeTwoFailedDateKey
,CASE WHEN ASAT.AssignmentStartClaimDate IS NULL THEN -1 ELSE CAST(CONVERT(CHAR(8),ASAT.AssignmentStartClaimDate,112) AS INT)												
 END AS AssignmentStartClaimDateKey
,CASE WHEN ASAT.WorkTrialEndDate IS NULL THEN -1 ELSE CAST(CONVERT(CHAR(8),ASAT.WorkTrialEndDate,112) AS INT)																
 END AS WorkTrialEndDateKey
,CASE WHEN ASAT.AssignmentOutcomeTwoClaimedDate IS NULL THEN -1 ELSE CAST(CONVERT(CHAR(8),ASAT.AssignmentOutcomeTwoClaimedDate,112) AS INT)									
 END AS AssignmentOutcomeTwoClaimDateKey
,CASE WHEN ASAT.AssignmentOutcomeOneClaimedDate IS NULL THEN -1 ELSE CAST(CONVERT(CHAR(8),ASAT.AssignmentOutcomeOneClaimedDate,112) AS INT)									
 END AS AssignmentOutcomeOneClaimDateKey
,CASE WHEN ASAT.AssignmentOutcomeOneFailedDate IS NULL THEN -1 ELSE CAST(CONVERT(CHAR(8),ASAT.AssignmentOutcomeOneFailedDate,112) AS INT)									
 END AS AssignmentOutcomeOneFailedDateKey
,CASE WHEN ASAT.AssignmentOutcomeOneVerifiedDate IS NULL THEN -1 ELSE CAST(CONVERT(CHAR(8),ASAT.AssignmentOutcomeOneVerifiedDate,112) AS INT)								
 END AS AssignmentOutcomeOneVerifiedDateKey
,CASE WHEN ASAT.UnsupportedDate IS NULL THEN -1 ELSE CAST(CONVERT(CHAR(8),ASAT.UnsupportedDate,112) AS INT)																	
 END AS UnsupportedDateKey
,CASE WHEN ASAT.UnsupportedDateVerified IS NULL THEN -1 ELSE CAST(CONVERT(CHAR(8),ASAT.UnsupportedDateVerified,112) AS INT)													
 END AS UnsupportedDateVerifiedKey
,CASE WHEN ASAT.FailedAssignmentStartDate IS NULL THEN -1 ELSE CAST(CONVERT(CHAR(8),ASAT.FailedAssignmentStartDate,112) AS INT)											    
 END AS FailedAssignmentStartDateKey
,CASE WHEN ASAT.FailedAssignmentStartDate IS NULL THEN -1 ELSE CAST(CONVERT(CHAR(8),ASAT.AssignmentOutcomeThreeClaimedDate,112) AS INT)								 	    
 END AS AssignmentOutcomeThreeClaimDateKey
,CASE WHEN ASAT.AssignmentOutcomeThreeFailedDate IS NULL THEN -1 ELSE CAST(CONVERT(CHAR(8),ASAT.AssignmentOutcomeThreeFailedDate,112) AS INT)								
 END AS AssignmentOutcomeThreeFailedDateKey
,CASE WHEN ASAT.AssignmentOutcomeThreeVerifiedDate IS NULL THEN -1 ELSE CAST(CONVERT(CHAR(8),ASAT.AssignmentOutcomeThreeVerifiedDate,112) AS INT)							
 END AS AssignmentOutcomeThreeVerifiedDateKey
,CASE WHEN JLA.JobLeaveAddDate IS NULL THEN -1 ELSE CAST(CONVERT(CHAR(8),JLA.JobLeaveAddDate,112) AS INT)								
 END AS JobLeaveAddDateDateKey
,CASE WHEN JS_Marker IS NOT NULL THEN 1 ELSE 0 
 END AS IsFirstJob
,CASE WHEN JS_Marker IS NULL THEN 1 ELSE 0 
 END AS IsSubsequentJob
,CASE WHEN JOS.AssignmentOutcomeOneClaimedDate IS NOT NULL THEN 1 ELSE 0 
 END AS IsJobOutcome
,CASE WHEN ASAT.AssignmentLeaveDate IS NOT NULL THEN 1 ELSE 0 
 END AS IsEndedJob
,NULL AS IsVerifiedJob
,CASE WHEN LJ.LJ_Marker IS NOT NULL THEN 1 ELSE 0
 END AS IsLatestJob
,NULL AS IsUnverifiedJob
,NULL AS IsFailedJob
FROM DV.SAT_Assignment_Adapt_Core ASAT 
LEFT JOIN DV.LINK_Case_Assignment C ON C.AssignmentHash = ASAT.AssignmentHash
LEFT JOIN FirstJobStarts JS ON JS.AssignmentHash = ASAT.AssignmentHash AND JS.AssignmentStartClaimDate = ASAT.AssignmentStartClaimDate
LEFT JOIN Joboutcomes JOS ON JOS.AssignmentHash = ASAT.AssignmentHash
LEFT JOIN DV.SAT_Entity_SoftDelete_Adapt_Core SESAC ON SESAC.EntityKey = ASAT.AssignmentReference AND SESAC.IsCurrent = 1
LEFT JOIN DV.LINK_Vacancy_Assignment VA ON C.AssignmentHash = VA.AssignmentHash 
LEFT JOIN DV.SAT_Vacancy_Adapt_Core V ON V.VacancyHash = VA.VacancyHash AND V.IsCurrent = 1
LEFT JOIN LatestJob LJ ON LJ.AssignmentHash = ASAT.AssignmentHash AND LJ.AssignmentStartClaimDate = ASAT.AssignmentStartClaimDate 
LEFT OUTER JOIN 
	(SELECT DISTINCT --duplicate rows in link table, add to tech debt
		VacancyHash
		,employmentSiteHash  
	FROM					
		dv.link_employmentSite_vacancy) AS lev
ON
	v.vacancyHash = lev.VacancyHash
LEFT OUTER JOIN
	dv.sat_employmentSite_adapt_core AS es
ON
	lev.employmentSiteHash = es.employmentSiteHash
	AND 1 = es.IsCurrent

LEFT JOIN DV.SAT_Entity_SoftDelete_Adapt_Core SESAC1 ON SESAC1.EntityKey = V.VacancyReferenceKey 
LEFT JOIN JobLeaveAddDate JLA ON JLA.AssignmentHash = ASAT.AssignmentHash
WHERE
SESAC.EntityKey IS NULL
AND SESAC1.EntityKey IS NULL
AND ASAT.IsCurrent = 1
)

SELECT
A.AssignmentHash
,A.RecordSource
,fcb.CaseHash
,fcb.ParticipantHash
,A.VacancyHash
,fcb.ReferralHash
,fcb.RequestorHash
,fcb.EmployeeHash
,fcb.DeliverySiteHash
,fcb.ProgrammeHash
,fcb.CaseStatusHash
,fcb.ReferralStatusHash
,fcb.ReferralDateKey
,fcb.LeaveDateKey
,A.RequestingSiteEmployeeKey
,A.EmploymentSiteHash
,A.AssignmentStartDateKey
,A.AssignmentAddDateKey
,A.AssignmentLeaveDateKey
,A.AssignmentStartVerificationDateKey
,A.AssignmentOutcomeTwoVerificationDateKey
,A.AssignmentOutcomeTwoFailedDateKey
,A.AssignmentStartClaimDateKey
,A.WorkTrialEndDateKey
,A.AssignmentOutcomeTwoClaimDateKey
,A.AssignmentOutcomeOneClaimDateKey
,A.AssignmentOutcomeOneFailedDateKey
,A.AssignmentOutcomeOneVerifiedDateKey
,A.UnsupportedDateKey
,A.UnsupportedDateVerifiedKey
,A.FailedAssignmentStartDateKey
,A.AssignmentOutcomeThreeClaimDateKey
,A.AssignmentOutcomeThreeFailedDateKey
,A.AssignmentOutcomeThreeVerifiedDateKey
,A.JobLeaveAddDateDateKey
,A.IsFirstJob
,A.IsSubsequentJob
,A.IsJobOutcome
,A.IsEndedJob
,A.IsVerifiedJob
,A.IsLatestJob
,A.IsUnverifiedJob
,A.IsFailedJob
FROM DV.Fact_Case_Base fcb
INNER JOIN Assignments A ON A.CaseHash = fcb.Fact_Case_Base_CaseHash;
GO