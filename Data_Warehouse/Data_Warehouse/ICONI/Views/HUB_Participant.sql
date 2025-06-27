CREATE VIEW [ICONI].[HUB_Participant] AS SELECT 
CONCAT_WS('|','ICONI',P.individual_id) AS ParticipantKey,
'ICONI.Participant' AS RecordSource,
P.ValidFrom,
P.ValidTo,
P.IsCurrent
FROM ICONI.vBICommon_Individual P;