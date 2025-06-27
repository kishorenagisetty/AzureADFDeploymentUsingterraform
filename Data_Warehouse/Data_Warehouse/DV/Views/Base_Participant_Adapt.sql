CREATE VIEW [DV].[Base_Participant_Adapt] AS SELECT
	CONVERT(CHAR(66),H.ParticipantHash ,1) AS ParticipantHash,
	H.RecordSource,
	CAST(H.ParticipantKey AS NVARCHAR(MAX)) AS ParticipantID,
	A_C_PG.FullName,
	Ref_Title.Description AS Title,
	CAST(A_C_PG.FirstName AS NVARCHAR(MAX)) AS FirstName,
	CAST(A_C_PG.MiddleName AS NVARCHAR(MAX)) AS MiddleName,
	CAST(A_C_PG.LastName AS NVARCHAR(MAX)) AS LastName,
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
	A_C_PG.VacancyGoal1,
	A_C_PG.VacancyGoal2,
	A_C_PG.VacancyGoal3,
	Ref_PrefComm.Description AS PreferredCommunicationMethod,
	Ref_ContStat.Description AS ContactStatus,
	Ref_SecOr.Description AS SexualOrientation,
	Ref_Gender.Description AS Gender,
	Ref_Ethnicity.Description AS Ethnicity
FROM
DV.HUB_Participant H
LEFT JOIN DV.SAT_Participant_Adapt_Core_CandGen A_C_CG ON A_C_CG.ParticipantHash = H.ParticipantHash AND A_C_CG.IsCurrent = 1
LEFT JOIN DV.SAT_Participant_Adapt_Core_CandPayroll A_C_CP ON A_C_CP.ParticipantHash = H.ParticipantHash AND A_C_CP.IsCurrent = 1
LEFT JOIN DV.SAT_Participant_Adapt_Core_PersonGen A_C_PG ON A_C_PG.ParticipantHash = H.ParticipantHash AND A_C_PG.IsCurrent = 1
LEFT JOIN DV.SAT_Participant_Adapt_Address A_A ON A_A.ParticipantHash = H.ParticipantHash AND A_A.IsCurrent = 1
LEFT JOIN DV.SAT_Participant_Adapt_Equality A_E ON A_E.ParticipantHash = H.ParticipantHash AND A_E.IsCurrent = 1
LEFT JOIN DV.SAT_Participant_Adapt_Contact_Telephone A_Co_T ON A_Co_T.ParticipantHash = H.ParticipantHash AND A_Co_T.IsCurrent = 1
LEFT JOIN DV.SAT_Participant_Adapt_Contact_Email A_Co_E ON A_Co_E.ParticipantHash = H.ParticipantHash AND A_Co_E.IsCurrent = 1
LEFT JOIN DV.Dimension_References Ref_Mark ON Ref_Mark.Code = A_C_CG.MarketingPermissions AND Ref_Mark.ReferenceSource = 'ADAPT.MD_MULTI_NAMES' AND Ref_Mark.Category = 'Code'
LEFT JOIN DV.Dimension_References Ref_Title ON Ref_Title.Code = A_C_PG.Title AND Ref_Title.ReferenceSource = 'ADAPT.MD_MULTI_NAMES' AND Ref_Title.Category = 'Code'
LEFT JOIN DV.Dimension_References Ref_PrefComm ON Ref_PrefComm.Code = A_C_CG.PreferredCommunicationMethod AND Ref_PrefComm.ReferenceSource = 'ADAPT.MD_MULTI_NAMES' AND Ref_PrefComm.Category = 'Code'
LEFT JOIN DV.Dimension_References Ref_ContStat ON Ref_ContStat.Code = A_C_CG.ContactStatus AND Ref_ContStat.ReferenceSource = 'ADAPT.MD_MULTI_NAMES' AND Ref_ContStat.Category = 'Code'
LEFT JOIN DV.Dimension_References Ref_SecOr ON Ref_SecOr.Code = A_E.SexualOrientation AND Ref_SecOr.ReferenceSource = 'ADAPT.MD_MULTI_NAMES' AND Ref_SecOr.Category = 'Code'
LEFT JOIN DV.Dimension_References Ref_Gender ON Ref_Gender.Code = A_E.Gender AND Ref_Gender.ReferenceSource = 'ADAPT.MD_MULTI_NAMES' AND Ref_Gender.Category = 'Code'
LEFT JOIN DV.Dimension_References Ref_Ethnicity ON Ref_Ethnicity.Code = A_E.Ethnicity AND Ref_Ethnicity.ReferenceSource = 'ADAPT.MD_MULTI_NAMES' AND Ref_Ethnicity.Category = 'Code'
WHERE H.RecordSource = 'ADAPT.PROP_PERSON_GEN';
GO
