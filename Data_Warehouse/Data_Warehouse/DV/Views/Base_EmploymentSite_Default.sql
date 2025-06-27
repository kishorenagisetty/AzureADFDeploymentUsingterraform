CREATE VIEW [DV].[Base_EmploymentSite_Default]
AS SELECT
	CONVERT(CHAR(66),CAST(0x0 AS BINARY(32)) ,1)	AS EmploymentSiteHash,
	CAST('Unknown' AS VARCHAR(50))					AS RecordSource,
	CAST('Unknown' AS NVARCHAR(MAX))				AS EmploymentSiteName,
	CAST('Unknown' AS NVARCHAR(MAX))				AS EmploymentSiteStatus,
	CAST('Unknown' AS NVARCHAR(MAX))				AS EmploymentSiteWebsiteAddress,
	CAST('Unknown' AS NVARCHAR(MAX))				AS EmploymentSiteSource,
	CAST('Unknown' AS NVARCHAR(MAX))				AS EmploymentSiteNumberOfEmployees,
	CAST('Unknown' AS NVARCHAR(MAX))				AS EmploymentSiteLocation,
	CAST('Unknown' AS NVARCHAR(MAX))				AS EmploymentSiteBlacklisted,
	CAST('Unknown' AS NVARCHAR(MAX))				AS EmploymentSiteTradingName,
	CAST('Unknown' AS NVARCHAR(MAX))				AS EmploymentSiteRegion,
	CAST('Unknown' AS NVARCHAR(MAX))				AS EmploymentSiteSIC,
	CAST('Unknown' AS NVARCHAR(MAX))				AS EmploymentSiteIncorporationType,
	CAST('Unknown' AS NVARCHAR(MAX))				AS EmploymentSiteCreditStatus,
	CAST('Unknown' AS NVARCHAR(MAX))				AS EmploymentSiteManagedType;
GO