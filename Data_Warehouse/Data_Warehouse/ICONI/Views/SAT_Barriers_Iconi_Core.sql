CREATE VIEW [ICONI].[SAT_Barriers_Iconi_Core]
AS SELECT 
CONCAT_WS('|','ICONI',B.engagement_barrier_id)		AS BarrierKey
,eb_barrier											AS BarrierName
,eb_value											AS BarrierValue
,eb_status											AS BarrierStatus
,eb_added_date										AS BarrierAddedDate
,eb_last_updated_date								AS BarrierLastUpdated
,B.ValidFrom										AS ValidFrom
,B.ValidTo											AS ValidTo
,B.IsCurrent										AS IsCurrent
FROM ICONI.vBIRestart_Barrier as B;