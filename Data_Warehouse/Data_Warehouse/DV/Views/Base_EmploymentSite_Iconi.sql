CREATE VIEW [DV].[Base_EmploymentSite_Iconi]
AS SELECT
	CONVERT(CHAR(66),E.EmploymentSiteHash,1)				AS EmploymentSiteHash,
	E.RecordSource											AS RecordSource,
	CAST(NULL AS NVARCHAR(MAX))								AS EmploymentSiteName,
	ES.EmployerStatus										AS EmploymentSiteStatus,
	CAST(NULL AS NVARCHAR(MAX))								AS EmploymentSiteWebsiteAddress,
	CAST(ES.EmployerSource AS NVARCHAR(MAX))				AS EmploymentSiteSource,
	CAST(ES.EmployerNumberOfEmployees AS NVARCHAR(MAX))		AS EmploymentSiteNumberOfEmployees,
	CAST(NULL AS NVARCHAR(MAX))								AS EmploymentSiteBlacklisted,
	CAST(NULL AS NVARCHAR(MAX))								AS EmploymentSiteTradingName,
	CAST(NULL AS NVARCHAR(MAX))								AS EmploymentSiteLocation,
	CAST(NULL AS NVARCHAR(MAX))								AS EmploymentSiteRegion,
	ES.EmployerSIC											AS EmploymentSiteSIC,
	ES.EmployerIncorporationType							AS EmploymentSiteIncorporationType,
	CAST(NULL AS NVARCHAR(MAX))								AS EmploymentSiteCreditStatus,
	CAST(NULL AS NVARCHAR(MAX))								AS EmploymentSiteManagedType
FROM
	DV.HUB_EmploymentSite								AS E
	INNER JOIN
	DV.SAT_EmploymentSite_Iconi_Core					AS ES
	ON E.EmploymentSiteKey = ES.EmploymentSiteKey
WHERE E.RecordSource = 'ICONI.Organisation';
GO