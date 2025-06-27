CREATE VIEW [DV].[Fact_Case_Barrier] AS SELECT
	CONVERT(CHAR(66),ISNULL(BSAT.BarriersHash,CAST(0x0 AS BINARY(32))),1) AS BarrierHash
	,b.RecordSource AS RecordSource
	,CONVERT(CHAR(66),ISNULL(SCAC.CaseHash,CAST(0x0 AS BINARY(32))),1) AS CaseHash
	,CONVERT(CHAR(66),ISNULL(SPAC.ParticipantHash, CAST(0x0 AS BINARY(32))) ,1) AS ParticipantHash
	,CASE WHEN BSAT.BarrierStartDate IS NULL THEN -1 ELSE CAST(CONVERT(CHAR(8),BSAT.BarrierStartDate,112) AS INT)END AS BarrierStartDateKey
	,CASE WHEN BSAT.BarrierEndDate IS NULL THEN -1 ELSE CAST(CONVERT(CHAR(8),BSAT.BarrierEndDate,112) AS INT)END AS BarrierEndDateKey
	,CASE WHEN BSAT.BarrierStatus IS NULL THEN CONVERT(CHAR(66),CAST(0x0 AS BINARY(32)),1) ELSE CONVERT(CHAR(66),CAST(HASHBYTES('SHA2_256',CAST(CAST(BSAT.BarrierStatus AS INT) AS VARCHAR)) AS BINARY(32)),1) END AS BarrierStatusHash
	,CONVERT(CHAR(66),ISNULL(SRAC.ReferralHash, CAST(0x0 AS BINARY(32))) ,1) AS ReferralHash
	,CONVERT(CHAR(66),ISNULL(SPRAC.ProgrammeHash, CAST(0x0 AS BINARY(32))),1) AS ProgrammeHash
	,CONVERT(CHAR(66),ISNULL(SDAC.DeliverySiteHash, CAST(0x0 AS BINARY(32))),1) AS DeliverySiteHash
	,CONVERT(CHAR(66),ISNULL(SEAC.EmployeeHash, CAST(0x0 AS BINARY(32))),1) AS EmployeeHash
	,CASE WHEN SRAC.ReferralDate IS NULL THEN -1 ELSE CAST(CONVERT(CHAR(8),SRAC.ReferralDate,112) AS INT) END AS ReferralDateKey
	,CASE WHEN SCAD.StartDate IS NULL THEN -1 ELSE CAST(CONVERT(CHAR(8),SCAD.StartDate,112) AS INT) END AS StartDateKey
	,CASE WHEN SCAD.StartVerifiedDate IS NULL THEN -1 ELSE CAST(CONVERT(CHAR(8),SCAD.StartVerifiedDate,112) AS INT) END AS VerifiedDateKey
	,CASE WHEN SCAD.LeaveDate IS NULL THEN -1 ELSE CAST(CONVERT(CHAR(8),SCAD.LeaveDate,112) AS INT) END AS LeaveDateKey
	,CASE WHEN SCAD.ProjectedLeaveDate IS NULL THEN -1 ELSE CAST(CONVERT(CHAR(8),SCAD.ProjectedLeaveDate,112) AS INT) END AS ProjectedLeaveDateKey
	,1 AS IsBarrier
	,CASE WHEN BSAT.BarrierEndDate IS NULL THEN 1 ELSE 0 END AS IsOpenBarrier
	,CASE WHEN BSAT.BarrierEndDate IS NOT NULL AND BSAT.BarrierStatus <> '8253473' THEN 1 ELSE 0 END AS IsClosedBarrier
	,CASE WHEN BSAT.BarrierStatus = '8253471' THEN 1 ELSE 0 END AS IsNewBarrier
	,CASE WHEN BSAT.BarrierStatus = '8253472' THEN 1 ELSE 0 END AS IsInProgress
	,CASE WHEN BSAT.BarrierStatus = '8253473' THEN 1 ELSE 0 END AS IsComplete
	,CASE WHEN BSAT.BarrierEndDate IS NOT NULL THEN 1 ELSE 0 END AS IsClosedorComplete
	,0 AS BarrierScore
FROM DV.HUB_Barriers b
	LEFT JOIN DV.LINK_Case_Barriers cb ON cb.BarriersHash = b.BarriersHash 
	INNER JOIN DV.LINK_Case_Participant p ON p.CaseHash = cb.CaseHash 
	LEFT JOIN DV.SAT_Barriers_Adapt_Core BSAT ON BSAT.BarriersHash = cb.BarriersHash AND BSAT.IsCurrent = 1
	LEFT JOIN DV.SAT_Case_Adapt_Core SCAC ON SCAC.CaseHash = cb.CaseHash AND SCAC.IsCurrent = 1
	LEFT JOIN DV.LINK_Case_Referral R ON R.CaseHash = cb.CaseHash 
	LEFT JOIN DV.LINK_Referral_Programme Pr ON Pr.ReferralHash = R.ReferralHash 
	LEFT JOIN BV.LINK_Case_DeliverySite DS ON DS.CaseHash = cb.CaseHash 
	LEFT JOIN BV.LINK_Case_Employee E ON E.Case_EmployeeHash = cb.CaseHash 
	--LEFT JOIN BV.LINK_Referral_ReferralStatus RSS ON RSS.ReferralHash = R.ReferralHash
	LEFT JOIN DV.SAT_Case_Adapt_Dates SCAD ON SCAD.CaseHash = cb.CaseHash AND SCAD.IsCurrent = 1
	LEFT JOIN DV.SAT_Referral_Adapt_Core SRAC ON SRAC.ReferralHash = R.ReferralHash AND SRAC.IsCurrent = 1
	LEFT JOIN DV.SAT_Participant_Adapt_Core_PersonGen SPAC ON SPAC.ParticipantHash = p.ParticipantHash AND SPAC.IsCurrent = 1
	LEFT JOIN DV.SAT_DeliverySite_Adapt_Core SDAC ON SDAC.DeliverySiteHash = DS.DeliverySiteHash AND SDAC.IsCurrent = 1
	LEFT JOIN DV.SAT_Employee_Adapt_Core SEAC ON SEAC.EmployeeHash = E.EmployeeHash AND SEAC.IsCurrent = 1
	LEFT JOIN DV.SAT_Programme_Adapt_Core SPRAC  ON SPRAC.ProgrammeHash = Pr.ProgrammeHash AND SPRAC.IsCurrent = 1
WHERE
	b.RecordSource = 'ADAPT.PROP_BARRIER_GEN'
	
UNION ALL

SELECT
	CONVERT(CHAR(66),ISNULL(b.BarriersHash,CAST(0x0 AS BINARY(32))),1) AS BarrierHash
	,b.RecordSource AS RecordSource
	,CONVERT(CHAR(66),ISNULL(cb.CaseHash,CAST(0x0 AS BINARY(32))),1) AS CaseHash
	,CONVERT(CHAR(66),ISNULL(P.ParticipantHash, CAST(0x0 AS BINARY(32))) ,1) AS ParticipantHash
	,CASE WHEN BSAT.ValidFrom IS NULL THEN -1 ELSE CAST(CONVERT(CHAR(8),BSAT.ValidFrom,112) AS INT)END AS ValidFromKey
	,-1
	,CASE WHEN BSAT.BarrierStatus IS NULL THEN CONVERT(CHAR(66),CAST(0x0 AS BINARY(32)),1) ELSE CONVERT(CHAR(66),CAST(HASHBYTES('SHA2_256',CAST(CAST(BSAT.BarrierStatus AS INT) AS VARCHAR)) AS BINARY(32)),1) END AS BarrierStatusHash
	,CONVERT(CHAR(66),ISNULL(R.ReferralHash, CAST(0x0 AS BINARY(32))) ,1) AS ReferralHash
	,CONVERT(CHAR(66),ISNULL(Pr.ProgrammeHash, CAST(0x0 AS BINARY(32))),1) AS ProgrammeHash
	,CONVERT(CHAR(66),ISNULL(DS.DeliverySiteHash, CAST(0x0 AS BINARY(32))),1) AS DeliverySiteHash
	,CONVERT(CHAR(66),ISNULL(E.EmployeeHash, CAST(0x0 AS BINARY(32))),1) AS EmployeeHash
	,CASE WHEN SRAC.ReferralDate IS NULL THEN -1 ELSE CAST(CONVERT(CHAR(8),SRAC.ReferralDate,112) AS INT) END AS ReferralDateKey
	,CASE WHEN SCAD.StartDate IS NULL THEN -1 ELSE CAST(CONVERT(CHAR(8),SCAD.StartDate,112) AS INT) END AS StartDateKey
	,-1 AS VerifiedDateKey
	,CASE WHEN SCAD.LeaveDate IS NULL THEN -1 ELSE CAST(CONVERT(CHAR(8),SCAD.LeaveDate,112) AS INT) END AS LeaveDateKey
	,-1 AS ProjectedLeaveDateKey
	,1 AS IsBarrier
	,CASE WHEN BSAT.ValidTo IS NULL THEN 1 ELSE 0 END AS IsOpenBarrier
	,CASE WHEN BSAT.ValidTo IS NOT NULL AND BSAT.BarrierStatus <> '8253473' THEN 1 ELSE 0 END AS IsClosedBarrier
	,CASE WHEN BSAT.BarrierStatus = '8253471' THEN 1 ELSE 0 END AS IsNewBarrier
	,CASE WHEN BSAT.BarrierStatus = '8253472' THEN 1 ELSE 0 END AS IsInProgress
	,CASE WHEN BSAT.BarrierStatus = '8253473' THEN 1 ELSE 0 END AS IsComplete
	,CASE WHEN BSAT.ValidTo IS NOT NULL THEN 1 ELSE 0 END AS IsClosedorComplete
	,BSAT.BarrierValue AS BarrierScore
FROM DV.HUB_Barriers b
	LEFT JOIN DV.LINK_Case_Barriers cb ON cb.BarriersHash = b.BarriersHash 
	LEFT JOIN DV.LINK_Case_Participant p ON p.CaseHash = cb.CaseHash 
	LEFT JOIN DV.SAT_Barriers_Iconi_Core BSAT ON BSAT.BarriersHash = cb.BarriersHash AND BSAT.IsCurrent = 1
	LEFT JOIN DV.LINK_Case_Referral R ON R.CaseHash = cb.CaseHash 
	LEFT JOIN DV.LINK_Referral_Programme Pr ON Pr.ReferralHash = R.ReferralHash 
	LEFT JOIN DV.LINK_Case_DeliverySite DS ON DS.CaseHash = cb.CaseHash 
	LEFT JOIN DV.LINK_Case_Employee E ON E.CaseHash = cb.CaseHash 
	LEFT JOIN BV.LINK_Referral_ReferralStatus RSS ON RSS.ReferralHash = R.ReferralHash
	LEFT JOIN DV.SAT_Case_Iconi_Dates SCAD ON SCAD.CaseHash = cb.CaseHash AND SCAD.IsCurrent = 1
	LEFT JOIN DV.SAT_Referral_Iconi_Core SRAC ON SRAC.ReferralHash = R.ReferralHash AND SRAC.IsCurrent = 1
WHERE
	b.RecordSource = 'ICONI.Barrier';
GO
