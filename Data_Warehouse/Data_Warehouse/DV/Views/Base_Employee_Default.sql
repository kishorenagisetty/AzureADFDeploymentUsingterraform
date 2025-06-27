CREATE VIEW [DV].[Base_Employee_Default]
AS SELECT
	CONVERT(CHAR(66),CAST(0x0 AS BINARY(32)),1) EmployeeHash,
	CAST('Unknown' AS VARCHAR(50)) AS RecordSource,
	CAST('Unknown' AS NVARCHAR(MAX)) AS EmployeeName,
	CAST('Unknown' AS NVARCHAR(MAX)) AS EmployeeFirstName,
	CAST('Unknown' AS NVARCHAR(MAX)) AS EmployeeLastName,
	CAST(0 AS INT) AS EmployeeAgency,
	CAST('Unknown' AS NVARCHAR(MAX)) AS EmployeeEmail,
	CAST(NULL AS NVARCHAR(MAX)) AS EmployeeSuspendedDate,
	CAST('Unknown' AS NVARCHAR(MAX)) AS EmployeeType,
	CAST(0 AS INT) AS EmployeeOrganisation,
	CAST(NULL AS NVARCHAR(MAX)) AS EmployeeAddedDate,
	CAST('Unknown' AS NVARCHAR(MAX)) AS EmployeeUsername,
	CAST('Unknown' AS NVARCHAR(MAX)) AS EmployeeSupportsOver50,
	CAST(0 AS BIT) AS EmployeeLocked,
	CAST('Unknown' AS NVARCHAR(MAX)) AS EmployeeSsoIdentifier,
	CAST(0 AS BIT) AS EmployeeSsoEnabled,
	CAST('Unknown' AS NVARCHAR(MAX)) AS EmployeeJobTitle,
	CAST('Unknown' AS NVARCHAR(MAX)) AS EmployeeNotes,
	CAST(NULL AS NVARCHAR(MAX)) AS EmployeeLastLogin,
	CAST(0 AS BIT) AS EmployeeArchive,
	CAST(0 AS INT) AS EmployeeTimeoutTimer,
	CAST(0 AS INT) AS EmployeeLicencingProg,
	CAST(NULL AS NVARCHAR(MAX)) AS EmployeeLastUpdatedDate,
	CAST('Unknown' AS NVARCHAR(MAX)) AS Team;
GO

