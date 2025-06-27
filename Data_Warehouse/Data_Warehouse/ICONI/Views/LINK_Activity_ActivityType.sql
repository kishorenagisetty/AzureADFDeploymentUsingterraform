CREATE VIEW [ICONI].[LINK_Activity_ActivityType]
AS 
-- ===============================================================
-- Author:	Shaz Rehman
-- Create date: 23/11/2023
-- Ticket Ref: #30197
-- Name: [ICONI].[LINK_Activity_ActivityType]
-- Description: Runs the Link Activity Activity Type Data
-- Revisions:
-- 30197 - SR - 23/11/2023 - Amended view to bring in Refugee data via Union
-- ===============================================================
SELECT 
CONCAT_WS('|','ICONI', M.meeting_id) AS ActivityKey,
CONCAT_WS('|','ICONI', AC.ActivityType) AS ActivityTypeKey,
'ICONI.Meeting_Restart' AS RecordSource,
CAST('1900-01-02' AS DATETIME2(0)) AS ValidFrom, 
CAST('9999-12-31' AS DATETIME2(0)) AS ValidTo, 
1 AS IsCurrent
FROM ICONI.vBIRestart_Meeting AS M
INNER JOIN ELT.ActivityCategories AS AC
ON M.meet_type = AC.ActivityType
INNER JOIN ICONI.vBIRestart_Engagement AS C
ON M.meet_engagement_id = C.engagement_id
AND AC.Source = 'Iconi'
AND M.IsCurrent = 1
AND C.IsCurrent = 1
-- 30197 - SR - 23/11/2023
UNION
SELECT 
CONCAT_WS('|','ICONI', M.meeting_id) AS ActivityKey,
CONCAT_WS('|','ICONI', AC.ActivityType) AS ActivityTypeKey,
'ICONI.Meeting_Refugee' AS RecordSource,
CAST('1900-01-02' AS DATETIME2(0)) AS ValidFrom, 
CAST('9999-12-31' AS DATETIME2(0)) AS ValidTo, 
1 AS IsCurrent
FROM ICONI.vBIRefugee_Meeting AS M
INNER JOIN ELT.ActivityCategories AS AC
ON M.meet_type = AC.ActivityType
INNER JOIN ICONI.vBIRefugee_Engagement AS C
ON M.meet_engagement_id = C.engagement_id
AND AC.Source = 'Iconi'
AND M.IsCurrent = 1
AND C.IsCurrent = 1
--
;