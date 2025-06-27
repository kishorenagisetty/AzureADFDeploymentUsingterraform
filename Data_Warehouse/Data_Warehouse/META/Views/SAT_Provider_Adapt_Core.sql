CREATE VIEW [META].[SAT_Provider_Adapt_Core] 
AS (
SELECT
	CONCAT_WS('|','META',CoreProvider)				AS ProviderKey
	,[Zone]
	,Reporting_Region
	,Reporting_Area_Branch
	,Reporting_Zone
	,Baan_Region
	,Baan_Area_Branch
	,Baan_Zone
	,DS_Region
	,TempID
	,Ofsted
	,ROM
	,Delivery
	,CoreProvider
	,ID
	,BranchManager
	,BranchManagerEmail
	,ROM_Email
	,WPSite
	,Email_CC
	,CPA
	,NorthSouth
	,QualityManager
	,IsActive
	,Reporting_Hierarchy
	,Region_SES
	,BranchOwner
	,FinanceName
	,BranchManagerEmpNo
	,WHPLot
	,DataOwner
	,ValidFrom 
	,ValidTo
	,IsCurrent 
FROM (
		SELECT
		rn = row_number() OVER (PARTITION BY CoreProvider ORDER BY ID)
		,CONCAT_WS('|','META',CoreProvider)				AS ProviderKey
		,[Zone]
		,Reporting_Region
		,Reporting_Area_Branch
		,Reporting_Zone
		,Baan_Region
		,Baan_Area_Branch
		,Baan_Zone
		,DS_Region
		,TempID
		,Ofsted
		,ROM
		,Delivery
		,CoreProvider
		,ID
		,BranchManager
		,BranchManagerEmail
		,ROM_Email
		,WPSite
		,Email_CC
		,CPA
		,NorthSouth
		,QualityManager
		,IsActive
		,Reporting_Hierarchy
		,Region_SES
		,BranchOwner
		,FinanceName
		,BranchManagerEmpNo
		,WHPLot
		,DataOwner
		,CAST(getdate() AS DATE)			AS ValidFrom 
		,'9999-12-31 00:00:00'				AS ValidTo
		,IsActive							AS IsCurrent 
		FROM 
		[ELT].[LK_RegionZones]
		WHERE CoreProvider != ''
		) x
WHERE (rn = 1)
);
GO