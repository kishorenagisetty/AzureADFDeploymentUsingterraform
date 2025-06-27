CREATE VIEW [DV].[Base_Participant_Iconi] AS SELECT
	CONVERT(CHAR(66),H.ParticipantHash ,1) AS ParticipantHash,
	H.RecordSource,
	CAST(I_PC.ParticipantID AS NVARCHAR(MAX)) AS ParticipantID,
	CONCAT(I_PC.FirstName,' ', I_PC.LastName) AS FullName,
	I_PC.Title,
	I_PC.FirstName,
	CAST(NULL AS NVARCHAR(MAX)) AS MiddleName,
	I_PC.LastName,
	CAST(NULL AS NVARCHAR(MAX)) AS KnownAs,
	I_PC.DateOfBirth,
	I_PC.NationalInsuranceNo,
	CAST(NULL AS NVARCHAR(MAX)) AS ValidSMS,
	CAST(I_PCon.SMSOptOut AS NVARCHAR(MAX)) AS SMSOptOut,
	CAST(I_PCon.EmailOptOut AS NVARCHAR(MAX)) AS EmailOptOut,
	CAST(I_PCon.LeaveMessage AS NVARCHAR(MAX)) AS LeaveMessage,
	CAST(NULL AS NVARCHAR(MAX)) AS HasCriminalConviction,
	CAST(NULL AS NVARCHAR(MAX)) AS IsDriver,
	CAST(NULL AS NVARCHAR(MAX)) AS BetterOffCalculationStatus,
	CAST(NULL AS NVARCHAR(MAX)) AS HasOwnTransport,
	CAST(NULL AS NVARCHAR(MAX)) AS MarketingPermissions,
	CAST(NULL AS NVARCHAR(MAX)) AS HasUpToDateCV,
	I_PA.AddressLine1,
	I_PA.AddressLine2,
	I_PA.Locality,
	I_PA.Town,
	I_PA.County,
	I_PA.PostCode,
	CAST(NULL AS INT) AS PostCodeSector,
	I_PCon.TelephoneHome,
	I_PCon.TelephoneMobile,
	CAST(NULL AS NVARCHAR(MAX)) AS TelephoneWork,
	CAST(NULL AS NVARCHAR(MAX)) AS EmailWork,
	CAST(NULL AS NVARCHAR(MAX)) AS VacancyGoal1,
	CAST(NULL AS NVARCHAR(MAX)) AS VacancyGoal2,
	CAST(NULL AS NVARCHAR(MAX)) AS VacancyGoal3,
	I_PCon.Email,
	I_PCon.PreferredCommunicationMethod,
	CAST(NULL AS NVARCHAR(MAX)) AS ContactStatus,
	CAST(NULL AS NVARCHAR(MAX)) AS SexualOrientation,
	I_PE.Gender,
	I_PE.Ethnicity
FROM
DV.HUB_Participant H
LEFT JOIN DV.SAT_Participant_Iconi_Core I_PC ON I_PC.ParticipantHash = H.ParticipantHash AND I_PC.IsCurrent = 1
LEFT JOIN DV.SAT_Participant_Iconi_Contact I_PCon ON I_PCon.ParticipantHash = H.ParticipantHash AND I_PCon.IsCurrent = 1
LEFT JOIN DV.SAT_Participant_Iconi_Address I_PA ON I_PA.ParticipantHash = H.ParticipantHash AND I_PA.IsCurrent = 1
LEFT JOIN DV.SAT_Participant_Iconi_Equality I_PE ON I_PE.ParticipantHash = H.ParticipantHash AND I_PE.IsCurrent = 1
WHERE H.RecordSource = 'ICONI.Participant';
GO
