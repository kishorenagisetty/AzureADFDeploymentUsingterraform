CREATE VIEW [ICONI].[HUB_Activity]
AS 
-- ===============================================================
-- Author:	Shaz Rehman
-- Create date: 23/11/2023
-- Ticket Ref: #30197
-- Name: [ICONI].[HUB_Activity]
-- Description: Runs the Hub Activity Data
-- Revisions:
-- 30197 - SR - 23/11/2023 - Amended view to bring in Refugee data via Union
-- ===============================================================
SELECT 
CONCAT_WS('|','ICONI',M.meeting_id) AS ActivityKey,
'ICONI.Meeting_Restart' AS RecordSource,
M.ValidFrom,
M.ValidTo,
M.IsCurrent
FROM ICONI.vBIRestart_Meeting M
-- 30197 - SR - 23/11/2023
UNION
SELECT 
CONCAT_WS('|','ICONI',R.meeting_id) AS ActivityKey,
'ICONI.Meeting_Refugee' AS RecordSource,
R.ValidFrom,
R.ValidTo,
R.IsCurrent
FROM [ICONI].[vBIRefugee_Meeting] R
--
;