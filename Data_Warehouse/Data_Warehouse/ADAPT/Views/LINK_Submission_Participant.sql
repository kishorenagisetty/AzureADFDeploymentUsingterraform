CREATE VIEW [ADAPT].[LINK_Submission_Participant]
AS SELECT 
	CONCAT_WS('|', 'ADAPT', CAST(sub.SHORTLIST AS INT))		AS SubmissionKey,
	CONCAT_WS('|','ADAPT',CAST(per.PERSON_ID AS INT))		AS ParticipantKey,
	'ADAPT.PROP_X_SHORT_CAND'								AS RecordSource,
	sub.ValidFrom,
	sub.ValidTo,
	sub.IsCurrent
FROM		ADAPT.PROP_X_SHORT_CAND sub
INNER JOIN	ADAPT.PROP_PERSON_GEN	per		ON sub.CANDIDATE	 = per.REFERENCE AND per.IsCurrent = 1;