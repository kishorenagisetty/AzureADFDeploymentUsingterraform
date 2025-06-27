CREATE VIEW [ICONI].[HUB_Barriers]
AS SELECT 
CONCAT_WS('|','ICONI',B.engagement_barrier_id) AS BarriersKey,
'ICONI.Barrier' AS RecordSource,
B.ValidFrom,
B.ValidTo,
B.IsCurrent
FROM ICONI.vBIRestart_Barrier B;