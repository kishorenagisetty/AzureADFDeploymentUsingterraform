CREATE VIEW [dwh].[dim_DeliverySite] AS select		distinct
			convert(char(66),del.DeliverySiteHash ,1)				as DeliverySiteHash
			,del.RecordSource										as RecordSource
			,replace(sac.DeliverySiteName, 'Remploy', 'Maximus')	as DeliverySiteName
			,mu1.Description										as Status
			--,sac.Capacity											as Capacity
			--,mu2.Description										as VenueType
			,pac.Zone												as Zone
			,pac.Reporting_Region									as ReportingRegion
			,pac.Reporting_Area_Branch								as ReportingAreaBranch
			,pac.Reporting_Zone										as ReportingZone
			,pac.Baan_Region										as BaanRegion
			,pac.Baan_Area_Branch									as BaanAreaBranch
			,pac.Baan_Zone											as BaanZone
			,pac.DS_Region											as DSRegion
			,pac.TempID												as TempID
			,pac.Ofsted												as Ofsted
			,pac.ROM												as ROM
			,pac.Delivery											as Delivery
			,pac.BranchManager										as BranchManager
			,pac.BranchManagerEmail									as BranchManagerEmail
			,pac.ROM_Email											as ROMEmail
			,pac.WPSite												as WPSite
			,pac.Email_CC											as EmailCC
			,pac.CPA												as CPA
			,pac.NorthSouth											as NorthSouth
			,pac.QualityManager										as QualityManager
			,pac.IsActive											as IsActive
			,pac.Reporting_Hierarchy								as ReportingHierarchy
			,pac.Region_SES											as RegionSES
			,pac.BranchOwner										as BranchOwner
			,pac.FinanceName										as FinanceName
			,pac.BranchManagerEmpNo									as BranchManagerEmpNo
			,pac.WHPLot												as WHPLot
			,pac.DataOwner											as DataOwner
			,case when pac.Reporting_Region = 'South East Wales' then 1 else 0 end as DDA
from		DV.HUB_DeliverySite				del
left join	DV.SAT_DeliverySite_Adapt_Core	sac on sac.DeliverySiteHash = del.DeliverySiteHash and sac.IsCurrent = 1
left join	DV.LINK_DeliverySite_Provider	sdp on sdp.DeliverySiteHash = del.DeliverySiteHash
left join	DV.SAT_Provider_Adapt_Core		pac on pac.ProviderHash = sdp.ProviderHash AND pac.IsCurrent = 1
left join	DV.SAT_References_MDMultiNames	mu1 on mu1.ID = sac.Status			and mu1.IsCurrent = 1 and mu1.Type = 'Code'
--left join	DV.SAT_References_MDMultiNames	mu2 on mu2.ID = sac.VenueType		and mu2.IsCurrent = 1 and mu2.Type = 'Code'
where		del.RecordSource = 'ADAPT.PROP_CLIENT_GEN'
union all
select		convert(char(66),hashbytes('SHA2_256','BridgeVale'),1)	as DeliverySiteHash
			,'ADAPT.PROP_CLIENT_GEN'								as RecordSource
			,'Maximus WHP Bridgend & Vale of Glamorgan Old'			as DeliverySiteName			  
			,'Live'													as Status
			--,sac.Capacity											as Capacity
			--,mu2.Description										as VenueType
			,'WHP_CDF'												as Zone
			,'South East Wales'										as ReportingRegion
			,'Branch'												as ReportingAreaBranch
			,'ES Bridgend & Vale'									as ReportingZone
			,'107'													as BaanRegion
			,'533'													as BaanAreaBranch
			,'106'													as BaanZone
			,null													as DSRegion
			,null													as TempID
			,null													as Ofsted
			,'Paul Walters'											as ROM
			,'WHP'													as Delivery
			,'Leanne Price'											as BranchManager
			,'leanne.price@maximusuk.co.uk'							as BranchManagerEmail
			,'paul.walters@remploy.co.uk'							as ROMEmail
			,null													as WPSite
			,'huw.williams@maximusuk.co.uk'							as EmailCC
			,null													as CPA
			,'South'												as NorthSouth
			,null													as QualityManager
			,1														as IsActive
			,'ES Cardiff WHP'										as ReportingHierarchy
			,null													as RegionSES
			,'Maximus'												as BranchOwner
			,null													as FinanceName
			,null													as BranchManagerEmpNo
			,'Wales'												as WHPLot
			,'Maximus'												as DataOwner
			,1														as DDA;