CREATE VIEW [DV].[Base_Assignment_Adapt] AS 
SELECT
	CONVERT(CHAR(66),A.AssignmentHash,1)		AS AssignmentHash,
	A.RecordSource,
	CAST(AC.AssignmentKey AS VARCHAR)			AS AssignmentID,
	AC.AssignmentTitle,
	R_CT.[Description]							AS AssignmentStartContractType,
	R_AT.[Description]							AS AssignmentType,
	R_AS.[Description]							AS AssignmentStatus,
	R_LR.[Description]							AS AssignmentLeaveReason,
	R_AI.[Description]							AS AssignmentIndustry,
	R_WR.[Description]							AS WorkRelatedActivityType,
	AC.ContractedHours,
	AC.AssignmentStartClaimYear,
	AC.AssignmentOutcomeTwoClaimYear,
	AC.AssignmentOutcomeOneClaimYear,
	AC.SelfEmployed,
	AC.DiscountMilestone,
	coalesce(Emp.[Name], 'None Stated')			AS AssignmentOwningEmployee,
	R_PC.[Description]							AS AssignmentStartPaymentCycle,
	AC.AssignmentSelfEmployedVerified,
	R_WC.[Description]							AS WageCategory,
	AC.WeeklyHours,
	AC.WageException,
	R_TP.[Description]							AS TempPerm
FROM
DV.HUB_Assignment A
LEFT JOIN DV.SAT_Assignment_Adapt_Core AS AC ON A.AssignmentHash = AC.AssignmentHash AND AC.IsCurrent = 1
LEFT JOIN DV.Dimension_References R_TP ON R_TP.Code = AC.TempPerm AND R_TP.ReferenceSource = 'ADAPT.MD_MULTI_NAMES' AND R_TP.Category = 'Code'
LEFT JOIN DV.Dimension_References R_AT ON R_AT.Code = AC.AssignmentType AND R_AT.ReferenceSource = 'ADAPT.MD_MULTI_NAMES' AND R_AT.Category = 'Code'
LEFT JOIN DV.Dimension_References R_CT ON R_CT.Code = AC.AssignmentStartContractType AND R_CT.ReferenceSource = 'ADAPT.MD_MULTI_NAMES' AND R_CT.Category = 'Code'
LEFT JOIN DV.Dimension_References R_AS ON R_AS.Code = AC.AssignmentStatus AND R_AS.ReferenceSource = 'ADAPT.MD_MULTI_NAMES' AND R_AS.Category = 'Code'
LEFT JOIN DV.Dimension_References R_LR ON R_LR.Code = AC.AssignmentLeaveReason AND R_LR.ReferenceSource = 'ADAPT.MD_MULTI_NAMES' AND R_LR.Category = 'Code'
LEFT JOIN DV.Dimension_References R_AI ON R_AI.Code = AC.AssignmentIndustry AND R_AI.ReferenceSource = 'ADAPT.MD_MULTI_NAMES' AND R_AI.Category = 'Code'
LEFT JOIN DV.Dimension_References R_WR ON R_WR.Code = AC.WorkRelatedActivityType AND R_WR.ReferenceSource = 'ADAPT.MD_MULTI_NAMES' AND R_WR.Category = 'Code'
LEFT JOIN DV.Dimension_References R_PC ON R_PC.Code = AC.AssignmentStartPaymentCycle AND R_PC.ReferenceSource = 'ADAPT.MD_MULTI_NAMES' AND R_PC.Category = 'Code'
LEFT JOIN DV.Dimension_References R_WC ON R_WC.Code = AC.WageCategory AND R_WC.ReferenceSource = 'ADAPT.MD_MULTI_NAMES' AND R_WC.Category = 'Code'
left join ADAPT.PROP_EMPLOYEE_GEN as emp on	AC.AssignmentOwningEmployee = emp.user_ref and AC.IsCurrent = emp.IsCurrent
WHERE A.RecordSource = 'ADAPT.PROP_ASSIG_GEN';
GO