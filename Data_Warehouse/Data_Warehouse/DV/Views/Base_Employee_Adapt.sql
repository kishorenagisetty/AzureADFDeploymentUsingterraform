CREATE VIEW [DV].[Base_Employee_Adapt]
AS SELECT 
	CONVERT(CHAR(66),E.EmployeeHash, 1) AS EmployeeHash,
	E.RecordSource,
	E_AC.EmployeeName,
	E_AC.EmployeeFirstName,
	E_AC.EmployeeLastName,
	CAST(NULL AS NVARCHAR(MAX)) AS EmployeeAgency,
	E_AC.EmployeeEmail,
	CAST(NULL AS NVARCHAR(MAX)) AS EmployeeSuspendedDate,
	CAST(NULL AS NVARCHAR(MAX)) AS EmployeeType,
	CAST(NULL AS INT) AS EmployeeOrganisation,
	CAST(NULL AS NVARCHAR(MAX)) AS EmployeeAddedDate,
	CAST(NULL AS NVARCHAR(MAX)) AS EmployeeUsername,
	CAST(NULL AS NVARCHAR(MAX)) AS EmployeeSupportsOver50,
	CAST(0 AS BIT) AS EmployeeLocked,
	CAST(NULL AS NVARCHAR(MAX)) AS EmployeeSsoIdentifier,
	CAST(NULL AS INT) AS EmployeeSsoEnabled,
	E_AC.JobTitle,
	CAST(NULL AS NVARCHAR(MAX)) AS EmployeeNotes,
	CAST(NULL AS NVARCHAR(MAX)) AS EmployeeLastLogin,
	CAST(0 AS BIT) AS EmployeeArchive,
	CAST(0 AS INT) AS EmployeeTimeoutTimer,
	CAST(0 AS INT) AS EmployeeLicencingProg,
	CAST(NULL AS NVARCHAR(MAX)) AS EmployeeLastUpdatedDate,
	CAST(NULL AS NVARCHAR(MAX)) AS Team
FROM DV.HUB_Employee E
	INNER JOIN DV.SAT_Employee_Adapt_Core E_AC ON E_AC.EmployeeHash = E.EmployeeHash and E_AC.IsCurrent = 1
WHERE E.RecordSource = 'ADAPT.PROP_EMPLOYEE_GEN';
GO

