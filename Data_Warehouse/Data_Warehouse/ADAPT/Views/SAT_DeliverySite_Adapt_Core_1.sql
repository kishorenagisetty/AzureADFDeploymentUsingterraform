CREATE VIEW [ADAPT].[SAT_DeliverySite_Adapt_Core] AS WITH cte_del AS 
(
SELECT 
CONCAT_WS('|','ADAPT',CAST(Reference AS INT)) AS DeliverySiteKey,
CG.NAME AS DeliverySiteName,
CAST(CG.STATUS AS INT) AS Status,
CAST(CG.CAPACITY AS INT) AS Capacity,
CAST(CG.VENUE_TYPE AS INT) AS VenueType,
CG.ValidFrom, CG.ValidTo, CG.IsCurrent
FROM ADAPT.PROP_CLIENT_GEN CG 
WHERE REFERENCE IN (
	SELECT DISTINCT CORE_PROVID FROM ADAPT.PROP_WP_GEN W)
),cte_rz AS 
(
SELECT DISTINCT 
Zone,
CoreProvider,
Reporting_Region AS ReportingRegion,
Reporting_Area_Branch AS ReportingAreaBranch,
Reporting_Zone AS ReportingZone,
Baan_Region AS BaanRegion,
Baan_Area_Branch AS BaanAreaBranch,
Baan_Zone AS BaanZone,
DS_Region AS DSRegion,
TempID,
Ofsted,
ROM,
Delivery,
BranchManager,
BranchManagerEmail,
ROM_Email AS ROMEmail,
WPSite,
Email_CC AS EmailCC,
CPA,
NorthSouth,
QualityManager,
IsActive,
Reporting_Hierarchy AS ReportingHierarchy,
Region_SES AS RegionSES,
BranchOwner,
FinanceName,
BranchManagerEmpNo,
WHPLot,
DataOwner
FROM ELT.LK_RegionZones 
WHERE
CoreProvider <> ' '
)
SELECT
d.DeliverySiteKey,
d.DeliverySiteName,
d.Status,
rz.Zone,
rz.ReportingRegion, 
rz.ReportingAreaBranch, 
rz.ReportingZone, 
rz.BaanRegion,
rz.BaanAreaBranch,
rz.BaanZone,
rz.DSRegion,
rz.TempID,
rz.Ofsted,
rz.ROM,
rz.Delivery,
rz.BranchManager,
rz.BranchManagerEmail,
rz.ROMEmail,
rz.WPSite,
rz.EmailCC,
rz.CPA,
rz.NorthSouth,
rz.QualityManager,
rz.IsActive,
rz.ReportingHierarchy,
rz.RegionSES,
rz.BranchOwner,
rz.FinanceName,
rz.BranchManagerEmpNo,
rz.WHPLot,
rz.DataOwner,
d.ValidFrom,
d.ValidTo,
d.IsCurrent
FROM cte_del d
INNER JOIN cte_rz rz ON rz.CoreProvider = d.DeliverySiteName;
GO
