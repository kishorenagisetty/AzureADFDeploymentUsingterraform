CREATE VIEW [ICONI].[LINK_Case_Activity]
AS 
-- ===============================================================
-- Author:	Shaz Rehman
-- Create date: 23/11/2023
-- Ticket Ref: #30197
-- Name: [ICONI].[LINK_Case_Activity]
-- Description: Runs the Link Case Activity Data
-- Revisions:
-- 30197 - SR - 23/11/2023 - Amended view to bring in Refugee data via Union
-- ===============================================================
SELECT 
CONCAT_WS('|','ICONI', C.engagement_id) AS CaseKey,
CONCAT_WS('|','ICONI', M.meeting_id) AS ActivityKey,
'ICONI.Meeting_Restart' AS RecordSource,
M.ValidFrom,
M.ValidTo,
M.IsCurrent
FROM ICONI.vBIRestart_Engagement AS C
INNER JOIN ICONI.vBIRestart_Meeting AS M
ON C.engagement_id = M.meet_engagement_id
AND M.IsCurrent = 1
AND C.IsCurrent = 1
-- 30197 - SR - 23/11/2023
UNION
SELECT 
CONCAT_WS('|','ICONI', C.engagement_id) AS CaseKey,
CONCAT_WS('|','ICONI', M.meeting_id) AS ActivityKey,
'ICONI.Meeting_Refugee' AS RecordSource,
M.ValidFrom,
M.ValidTo,
M.IsCurrent
FROM ICONI.vBIRefugee_Engagement AS C
INNER JOIN ICONI.vBIRefugee_Meeting AS M
ON C.engagement_id = M.meet_engagement_id
AND M.IsCurrent = 1
AND C.IsCurrent = 1
--
;