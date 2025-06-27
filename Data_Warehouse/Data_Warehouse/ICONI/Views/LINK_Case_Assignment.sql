CREATE VIEW [ICONI].[LINK_Case_Assignment]
AS SELECT 
CONCAT_WS('|','ICONI', CAST(C.engagement_id AS INT)) AS CaseKey,
CONCAT_WS('|','ICONI', CAST(O.outcome_id AS INT)) AS AssignmentKey,
'ICONI.Engagement' AS RecordSource,
O.ValidFrom, 
O.ValidTo, 
O.IsCurrent

FROM [ICONI].[vBIRestart_Engagement] as  C
join ICONI.vBIRestart_Outcome O on
O.out_engagement_id = C.engagement_id;
