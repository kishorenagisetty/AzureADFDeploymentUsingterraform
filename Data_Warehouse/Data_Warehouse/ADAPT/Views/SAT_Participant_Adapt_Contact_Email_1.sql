CREATE VIEW [ADAPT].[SAT_Participant_Adapt_Contact_Email]
AS SELECT ParticipantKey, [EmailWork],[EmailHome], ValidFrom, ValidTo, IsCurrent
FROM (
	SELECT 
		CONCAT_WS('|','ADAPT',CAST(PG.PERSON_ID AS INT)) AS ParticipantKey,
		E.EMAIL_ADD AS Email,
		CASE WHEN OCC_ID = 2034424 THEN 'EmailWork' ELSE 'EmailHome' END AS EmailType,
		E.ValidFrom,
		E.ValidTo,
		E.IsCurrent
	FROM ADAPT.PROP_EMAIL E
		LEFT JOIN ADAPT.PROP_PERSON_GEN PG ON E.REFERENCE = PG.REFERENCE and PG.IsCurrent = 1
		WHERE OCC_ID IN (2034424,2034423)
	) P
	PIVOT
	(
	MAX(Email)
	FOR EmailType IN ([EmailWork],[EmailHome])
	) AS pvt;