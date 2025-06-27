CREATE VIEW [DV].[Base_EmploymentSite_Adapt]
AS SELECT
	CONVERT(CHAR(66),E.EmploymentSiteHash,1)					AS EmploymentSiteHash,
	E.RecordSource												AS RecordSource,
	ES.EmploymentSiteName										AS EmploymentSiteName,
	E_S.[Description]											AS EmploymentSiteStatus,
	ES.EmploymentSiteWebsiteAddress								AS EmploymentSiteWebsiteAddress,
	CAST(ES.EmploymentSiteSource AS NVARCHAR(MAX))				AS EmploymentSiteSource,
	CAST(ES.EmploymentSiteNumberOfEmployees AS NVARCHAR(MAX))	AS EmploymentSiteNumberOfEmployees,
	E_L.[Description]											AS EmploymentSiteLocation,
	ES.EmploymentSiteBlacklisted								AS EmploymentSiteBlacklisted,
	ES.EmploymentSiteTradingName								AS EmploymentSiteTradingName,
	E_R.[Description]											AS EmploymentSiteRegion,
	E_SIC.[Description]											AS EmploymentSiteSIC,
	E_IT.[Description]											AS EmploymentSiteIncorporationType,
	E_CS.[Description]											AS EmploymentSiteCreditStatus,
	E_MT.[Description]											AS EmploymentSiteManagedType

FROM
	DV.HUB_EmploymentSite							AS E
	INNER JOIN
	DV.SAT_EmploymentSite_Adapt_Core					AS ES
	ON E.EmploymentSiteKey = ES.EmploymentSiteKey AND ES.IsCurrent = 1
	LEFT JOIN DV.Dimension_References					AS E_S 
	ON E_S.Code = ES.EmploymentSiteStatus 
	AND E_S.ReferenceSource = 'ADAPT.MD_MULTI_NAMES' 
	AND E_S.Category = 'Code'
	LEFT JOIN DV.Dimension_References					AS E_L 
	ON E_L.Code = ES.EmploymentSiteLocation 
	AND E_L.ReferenceSource = 'ADAPT.MD_MULTI_NAMES' 
	AND E_L.Category = 'Code'
	LEFT JOIN DV.Dimension_References					AS E_R
	ON E_R.Code = ES.EmploymentSiteRegion 
	AND E_R.ReferenceSource = 'ADAPT.MD_MULTI_NAMES' 
	AND E_R.Category = 'Code'
	LEFT JOIN DV.Dimension_References					AS E_MT
	ON E_MT.Code = ES.EmploymentSiteManagedType 
	AND E_MT.ReferenceSource = 'ADAPT.MD_MULTI_NAMES' 
	AND E_MT.Category = 'Code'
	LEFT JOIN DV.Dimension_References					AS E_SIC
	ON E_SIC.Code = ES.EmploymentSiteSIC 
	AND E_SIC.ReferenceSource = 'ADAPT.MD_MULTI_NAMES' 
	AND E_SIC.Category = 'Code'
	LEFT JOIN DV.Dimension_References					AS E_IT
	ON E_IT.Code = ES.EmploymentSiteIncorporationType 
	AND E_IT.ReferenceSource = 'ADAPT.MD_MULTI_NAMES' 
	AND E_IT.Category = 'Code'
	LEFT JOIN DV.Dimension_References					AS E_CS
	ON E_CS.Code = ES.EmploymentSiteCreditStatus
	AND E_CS.ReferenceSource = 'ADAPT.MD_MULTI_NAMES' 
	AND E_CS.Category = 'Code'
	WHERE E.RecordSource = 'ADAPT.PROP_CLIENT_GEN';
GO

