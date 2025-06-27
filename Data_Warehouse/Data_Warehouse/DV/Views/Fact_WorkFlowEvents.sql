CREATE VIEW [DV].[Fact_WorkFlowEvents] 
AS 
SELECT
		F_c.[CaseHash]
		,F_c.[ParticipantHash]
		,F_c.[EmployeeHash]
		,F_c.[ReferralHash] 
		,F_c.[ProgrammeHash] 
		,F_c.[DeliverySiteHash]
		,F_c.[RequestorHash] 
		,F_c.[CaseStatusHash] 
		,F_c.[ReferralStatusHash] 
		,F_c.[ReferralDateKey] 
		,F_c.[StartDateKey]
		,F_c.[StartVerifiedDateKey]
		,F_c.[LeaveDateKey]
		,F_c.[ProjectedLeaveDateKey]
		,F_c.[ReportDateKey] 
		,F_c.[ReferalSLADate]
		,CONVERT(CHAR(66),ISNULL(wfe_typ_lnk.WorkFlowEventTypeHash, CAST(0x0 AS BINARY(32))),1)  WorkFlowEventTypeHash
		,CONVERT(CHAR(66),ISNULL(wfe_e_lnk.EmployeeHash, CAST(0x0 AS BINARY(32))),1)  EventsEmployeeHash
		,CASE WHEN [EventDate] IS NULL THEN -1 ELSE CAST(CONVERT(CHAR(8),[EventDate],112) AS INT) END [EventDate]
		,CASE WHEN [EventEstimatedStartDate] IS NULL THEN -1 ELSE CAST(CONVERT(CHAR(8),[EventEstimatedStartDate],112) AS INT) END [EventEstimatedStartDate]
		,CASE WHEN [EventEstimatedEndDate] IS NULL THEN -1 ELSE CAST(CONVERT(CHAR(8),[EventEstimatedEndDate],112) AS INT) END [EventEstimatedEndDate]
		,CASE WHEN [EventEndDate] IS NULL THEN -1 ELSE CAST(CONVERT(CHAR(8),[EventEndDate],112) AS INT) END [EventEndDate]
		,CASE WHEN [EventSkippedCount] is null then 0 else [EventSkippedCount] end [EventSkippedCount]
		,CASE WHEN wfe_sat.InOutWork IS NULL THEN '' ELSE wfe_sat.InOutWork END InOutWork
		, CASE 
			WHEN wfe_sat.EventDate IS NOT NULL AND wfe_sat.EventEstimatedEndDate IS NOT NULL AND wfe_sat.EventDate <= wfe_sat.EventEstimatedEndDate THEN 'PASS'
			WHEN wfe_sat.EventDate IS NOT NULL AND wfe_sat.EventEstimatedEndDate IS NOT NULL AND wfe_sat.EventDate > wfe_sat.EventEstimatedEndDate THEN 'FAIL'
			WHEN wfe_sat.EventDate IS NOT NULL AND wfe_sat.EventEstimatedEndDate >= GETDATE() THEN 'In Progress'
			ELSE 'Unclassified'
		  END AS SLAStatus
		, CASE 
			WHEN wfe_sat.EventDate IS NOT NULL AND wfe_sat.EventEstimatedEndDate IS NOT NULL AND wfe_sat.EventDate <= wfe_sat.EventEstimatedEndDate THEN 1
			ELSE 0
		  END AS SLAStatusPass
		, CASE 
			WHEN wfe_sat.EventDate IS NOT NULL AND wfe_sat.EventEstimatedEndDate IS NOT NULL AND wfe_sat.EventDate > wfe_sat.EventEstimatedEndDate THEN 1
			ELSE 0
		  END AS SLAStatusFail
		, CASE 
			WHEN wfe_sat.EventDate IS NULL AND wfe_sat.EventEstimatedEndDate >= GETDATE() THEN 1
			ELSE 0
		  END AS SLAStatusInProgress
		, CASE 
			WHEN DD.NextWorkingDay IS NOT NULL
			THEN 1
			ELSE 0
		  END AS DueInNext24Hrs
	FROM [DV].[SAT_WorkFlowEvents_Meta_Core] wfe_sat
	inner join [DV].[LINK_WorkFlowEvents_WorkFlowEventType] wfe_typ_lnk on (wfe_sat.WorkFlowEventsHash = wfe_typ_lnk.WorkFlowEventsHash)
	inner join [DV].[LINK_WorkFlowEvents_Case] wfe_c_lnk on (wfe_sat.WorkFlowEventsHash = wfe_c_lnk.WorkFlowEventsHash)
	left  join [DV].[SAT_Case_Adapt_Core] sat_c_adapt on ( sat_c_adapt.CaseHash = wfe_c_lnk.CaseHash and sat_c_adapt.IsCurrent = 1 )
	left join [DV].[LINK_WorkFlowEvents_Employee] wfe_e_lnk on (wfe_e_lnk.WorkFlowEventsHash =  wfe_sat.WorkFlowEventsHash )
	LEFT JOIN 
	(
		SELECT MIN(A.Date_Skey) AS NextWorkingDay
		FROM DW.D_DATE AS A
		WHERE A.is_business_day = 1 
		  AND A.Date_Skey > FORMAT(GETDATE(), 'yyyyMMdd')
	) AS DD
		ON CAST(CONVERT(CHAR(8), wfe_sat.[EventEstimatedEndDate],112) AS INT) BETWEEN FORMAT(GETDATE(), 'yyyyMMdd') AND DD.NextWorkingDay 
	inner join (
				SELECT 	[CaseHash]
						,[ParticipantHash]
						,[EmployeeHash]
						,[ReferralHash]  
						,[DeliverySiteHash]
						,[RequestorHash] 
						,[CaseStatusHash] 
						,[ReferralStatusHash] 
						,[ReferralDateKey] 
						,[StartDateKey]
						,[StartVerifiedDateKey]
						,[LeaveDateKey]
						,[ProjectedLeaveDateKey]
						,[ReportDateKey] 
						,[ReferalSLADate]
						, MIN(ProgrammeHash) as ProgrammeHash
				FROM [DV].[Fact_Case_Base] F_c 
				GROUP BY [CaseHash]
						,[ParticipantHash]
						,[EmployeeHash]
						,[ReferralHash]  
						,[DeliverySiteHash]
						,[RequestorHash] 
						,[CaseStatusHash] 
						,[ReferralStatusHash] 
						,[ReferralDateKey] 
						,[StartDateKey]
						,[StartVerifiedDateKey]
						,[LeaveDateKey]
						,[ProjectedLeaveDateKey]
						,[ReportDateKey] 
						,[ReferalSLADate]
				) F_c on 
					CONVERT(CHAR(66),ISNULL(wfe_c_lnk.CaseHash,CAST(0x0 AS BINARY(32))),1) = F_c.CaseHash
;
GO
