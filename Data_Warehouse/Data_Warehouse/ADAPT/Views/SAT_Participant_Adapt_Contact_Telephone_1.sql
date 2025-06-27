CREATE VIEW [ADAPT].[SAT_Participant_Adapt_Contact_Telephone]
AS WITH TEL AS (
	SELECT REFERENCE, [Mobile],[Work],[Home], ValidFrom, ValidTo, IsCurrent
	FROM (
		SELECT T.REFERENCE, N.NAME AS Type, TEL_NUMBER, N.ValidFrom, N.ValidTo, N.IsCurrent FROM ADAPT.PROP_TELEPHONE T
			INNER JOIN ADAPT.MD_MULTI_NAMES N ON T.OCC_ID = N.ID
		WHERE N.NAME IN ('Mobile','Work','Home') AND NULLIF(TRIM(TEL_NUMBER),'') IS NOT NULL
	) P
	PIVOT
	(
	MAX(TEL_NUMBER)
	FOR Type IN ([Mobile],[Work],[Home])
	) AS pvt
)

SELECT 

	CONCAT_WS('|','ADAPT',CAST(PG.PERSON_ID AS INT)) AS ParticipantKey,
	T.Home AS TelephoneHome,
	T.Mobile AS TelephoneMobile,
	T.Work AS TelephoneWork,
	T.ValidFrom,
	T.ValidTo,
	T.IsCurrent
FROM TEL T 
	INNER JOIN ADAPT.PROP_PERSON_GEN PG ON PG.REFERENCE = T.REFERENCE AND PG.IsCurrent = 1;
