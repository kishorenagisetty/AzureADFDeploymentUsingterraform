CREATE VIEW [DV].[Base_DeliverySite_Adapt] AS 
SELECT
CONVERT(CHAR(66),H.DeliverySiteHash ,1) AS DeliverySiteHash,
H.RecordSource,
S_AC.DeliverySiteName,
R_S.Description AS Status,
S_AC.Zone,
S_AC.ReportingRegion AS ReportingRegion,
S_AC.ReportingAreaBranch AS ReportingAreaBranch,
S_AC.ReportingZone AS ReportingZone,
S_AC.BaanRegion AS BaanRegion,
S_AC.BaanAreaBranch AS BaanAreaBranch,
S_AC.BaanZone AS BaanZone,
S_AC.DSRegion AS DSRegion,
S_AC.TempID,
S_AC.Ofsted,
S_AC.ROM,
S_AC.Delivery,
S_AC.BranchManager,
S_AC.BranchManagerEmail,
S_AC.ROMEmail AS ROMEmail,
S_AC.WPSite,
S_AC.EmailCC AS EmailCC,
S_AC.CPA,
S_AC.NorthSouth,
S_AC.QualityManager,
S_AC.IsActive,
S_AC.ReportingHierarchy AS ReportingHierarchy,
S_AC.RegionSES AS RegionSES,
S_AC.BranchOwner,
S_AC.FinanceName,
S_AC.BranchManagerEmpNo,
S_AC.WHPLot,
S_AC.DataOwner,
DDA = CASE WHEN S_AC.ReportingRegion = 'South East Wales' THEN 1 ELSE 0 END
FROM 
DV.HUB_DeliverySite H
LEFT JOIN DV.SAT_DeliverySite_Adapt_Core S_AC ON H.DeliverySiteHash = S_AC.DeliverySiteHash AND S_AC.IsCurrent = 1
LEFT JOIN DV.Dimension_References R_S ON R_S.Code = S_AC.Status  AND R_S.ReferenceSource = 'ADAPT.MD_MULTI_NAMES' AND R_S.Category = 'Code'
WHERE H.RecordSource = 'ADAPT.PROP_CLIENT_GEN';
GO
