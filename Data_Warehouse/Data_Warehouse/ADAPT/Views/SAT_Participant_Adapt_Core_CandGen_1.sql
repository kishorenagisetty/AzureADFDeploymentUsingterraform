CREATE VIEW [ADAPT].[SAT_Participant_Adapt_Core_CandGen]
AS 
-- 08/11/2023 <MK> <27417> <Replcaed IWBC with IWBC_2>
	SELECT 
	CONCAT_WS('|','ADAPT',CAST(PG.PERSON_ID AS INT)) AS ParticipantKey,
	CG.CRIM_CONV AS HasCriminalConviction,
	CG.DRIVER AS IsDriver,
	CG.IWBC_2 AS BetterOffCalculationStatus, -- 08/11/23 <MK> <27417>
	CG.OWN_TRANS AS HasOwnTransport,
	CAST(CG.MARK_PERM AS BIGINT) AS MarketingPermissions,
	CG.UPTODATECV AS HasUpToDateCV,
	CAST(CG.PREF_COM_MET AS BIGINT) AS PreferredCommunicationMethod,
	CAST(CG.CONT_STAT AS BIGINT) AS ContactStatus,
	Cast(CG.DT_OF_BIRTH as Date) AS DOB,
	CG.ValidFrom,
	CG.ValidTo,
	CG.IsCurrent
	FROM ADAPT.PROP_CAND_GEN CG 
	INNER JOIN ADAPT.PROP_PERSON_GEN PG ON CG.REFERENCE = PG.REFERENCE and PG.IsCurrent = 1;