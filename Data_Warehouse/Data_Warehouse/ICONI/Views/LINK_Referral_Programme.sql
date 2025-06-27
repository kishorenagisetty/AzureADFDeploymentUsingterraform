CREATE VIEW [ICONI].[LINK_Referral_Programme]
AS 
-- ===============================================================
-- Author:	Sagar Kadiyala
-- Create date: 30/01/2024
-- Ticket Ref: #30330
-- Name: [ICONI].[LINK_Referral_Programme]
-- Description: Runs the Link Case Data
-- Revisions:
-- 30330 - SK - 30/01/2024 - Created a new view to bring in Refugee data via Union
-- ===============================================================
SELECT CONCAT_WS('|', 'ICONI', C.engagement_id) AS ReferralKey
     , CONCAT_WS('|', 'ICONI', 'Restart')       AS ProgrammeKey
     , 'ICONI.Engagement_Restart'               AS RecordSource
     , C.ValidFrom
     , C.ValidTo
     , C.IsCurrent
FROM ICONI.vBIRestart_Engagement AS C
WHERE C.IsCurrent = 1
UNION
SELECT CONCAT_WS('|', 'ICONI', C.engagement_id) AS ReferralKey
     , CONCAT_WS('|', 'ICONI', 'Refugee')       AS ProgrammeKey
     , 'ICONI.Engagement_Refugee'               AS RecordSource
     , C.ValidFrom
     , C.ValidTo
     , C.IsCurrent
FROM ICONI.vBIRefugee_Engagement AS C
WHERE C.IsCurrent = 1;
GO