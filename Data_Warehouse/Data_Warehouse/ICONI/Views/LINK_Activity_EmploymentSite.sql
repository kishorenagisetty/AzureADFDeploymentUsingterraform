CREATE VIEW [ICONI].[LINK_Activity_EmploymentSite]
AS 
-- ===============================================================
-- Author:	Shaz Rehman
-- Create date: 23/11/2023
-- Ticket Ref: #30197
-- Name: [ICONI].[LINK_Activity_EmploymentSite]
-- Description: Runs the Link Activity Employee Site Type Data
-- Revisions:
-- 30197 - SR - 23/11/2023 - Amended view to bring in Refugee data via Union
-- ===============================================================
SELECT
CONCAT_WS('|','ICONI', M.meeting_id) AS ActivityKey,
CONCAT_WS('|','ICONI',E.[user_id]) AS EmployeeKey,
'ICONI.Meeting_Restart' AS RecordSource,
M.ValidFrom,
M.ValidTo,
M.IsCurrent
FROM ICONI.vBIRestart_Meeting AS M
INNER JOIN [ICONI].[vBICommon_User] AS E
ON M.meet_added_by_user_id = E.[user_id]
AND M.IsCurrent = 1
AND E.IsCurrent = 1
-- 30197 - SR - 23/11/2023
UNION
SELECT
CONCAT_WS('|','ICONI', M.meeting_id) AS ActivityKey,
CONCAT_WS('|','ICONI',E.[user_id]) AS EmployeeKey,
'ICONI.Meeting_Refugee' AS RecordSource,
M.ValidFrom,
M.ValidTo,
M.IsCurrent
FROM ICONI.vBIRefugee_Meeting AS M
INNER JOIN [ICONI].[vBICommon_User] AS E
ON M.meet_added_by_user_id = E.[user_id]
AND M.IsCurrent = 1
AND E.IsCurrent = 1
;