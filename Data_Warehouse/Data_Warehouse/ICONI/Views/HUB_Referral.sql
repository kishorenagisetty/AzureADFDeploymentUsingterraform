CREATE VIEW [ICONI].[HUB_Referral] 
-- ===============================================================
-- Author:	Sagar Kadiyala
-- Create date: 23/01/2024
-- Ticket Ref: #30330
-- Name: [ICONI].[HUB_Referral] 
-- Description: Runs the Hub Referral Data
-- Revisions:
-- 30330 - SK - 23/01/2024 - Amended view to bring in Refugee data via Union
-- ===============================================================
AS 
SELECT CONCAT_WS('|', 'ICONI', C.engagement_id) AS ReferralKey
     , 'ICONI.Engagement_Restart'               AS RecordSource
     , C.ValidFrom
     , C.ValidTo
     , C.IsCurrent
FROM ICONI.vBIRestart_Engagement C
WHERE C.IsCurrent = 1
-- 30330 - SK - 09/01/2024
UNION
SELECT CONCAT_WS('|', 'ICONI', C.engagement_id) AS ReferralKey
     , 'ICONI.Engagement_Refugee'               AS RecordSource
     , C.ValidFrom
     , C.ValidTo
     , C.IsCurrent
FROM ICONI.vBIRefugee_Engagement C
WHERE C.IsCurrent = 1
GO


