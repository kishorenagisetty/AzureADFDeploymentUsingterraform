CREATE VIEW [DV].[Base_Case_Adapt] AS SELECT 
CONVERT(CHAR(66),C.CaseHash,1) AS CaseHash,
CAST(C.CaseKey AS VARCHAR) AS CaseID,
R_CDS.Description AS CaseDevelopmentStatus,
R_CMS.Description AS CaseModuleStatus,
CASE WHEN R_CS.Description IS NULL THEN 'Unknown' ELSE R_CS.Description END AS CaseStatus,
R_PB.Description AS PrimaryBenefit,
R_LR.Description AS LeaveReason,
R_WRS.Description AS WorkRedinessStatus,
CAST(NULL AS NVARCHAR(MAX)) AS FrequencyOfContact,
CAST(NULL AS NVARCHAR(MAX)) AS TranOwnerUserId,
CAST(NULL AS NVARCHAR(MAX)) AS Outcome,
CAST(NULL AS NVARCHAR(MAX)) AS PackIssued,
CAST(NULL AS NVARCHAR(MAX)) AS CredReceipt,
CAST(NULL AS NVARCHAR(MAX)) AS SustainedEarnings,
CAST(NULL AS NVARCHAR(MAX)) AS ToWork,
CAST(NULL AS NVARCHAR(MAX)) AS EnglandWales,
CAST(NULL AS NVARCHAR(MAX)) AS WorkingAge,
CAST(NULL AS NVARCHAR(MAX)) AS DwpEmployment,
CAST(NULL AS NVARCHAR(MAX)) AS NotInControlGroupOrPublicSectorComparator,
CAST(NULL AS NVARCHAR(MAX)) AS EmployabilityExoffender,
CAST(NULL AS NVARCHAR(MAX)) AS EligibilityConfirmed,
CAST(NULL AS NVARCHAR(MAX)) AS EmploymentInterests,
CAST(NULL AS NVARCHAR(MAX)) AS ExitReasonOther,
CAST(NULL AS NVARCHAR(MAX)) AS OnwardDestination,
CAST(NULL AS NVARCHAR(MAX)) AS OnwardDestinationOther,
CAST(NULL AS NVARCHAR(MAX)) AS LeftReason,
CAST(NULL AS NVARCHAR(MAX)) AS LeftReasonOther,
CAST(NULL AS NVARCHAR(MAX)) AS LeftStage,
CAST(NULL AS NVARCHAR(MAX)) AS LeftStageOther,
CAST(NULL AS NVARCHAR(MAX)) AS DidNotStartReason,
CAST(NULL AS NVARCHAR(MAX)) AS DidNotStartReasonOther,
CAST(NULL AS NVARCHAR(MAX)) AS SignedPrivacyNoticeUploaded,
CAST(NULL AS NVARCHAR(MAX)) AS PrivacyRightsDetails,
CAST(NULL AS NVARCHAR(MAX)) AS PrivacyRightsExcercised,
CAST(NULL AS NVARCHAR(MAX)) AS DisengagedReason
FROM DV.SAT_Case_Adapt_Core C
LEFT JOIN DV.Dimension_References R_CDS ON R_CDS.Code = C.CaseDevelopmentStatus AND R_CDS.Category = 'CODE' AND R_CDS.ReferenceSource = 'ADAPT.MD_MULTI_NAMES'
LEFT JOIN DV.Dimension_References R_CMS ON R_CMS.Code = C.CaseModuleStatus AND R_CMS.Category = 'CODE' AND R_CMS.ReferenceSource = 'ADAPT.MD_MULTI_NAMES'
LEFT JOIN DV.Dimension_References R_PB ON R_PB.Code = C.PrimaryBenefit AND R_PB.Category = 'CODE' AND R_PB.ReferenceSource = 'ADAPT.MD_MULTI_NAMES'
LEFT JOIN DV.Dimension_References R_LR ON R_LR.Code = C.LeaveReason AND R_LR.Category = 'CODE' AND R_LR.ReferenceSource = 'ADAPT.MD_MULTI_NAMES'
LEFT JOIN DV.Dimension_References R_WRS ON R_WRS.Code = C.WorkRedinessStatus AND R_WRS.Category = 'CODE' AND R_WRS.ReferenceSource = 'ADAPT.MD_MULTI_NAMES'
LEFT JOIN DV.Dimension_References R_CS ON R_CS.Code = C.CaseStatus AND R_CS.Category = 'CODE' AND R_CS.ReferenceSource = 'ADAPT.MD_MULTI_NAMES'
WHERE C.IsCurrent = 1;
GO
