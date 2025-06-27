CREATE VIEW [DV].[Base_Employee_Iconi]
AS SELECT
	CONVERT(CHAR(66),E.EmployeeHash, 1) AS EmployeeHash,
	E.RecordSource,
	EmployeeFullName,
	EmployeeFirstName,
	EmployeeLastName,
	EmployeeAgency,
	EmployeeEmail,
	EmployeeSuspendedDate,
	EmployeeType,
	EmployeeOrganisation,
	EmployeeAddedDate,
	EmployeeUsername,
	EmployeeSupportsOver50,
	EmployeeLocked,
	EmployeeSsoIdentifier,
	EmployeeSsoEnabled,
	EmployeeJobTitle,
	EmployeeNotes,
	EmployeeLastLogin,
	EmployeeArchive,
	EmployeeTimeoutTimer,
	EmployeeLicencingProg,
	EmployeeLastUpdatedDate,
	CAST(NULL AS NVARCHAR(MAX)) AS Team
FROM DV.HUB_Employee E
	INNER JOIN DV.SAT_Employee_Iconi_Core E_IC ON E_IC.EmployeeHash = E.EmployeeHash and E_IC.IsCurrent = 1
WHERE E.RecordSource = 'ICONI.User';
GO

