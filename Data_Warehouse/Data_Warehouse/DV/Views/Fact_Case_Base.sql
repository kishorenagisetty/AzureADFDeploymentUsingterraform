CREATE VIEW [DV].[Fact_Case_Base] AS WITH JO1 AS 
	(
		SELECT ISNULL(Claim_NonDWP.CaseHash, Claim_DWP.CaseHash) AS CaseHash
			 , ISNULL(Claim_NonDWP.IsNonDWP, 0) AS IsNonDWP
			 , ISNULL(Claim_DWP.IsDWP, 0) AS IsDWP
			 , CASE 
				  WHEN ISNULL(Claim_NonDWP.AssignmentOutcomeOneClaimedDate, '9999-12-31') > ISNULL(Claim_DWP.AssignmentOutcomeOneClaimedDate, '9999-12-31')
					THEN Claim_DWP.AssignmentOutcomeOneClaimedDate 
				  ELSE Claim_NonDWP.AssignmentOutcomeOneClaimedDate
			   END AS AssignmentOutcomeOneClaimedDate
		FROM
		(
			SELECT 
				CA.CaseHash,
				MIN(A.AssignmentOutcomeOneClaimedDate) AS AssignmentOutcomeOneClaimedDate, 
				1 AS IsNonDWP
			FROM 
				DV.LINK_Case_Assignment AS CA
				LEFT JOIN
				DV.SAT_Assignment_Adapt_Core AS A
				ON A.AssignmentHash = CA.AssignmentHash AND A.IsCurrent = 1
			WHERE 
				A.AssignmentOutcomeOneClaimYear NOT LIKE '%DWP%' AND A.AssignmentOutcomeOneClaimYear IS NOT NULL
			GROUP BY
				CA.CaseHash
		) AS Claim_NonDWP

		FULL JOIN
		(
			SELECT 
				CA.CaseHash,
				MIN(A.AssignmentOutcomeOneClaimedDate) AS AssignmentOutcomeOneClaimedDate,
				1 AS IsDWP
			FROM 
				DV.LINK_Case_Assignment AS CA
				LEFT JOIN
				DV.SAT_Assignment_Adapt_Core AS A
				ON A.AssignmentHash = CA.AssignmentHash AND A.IsCurrent = 1
			WHERE 
				A.AssignmentOutcomeOneClaimYear LIKE '%DWP%'
			GROUP BY
				CA.CaseHash
		) AS Claim_DWP
		ON Claim_NonDWP.CaseHash = Claim_DWP.CaseHash
	)

SELECT
CONVERT(CHAR(66),ISNULL(S_C.CaseHash,CAST(0x0 AS BINARY(32))),1) AS CaseHash,
S_C.CaseHash AS Fact_Case_Base_CaseHash,
C.RecordSource,
CONVERT(CHAR(66),ISNULL(SPAC.ParticipantHash, CAST(0x0 AS BINARY(32))) ,1) AS ParticipantHash,
CONVERT(CHAR(66),ISNULL(SEAC.EmployeeHash, CAST(0x0 AS BINARY(32))),1) AS EmployeeHash,
CONVERT(CHAR(66),ISNULL(R_AC.ReferralHash, CAST(0x0 AS BINARY(32))) ,1) AS ReferralHash,
CONVERT(CHAR(66),ISNULL(SPRAC.ProgrammeHash, CAST(0x0 AS BINARY(32))),1) AS ProgrammeHash,
SPRAC.ProgrammeHash AS Fact_Case_Base_ProgrammeHash,

CONVERT(CHAR(66),ISNULL(SDAC.DeliverySiteHash, CAST(0x0 AS BINARY(32))),1) AS DeliverySiteHash,
CONVERT(CHAR(66),CAST(
	CASE WHEN COALESCE(RO.RequestingOrganisationHash,RS.RequestingSiteHash) IS NULL THEN 0x0 ELSE
		HASHBYTES('SHA2_256',
			CONCAT(
				ISNULL(RO.RequestingOrganisationHash,0x0),
				ISNULL(RS.RequestingSiteHash,0x0)
			)
		) 
	END  AS BINARY(32)),1) AS RequestorHash,
CASE WHEN S_C.CaseStatus IS NULL THEN CONVERT(CHAR(66),CAST(0x0 AS BINARY(32)),1) ELSE CONVERT(CHAR(66),CAST(HASHBYTES('SHA2_256',CAST(CAST(S_C.CaseStatus AS BIGINT) AS VARCHAR)) AS BINARY(32)),1) END AS CaseStatusHash,
CONVERT(CHAR(66),ISNULL(RSS.ReferralStatusHash, CAST(0x0 AS BINARY(32))),1) AS ReferralStatusHash,
CASE WHEN R_AC.ReferralDate IS NULL THEN -1 ELSE CAST(CONVERT(CHAR(8),R_AC.ReferralDate,112) AS INT) END AS ReferralDateKey,
CASE WHEN S_AD.StartDate IS NULL THEN -1 ELSE CAST(CONVERT(CHAR(8),S_AD.StartDate,112) AS INT) END AS StartDateKey,
CASE WHEN S_AD.StartVerifiedDate IS NULL THEN -1 ELSE CAST(CONVERT(CHAR(8),S_AD.StartVerifiedDate,112) AS INT) END AS  StartVerifiedDateKey,
CASE WHEN S_AD.LeaveDate IS NULL THEN -1 ELSE CAST(CONVERT(CHAR(8),S_AD.LeaveDate,112) AS INT) END AS  LeaveDateKey,
CASE WHEN S_AD.ProjectedLeaveDate IS NULL THEN -1 ELSE CAST(CONVERT(CHAR(8),S_AD.ProjectedLeaveDate,112) AS INT) END AS ProjectedLeaveDateKey,
CASE WHEN S_AD.ReportDate IS NULL THEN -1 ELSE CAST(CONVERT(CHAR(8),S_AD.ReportDate,112) AS INT) END AS ReportDateKey,
CASE WHEN S_AD.ReferralSLADate IS NULL THEN -1 ELSE CAST(CONVERT(CHAR(8),S_AD.ReferralSLADate,112) AS INT) END AS ReferalSLADate,
CAST(CASE WHEN S_AD.StartDate IS NOT NULL THEN 1 ELSE 0 END AS INT) AS IsStart,
CAST(CASE WHEN S_AD.StartDate IS NULL AND S_AD.LeaveDate IS NOT NULL THEN 1 ELSE 0 END AS INT) AS IsDNS,
CAST(CASE WHEN S_AD.StartDate IS NULL AND S_AD.LeaveDate IS NULL THEN 1 ELSE 0 END AS INT) AS IsLiveReferral,
CASE WHEN JO1.AssignmentOutcomeOneClaimedDate IS NOT NULL AND IsNonDWP=1 THEN 1 ELSE 0 END AS JobOutcomeOneIsPaidFlag,
CASE WHEN JO1.AssignmentOutcomeOneClaimedDate IS NOT NULL AND IsDWP=1 THEN 1 ELSE 0 END AS JobOutcomeOneIsPaidFlag_DWP,
CASE WHEN JO1.AssignmentOutcomeOneClaimedDate IS NULL THEN '-1' ELSE CAST(CONVERT(CHAR(8),JO1.AssignmentOutcomeOneClaimedDate,112) AS INT) END AS JobOutcomeOneIsPaidDate


FROM DV.HUB_Case C
	INNER JOIN DV.LINK_Case_Participant P ON C.CaseHash = P.CaseHash
	LEFT JOIN BV.LINK_Case_Employee ce ON ce.Case_EmployeeHash = C.CaseHash 
	LEFT JOIN DV.LINK_Case_Referral R ON R.CaseHash = C.CaseHash 
	LEFT JOIN DV.LINK_Referral_Programme Pr ON Pr.ReferralHash = R.ReferralHash 
	LEFT JOIN DV.LINK_Referral_RequestingOrganisation RO ON RO.ReferralHash = R.ReferralHash
	LEFT JOIN DV.LINK_Referral_RequestingSite RS ON RS.ReferralHash = R.ReferralHash 
	LEFT JOIN BV.LINK_Case_DeliverySite DS ON DS.CaseHash = C.CaseHash 
	LEFT JOIN DV.SAT_Participant_Adapt_Core_PersonGen SPAC ON SPAC.ParticipantHash = P.ParticipantHash AND SPAC.IsCurrent = 1
	LEFT JOIN DV.SAT_Employee_Adapt_Core SEAC ON SEAC.EmployeeHash = ce.EmployeeHash AND SEAC.IsCurrent = 1
	LEFT JOIN DV.SAT_Case_Adapt_Dates S_AD ON S_AD.CaseHash = C.CaseHash AND S_AD.IsCurrent = 1
	LEFT JOIN DV.SAT_Referral_Adapt_Core R_AC ON R_AC.ReferralHash = R.ReferralHash AND R_AC.IsCurrent = 1
	LEFT JOIN DV.SAT_DeliverySite_Adapt_Core SDAC ON SDAC.DeliverySiteHash = DS.DeliverySiteHash AND SDAC.IsCurrent = 1
	LEFT JOIN DV.SAT_Case_Adapt_Core S_C ON S_C.CaseHash = C.CaseHash AND S_C.IsCurrent = 1
	--LEFT JOIN DV.SAT_RequestingOrganisation_Adapt_Core SREAC ON SREAC.RequestingOrganisationHash = RO.RequestingOrganisationHash AND SREAC.IsCurrent = 1
	LEFT JOIN DV.SAT_Programme_Adapt_Core SPRAC ON SPRAC.ProgrammeHash = pr.ProgrammeHash AND SPRAC.IsCurrent = 1
	LEFT JOIN BV.LINK_Referral_ReferralStatus RSS ON RSS.ReferralHash = R.ReferralHash
	LEFT JOIN JO1 AS JO1 ON JO1.CaseHash = C.CaseHash
	LEFT JOIN DV.SAT_Entity_SoftDelete_Adapt_Core CSAC ON CSAC.EntityHash = C.CaseHash AND CSAC.IsCurrent = 1
	LEFT JOIN DV.SAT_Entity_SoftDelete_Adapt_Core CSAC1 ON CSAC1.EntityHash = R_AC.ReferralHash AND CSAC1.IsCurrent = 1 
	LEFT JOIN DV.SAT_Entity_SoftDelete_Adapt_Core CSAC2 ON CSAC2.EntityKey = SPAC.ParticipantEntityKey AND CSAC2.IsCurrent = 1
	LEFT JOIN DV.SAT_Entity_SoftDelete_Adapt_Core CSAC3 ON CSAC3.EntityHash = SDAC.DeliverySiteHash AND CSAC3.IsCurrent = 1
	WHERE C.RecordSource = 'ADAPT.PROP_WP_GEN'
	AND CSAC.EntityKey IS NULL
	AND CSAC1.EntityKey IS NULL
	AND CSAC2.EntityKey IS NULL
	AND CSAC3.EntityKey IS NULL
	
	
	
UNION ALL

SELECT
CONVERT(CHAR(66),ISNULL(C.CaseHash,CAST(0x0 AS BINARY(32))),1) AS CaseHash,
C.CaseHash AS Fact_Case_Base_CaseHash,
C.RecordSource,
CONVERT(CHAR(66),ISNULL(L_CP.ParticipantHash, CAST(0x0 AS BINARY(32))) ,1) AS ParticipantHash,
CONVERT(CHAR(66),ISNULL(L_CE.EmployeeHash, CAST(0x0 AS BINARY(32))),1) AS EmployeeHash,
CONVERT(CHAR(66),ISNULL(L_RP.ReferralHash, CAST(0x0 AS BINARY(32))) ,1) AS ReferralHash,
CONVERT(CHAR(66),ISNULL(P.ProgrammeHash, CAST(0x0 AS BINARY(32))),1) AS ProgrammeHash,
P.ProgrammeHash AS Fact_Case_Base_ProgrammeHash,
CONVERT(CHAR(66),ISNULL(L_DS.DeliverySiteHash, CAST(0x0 AS BINARY(32))),1) AS DeliverySiteHash,
CONVERT(CHAR(66),CAST(0x0 AS BINARY(32)) ,1) AS RequestorHash,
--CONVERT(CHAR(66),CAST(
--	CASE WHEN COALESCE(RO.RequestingOrganisationHash,RS.RequestingSiteHash) IS NULL THEN 0x0 ELSE
--		HASHBYTES('SHA2_256',
--			CONCAT(
--				ISNULL(RO.RequestingOrganisationHash,0x0),
--				ISNULL(RS.RequestingSiteHash,0x0)
--			)
--		) 
--	END  AS BINARY(32)),1) AS RequestorHash,
CASE WHEN S_IC.CaseStatus IS NULL THEN CONVERT(CHAR(66),CAST(0x0 AS BINARY(32)),1) ELSE CONVERT(CHAR(66),CAST(HASHBYTES('SHA2_256',CAST(S_IC.CaseStatus AS VARCHAR)) AS BINARY(32)),1) END AS CaseStatusHash,
CONVERT(CHAR(66),CAST(0x0 AS BINARY(32)) ,1) AS ReferralStatusHash,--CONVERT(CHAR(66),ISNULL(RSS.ReferralStatusHash, CAST(0x0 AS BINARY(32))),1) AS ReferralStatusHash,
CASE WHEN SR_IC.ReferralDate IS NULL THEN -1 ELSE CAST(CONVERT(CHAR(8),SR_IC.ReferralDate,112) AS INT) END AS ReferralDateKey,
CASE WHEN S_ID.StartDate IS NULL THEN -1 ELSE CAST(CONVERT(CHAR(8),S_ID.StartDate,112) AS INT) END AS StartDateKey,
-1,--CAST(CONVERT(CHAR(8),S_AD.StartVerifiedDate,112) AS INT) AS  StartVerifiedDate,
CASE WHEN S_ID.LeaveDate IS NULL THEN -1 ELSE CAST(CONVERT(CHAR(8),S_ID.LeaveDate,112) AS INT) END AS  LeaveDateKey,
-1,--CAST(CONVERT(CHAR(8),S_AD.ProjectedLeaveDate,112) AS INT) AS ProjectedLeaveDate,
-1,--CAST(CONVERT(CHAR(8),S_AD.ReportDate,112) AS INT) AS ReportDate,
-1,--CAST(CONVERT(CHAR(8),S_AD.ReferralSLADate,112) AS INT) AS ReferalSLADate,
CAST(CASE WHEN S_ID.StartDate IS NOT NULL THEN 1 ELSE 0 END AS INT) AS IsStart,
CAST(CASE WHEN S_ID.StartDate IS NULL AND S_ID.LeaveDate IS NOT NULL THEN 1 ELSE 0 END AS INT) AS IsDNS,
CAST(CASE WHEN S_ID.StartDate IS NULL AND S_ID.LeaveDate IS NULL THEN 1 ELSE 0 END AS INT) AS IsLiveReferral,
NULL AS JobOutcomeOneIsPaidFlag,
NULL AS JobOutcomeOneIsPaidFlag_DWP,
'-1' AS JobOutcomeOneIsPaidDate
FROM DV.HUB_Case C
	LEFT JOIN DV.LINK_Case_Participant L_CP ON C.CaseHash = L_CP.CaseHash
	LEFT JOIN DV.LINK_Case_Employee L_CE ON C.CaseHash = L_CE.CaseHash
	LEFT JOIN DV.LINK_Case_Referral L_CR ON C.CaseHash = L_CR.CaseHash
	LEFT JOIN DV.LINK_Referral_Participant L_RP ON C.CaseHash = L_RP.ReferralHash
	LEFT JOIN DV.LINK_Case_DeliverySite L_DS ON C.CaseHash = L_DS.CaseHash
	LEFT JOIN DV.SAT_Case_Iconi_Core S_IC ON S_IC.CaseHash = C.CaseHash
	LEFT JOIN DV.SAT_Case_Iconi_Dates S_ID ON S_ID.CaseHash = C.CaseHash
	LEFT JOIN DV.SAT_Referral_Iconi_Core SR_IC ON L_CR.ReferralHash = SR_IC.ReferralHash
	CROSS JOIN DV.HUB_Programme P
WHERE P.RecordSource = 'ICONI'
AND C.RecordSource = 'ICONI.Engagement'
AND S_IC.IsCurrent = 1
AND S_ID.IsCurrent = 1;
GO
