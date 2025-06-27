CREATE VIEW [ADAPT].[SAT_DeliverySite_LKRegionZones]
AS SELECT 
	CONCAT_WS('|','ADAPT',CAST(REFERENCE AS INT)) AS DeliverySiteKey
	,RZ.[Zone] AS Zone
	,RZ.[Reporting_Region] AS ReportingRegion
	,RZ.[Reporting_Area_Branch] AS ReportingAreaBranch
	,RZ.[Reporting_Zone] AS ReportingZone
	,RZ.[Baan_Region] AS BaanRegion
	,RZ.[Baan_Area_Branch] AS BaanAreaBranch
	,RZ.[Baan_Zone] AS BaanZone
	,RZ.[DS_Region]AS DSRegion
	,RZ.[TempID] AS TempID
	,RZ.[Ofsted] AS Ofsted
	,RZ.[ROM] AS ROM
	,RZ.[Delivery] AS Delivery
	,RZ.[BranchManager] AS BranchManager
	,RZ.[BranchManagerEmail] AS BranchManagerEmail
	,RZ.[ROM_Email] AS ROMEmail
	,RZ.[WPSite] AS WPSite
	,RZ.[Email_CC] AS EmailCC
	,RZ.[CPA] AS CPA
	,RZ.[NorthSouth] AS NorthSouth
	,RZ.[QualityManager] AS QualityManager
	,RZ.[IsActive] AS IsActive
	,RZ.[Reporting_Hierarchy] AS ReportingHierarchy
	,RZ.[Region_SES] AS RegionSES
	,RZ.[BranchOwner] AS BranchOwner
	,RZ.[FinanceName] AS FinanceName
	,RZ.[BranchManagerEmpNo] AS BranchManagerEmpNo
	,RZ.[WHPLot] AS WHPLot
	,RZ.[DataOwner] AS DataOwner
	,CG.ValidFrom, CG.ValidTo, CG.IsCurrent
FROM ADAPT.PROP_CLIENT_GEN CG 
INNER JOIN ADAPT.LK_RegionZones RZ ON RZ.CoreProvider = CG.NAME
WHERE REFERENCE IN (
	SELECT DISTINCT CORE_PROVID FROM ADAPT.PROP_WP_GEN W
);
