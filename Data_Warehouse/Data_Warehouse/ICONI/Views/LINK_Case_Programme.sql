CREATE VIEW [ICONI].[LINK_Case_Programme] 
-- ===============================================================
-- Author:	Sagar Kadiyala
-- Create date: 23/01/2024
-- Ticket Ref: #30330
-- Name: [ICONI].[HUB_Programme]
-- Description: Runs the Hub Case Data
-- Revisions:
-- 30330 - SK - 23/01/2024 - Created a new view to bring in Refugee data via Union
-- ===============================================================
AS
SELECT CONCAT_WS('|', 'ICONI', C.engagement_id) AS CaseKey
     , CONCAT_WS('|', 'ICONI', 'Restart')       AS ProgrammeKey
     , 'ICONI.Engagement_Restart'               AS RecordSource
     , C.ValidFrom
     , C.ValidTo
     , C.IsCurrent
FROM ICONI.vBIRestart_Engagement AS C
WHERE C.IsCurrent = 1
UNION
SELECT CONCAT_WS('|', 'ICONI', C.engagement_id) AS CaseKey
     , CONCAT_WS('|', 'ICONI', 'Refugee')       AS ProgrammeKey
     , 'ICONI.Engagement_Refugee'               AS RecordSource
     , C.ValidFrom
     , C.ValidTo
     , C.IsCurrent
FROM ICONI.vBIRefugee_Engagement AS C
WHERE C.IsCurrent = 1
Go
