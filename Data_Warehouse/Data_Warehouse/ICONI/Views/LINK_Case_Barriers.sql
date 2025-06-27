CREATE VIEW [ICONI].[LINK_Case_Barriers]
AS SELECT 
CONCAT_WS('|','ICONI', C.engagement_id) AS CaseKey,
CONCAT_WS('|','ICONI', B.engagement_barrier_id) AS BarrierKey,
'ICONI.Meeting' AS RecordSource,
B.ValidFrom,
B.ValidTo,
B.IsCurrent
FROM ICONI.vBIRestart_Engagement AS C
INNER JOIN ICONI.vBIRestart_Barrier AS B
ON C.engagement_id = B.eb_engagement_id
AND B.IsCurrent = 1
AND C.IsCurrent = 1;