CREATE VIEW [ICONI].[HUB_Case] 
AS
-- ===============================================================
-- Author:	Sagar Kadiyala
-- Create date: 04/01/2024
-- Ticket Ref: #30330
-- Name: [ICONI].[HUB_Case]
-- Description: Runs the Hub Case Data
-- Revisions:
-- 30330 - SK - 09/01/2024 - Amended view to bring in Refugee data via Union
-- ===============================================================
SELECT 
CONCAT_WS('|','ICONI',C.engagement_id) AS CaseKey,
'ICONI.Engagement_Restart' AS RecordSource,
C.ValidFrom,
C.ValidTo,
C.IsCurrent
FROM ICONI.vBIRestart_Engagement C
-- 30330 - SK - 09/01/2024
UNION
SELECT 
CONCAT_WS('|','ICONI',C.engagement_id) AS CaseKey,
'ICONI.Engagement_Refugee' AS RecordSource,
C.ValidFrom,
C.ValidTo,
C.IsCurrent
FROM ICONI.vBIRefugee_Engagement C;