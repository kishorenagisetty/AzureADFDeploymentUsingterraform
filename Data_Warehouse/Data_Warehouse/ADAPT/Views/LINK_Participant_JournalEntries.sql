CREATE VIEW [ADAPT].[LINK_Participant_JournalEntries]
AS 
SELECT 
CONCAT_WS('|','ADAPT',CAST(PG.PERSON_ID AS INT))		AS ParticipantKey,
CONCAT_WS('|', 'ADAPT', CAST(JE.Journal_ID AS INT))		AS JournalEntriesKey,
'ADAPT.PROP_PERSON_GEN'									AS RecordSource,
PG.ValidFrom,
PG.ValidTo,
PG.IsCurrent

FROM ADAPT.PROP_PERSON_GEN PG
INNER JOIN ADAPT.vw_Journal_Entries_Delta2 JE ON PG.REFERENCE = JE.ENTITYID_1 AND JE.IsCurrent = '1'
Where PG.IsCurrent = '1'
AND NULLIF(CAST(PG.PERSON_ID AS INT),'') IS NOT NULL;
GO