CREATE VIEW [DV].[Base_Assignment_Iconi] AS SELECT
	CONVERT(CHAR(66),A.AssignmentHash,1)		AS AssignmentHash,
	A.RecordSource,
	IC.AssignmentID,
	IC.AssignmentTitle,
	IC.AssignmentStartContractType,
	IC.AssignmentType,
	IC.AssignmentStatus,
	IC.AssignmentLeaveReason,
	CAST(NULL AS NVARCHAR)						AS AssignmentIndustry,
	CAST(NULL AS NVARCHAR)						AS WorkRelatedActivityType,
	CAST(IC.WeeklyHours AS NUMERIC(5,2))		AS ContractedHours,
	CAST(NULL AS NVARCHAR)						AS AssignmentStartClaimYear,
	CAST(NULL AS NVARCHAR)						AS AssignmentOutcomeTwoClaimYear,
	CAST(NULL AS NVARCHAR)						AS AssignmentOutcomeOneClaimYear,
	IC.SelfEmployed,
	CAST(NULL AS NVARCHAR)						AS DiscountMilestone,
	S_EC.EmployeeFullName						AS AssignmentOwningEmployee,
	CAST(NULL AS NVARCHAR)						AS AssignmentStartPaymentCycle,
	CAST(NULL AS NVARCHAR)						AS AssignmentSelfEmployedVerified,
	IC.WageCategory,
	CAST(IC.WeeklyHours AS NUMERIC(5,2))		AS WeeklyHours,
	CAST(NULL AS NVARCHAR)						AS WageException,
	IC.TempPerm

FROM
DV.HUB_Assignment A
LEFT JOIN DV.SAT_Assignment_Iconi_Core AS IC ON A.AssignmentHash = IC.AssignmentHash and IC.IsCurrent = 1
LEFT JOIN DV.LINK_Case_Assignment AS L_CA ON A.AssignmentHash = L_CA.AssignmentHash
LEFT JOIN DV.LINK_Case_Employee AS L_CE ON L_CA.CaseHash = L_CE.CaseHash
LEFT JOIN DV.SAT_Employee_Iconi_Core AS S_EC ON L_CE.EmployeeHash = S_EC.EmployeeHash
WHERE A.RecordSource = 'ICONI.Assignment';
GO

