CREATE VIEW [DV].[Base_Participant_WithHistory]
AS WITH ValidDates AS (
SELECT ParticipantHash, ValidFrom AS [Date] FROM DV.SAT_Participant_Adapt_Address
UNION
SELECT ParticipantHash, ValidTo AS [Date] FROM DV.SAT_Participant_Adapt_Address
UNION
SELECT ParticipantHash, ValidFrom AS [Date] FROM DV.SAT_Participant_Adapt_Equality
UNION
SELECT ParticipantHash, ValidTo AS [Date] FROM DV.SAT_Participant_Adapt_Equality
UNION ALL
SELECT ParticipantHash, ValidFrom AS [Date] FROM DV.SAT_Participant_Adapt_Core_CandGen
UNION
SELECT ParticipantHash, ValidTo AS [Date] FROM DV.SAT_Participant_Adapt_Core_CandGen
UNION
SELECT ParticipantHash, ValidFrom AS [Date] FROM DV.SAT_Participant_Adapt_Core_CandPayroll
UNION
SELECT ParticipantHash, ValidTo AS [Date] FROM DV.SAT_Participant_Adapt_Core_CandPayroll
UNION
SELECT ParticipantHash, ValidFrom AS [Date] FROM DV.SAT_Participant_Adapt_Core_PersonGen
UNION
SELECT ParticipantHash, ValidTo AS [Date] FROM DV.SAT_Participant_Adapt_Core_PersonGen
UNION
SELECT ParticipantHash, ValidFrom AS [Date] FROM DV.SAT_Participant_Adapt_Contact_Telephone
UNION
SELECT ParticipantHash, ValidTo AS [Date] FROM DV.SAT_Participant_Adapt_Contact_Telephone
UNION
SELECT ParticipantHash, ValidFrom AS [Date] FROM DV.SAT_Participant_Adapt_Contact_Email
UNION
SELECT ParticipantHash, ValidTo AS [Date] FROM DV.SAT_Participant_Adapt_Contact_Email

)
,DateRanges AS (
SELECT ParticipantHash, Date AS ValidFrom, LEAD(Date,1) OVER (PARTITION BY ParticipantHash ORDER BY Date) AS ValidTo
FROM ValidDates),
ValidDateRanges AS (
SELECT ParticipantHash, ValidFrom, ValidTo FROM DateRanges WHERE ValidTo IS NOT NULL
)
--SELECT * FROM ValidDateRanges
SELECT
	CONVERT(CHAR(66),CAST(0x0 AS BINARY(32)) ,1) AS ParticipantHash,
	CONVERT(CHAR(66),CAST(0x0 AS BINARY(32)) ,1) AS ParticipantHash_Hub,
	CAST('Unknown' AS VARCHAR(50)) AS RecordSource,
	CAST('Unknown' AS NVARCHAR(MAX)) AS FullName,
	CAST('Unknown' AS NVARCHAR(MAX)) AS Title,
	CAST('Unknown' AS NVARCHAR(MAX)) AS FirstName,
	CAST('Unknown' AS NVARCHAR(MAX)) AS MiddleName,
	CAST('Unknown' AS NVARCHAR(MAX)) AS LastName,
	CAST('Unknown' AS NVARCHAR(MAX)) AS KnownAs,
	CAST('19000101' AS datetime2(0)) AS DateOfBirth,
	CAST('Unknown' AS NVARCHAR(MAX)) AS NationalInsuranceNo,
	CAST('Unknown' AS NVARCHAR(MAX)) AS ValidSMS,
	CAST('Unknown' AS NVARCHAR(MAX)) AS SMSOptOut,
	CAST('Unknown' AS NVARCHAR(MAX)) AS EmailOptOut,
	CAST('Unknown' AS NVARCHAR(MAX)) AS LeaveMessage,
	CAST('Unknown' AS NVARCHAR(MAX)) AS HasCriminalConviction,
	CAST('Unknown' AS NVARCHAR(MAX)) AS IsDriver,
	CAST('Unknown' AS NVARCHAR(MAX)) AS BetterOffCalculationStatus,
	CAST('Unknown' AS NVARCHAR(MAX)) AS HasOwnTransport,
	CAST('Unknown' AS NVARCHAR(MAX)) AS MarketingPermissions,
	CAST('Unknown' AS NVARCHAR(MAX)) AS HasUpToDateCV,
	CAST('Unknown' AS NVARCHAR(MAX)) AS AddressLine1,
	CAST('Unknown' AS NVARCHAR(MAX)) AS AddressLine2,
	CAST('Unknown' AS NVARCHAR(MAX)) AS Locality,
	CAST('Unknown' AS NVARCHAR(MAX)) AS Town,
	CAST('Unknown' AS NVARCHAR(MAX)) AS County,
	CAST('Unknown' AS NVARCHAR(MAX)) AS PostCode,
	CAST(0 AS INT) AS PostCodeSector,
	CAST('Unknown' AS NVARCHAR(MAX)) AS TelephoneHome,
	CAST('Unknown' AS NVARCHAR(MAX)) AS TelephoneMobile,
	CAST('Unknown' AS NVARCHAR(MAX)) AS TelephoneWork,
	CAST('Unknown' AS NVARCHAR(MAX)) AS EmailWork,
	CAST('Unknown' AS NVARCHAR(MAX)) AS EmailHome,
	CAST('Unknown' AS NVARCHAR(MAX)) AS PreferredCommunicationMethod,
	CAST('Unknown' AS NVARCHAR(MAX)) AS ContactStatus,
	CAST('Unknown' AS NVARCHAR(MAX)) AS SexualOrientation,
	CAST('Unknown' AS NVARCHAR(MAX)) AS Gender,
	CAST('Unknown' AS NVARCHAR(MAX)) AS Ethnicity,
	CAST('1900-01-01' AS DATETIME2(0)) AS ValidFrom,
	CAST('9999-12-31 23:59:59' AS DATETIME2(0)) AS ValidTo,
	CAST(1 AS BIT) AS IsCurrent

	UNION ALL

SELECT
	CONVERT(CHAR(66),CAST(HASHBYTES('SHA2_256',CONCAT_WS('|',H.ParticipantHash,D.ValidFrom, D.ValidTo)) AS BINARY(32)) ,1) AS ParticipantHash,
	CONVERT(CHAR(66),H.ParticipantHash ,1) AS ParticipantHash,
	H.RecordSource,
	A_C_PG.FullName,
	Ref_Title.Description AS Title,
	A_C_PG.FirstName,
	A_C_PG.MiddleName,
	A_C_PG.LastName,
	CAST(NULL AS NVARCHAR(MAX)) AS KnownAs,
	A_C_PG.DateOfBirth,
	A_C_CP.NationalInsuranceNo,
	CAST(NULL AS NVARCHAR(MAX)) AS ValidSMS,
	CAST(NULL AS NVARCHAR(MAX)) AS SMSOptOut,
	CAST(NULL AS NVARCHAR(MAX)) AS EmailOptOut,
	CAST(NULL AS NVARCHAR(MAX)) AS LeaveMessage,
	A_C_CG.HasCriminalConviction,
	A_C_CG.IsDriver,
	A_C_CG.BetterOffCalculationStatus,
	A_C_CG.HasOwnTransport,
	Ref_Mark.Description AS MarketingPermissions,
	A_C_CG.HasUpToDateCV,
	A_A.AddressLine1,
	A_A.AddressLine2,
	A_A.Locality,
	A_A.Town,
	A_A.County,
	A_A.PostCode,
	A_A.PostCodeSector,
	A_Co_T.TelephoneHome,
	A_Co_T.TelephoneMobile,
	A_Co_T.TelephoneWork,
	A_Co_E.EmailWork,
	A_Co_E.EmailHome,
	Ref_PrefComm.Description AS PreferredCommunicationMethod,
	Ref_ContStat.Description AS ContactStatus,
	Ref_SecOr.Description AS SexualOrientation,
	Ref_Gender.Description AS Gender,
	Ref_Ethnicity.Description AS Ethnicity,
	D.ValidFrom, 
	D.ValidTo,
	CAST(CASE WHEN D.ValidTo = '9999-12-31 23:59:59' THEN 1 ELSE 0 END AS BIT) AS IsCurrent
FROM
DV.HUB_Participant H
INNER JOIN ValidDateRanges D ON D.ParticipantHash = H.ParticipantHash

LEFT JOIN DV.SAT_Participant_Adapt_Core_CandGen A_C_CG ON A_C_CG.ParticipantHash = H.ParticipantHash  AND A_C_CG.ValidTo > D.ValidFrom AND A_C_CG.ValidFrom < D.ValidTo
LEFT JOIN DV.SAT_Participant_Adapt_Core_CandPayroll A_C_CP ON A_C_CP.ParticipantHash = H.ParticipantHash  AND A_C_CP.ValidTo > D.ValidFrom AND A_C_CP.ValidFrom < D.ValidTo
LEFT JOIN DV.SAT_Participant_Adapt_Core_PersonGen A_C_PG ON A_C_PG.ParticipantHash = H.ParticipantHash  AND A_C_PG.ValidTo > D.ValidFrom AND A_C_PG.ValidFrom < D.ValidTo
LEFT JOIN DV.SAT_Participant_Adapt_Address A_A ON A_A.ParticipantHash = H.ParticipantHash AND  A_A.ValidTo > D.ValidFrom AND A_A.ValidFrom < D.ValidTo
LEFT JOIN DV.SAT_Participant_Adapt_Equality A_E ON A_E.ParticipantHash = H.ParticipantHash AND  A_E.ValidTo > D.ValidFrom AND A_E.ValidFrom < D.ValidTo
LEFT JOIN DV.SAT_Participant_Adapt_Contact_Telephone A_Co_T ON A_Co_T.ParticipantHash = H.ParticipantHash  AND A_Co_T.ValidTo > D.ValidFrom AND A_Co_T.ValidFrom < D.ValidTo
LEFT JOIN DV.SAT_Participant_Adapt_Contact_Email A_Co_E ON A_Co_E.ParticipantHash = H.ParticipantHash  AND A_Co_E.ValidTo > D.ValidFrom AND A_Co_E.ValidFrom < D.ValidTo
LEFT JOIN DV.Dimension_References Ref_Mark ON Ref_Mark.Code = A_C_CG.MarketingPermissions AND Ref_Mark.ReferenceSource = 'ADAPT.MD_MULTI_NAMES' AND Ref_Mark.Category = 'Code'
LEFT JOIN DV.Dimension_References Ref_Title ON Ref_Title.Code = A_C_PG.Title AND Ref_Title.ReferenceSource = 'ADAPT.MD_MULTI_NAMES' AND Ref_Title.Category = 'Code'
LEFT JOIN DV.Dimension_References Ref_PrefComm ON Ref_PrefComm.Code = A_C_CG.PreferredCommunicationMethod AND Ref_PrefComm.ReferenceSource = 'ADAPT.MD_MULTI_NAMES' AND Ref_PrefComm.Category = 'Code'
LEFT JOIN DV.Dimension_References Ref_ContStat ON Ref_ContStat.Code = A_C_CG.ContactStatus AND Ref_ContStat.ReferenceSource = 'ADAPT.MD_MULTI_NAMES' AND Ref_ContStat.Category = 'Code'
LEFT JOIN DV.Dimension_References Ref_SecOr ON Ref_SecOr.Code = A_E.SexualOrientation AND Ref_SecOr.ReferenceSource = 'ADAPT.MD_MULTI_NAMES' AND Ref_SecOr.Category = 'Code'
LEFT JOIN DV.Dimension_References Ref_Gender ON Ref_Gender.Code = A_E.Gender AND Ref_Gender.ReferenceSource = 'ADAPT.MD_MULTI_NAMES' AND Ref_Gender.Category = 'Code'
LEFT JOIN DV.Dimension_References Ref_Ethnicity ON Ref_Ethnicity.Code = A_E.Ethnicity AND Ref_Ethnicity.ReferenceSource = 'ADAPT.MD_MULTI_NAMES' AND Ref_Ethnicity.Category = 'Code';