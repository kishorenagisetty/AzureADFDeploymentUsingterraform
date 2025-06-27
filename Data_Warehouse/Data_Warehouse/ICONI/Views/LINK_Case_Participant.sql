CREATE VIEW [ICONI].[LINK_Case_Participant] 
-- ===============================================================
-- Author:	Sagar Kadiyala
-- Create date: 23/01/2024
-- Ticket Ref: #30330
-- Name: [ICONI].[LINK_Case_Participant] 
-- Description: Runs the Link Participant Data
-- Revisions:
-- 30330 - SK - 23/01/2024 - Amended view to bring in Refugee data via Union
-- ===============================================================
AS 
SELECT CONCAT_WS('|', 'ICONI', C.engagement_id) AS CaseKey
     , CONCAT_WS('|', 'ICONI', P.individual_id) AS ParticipantKey
     , 'ICONI.Individual_Restart'               AS RecordSource
     , P.ValidFrom
     , P.ValidTo
     , P.IsCurrent
FROM ICONI.vBICommon_Individual            AS P
    INNER JOIN ICONI.vBIRestart_Engagement AS C
        ON P.individual_id = C.eng_tran_individual_id
WHERE P.IsCurrent = 1
      AND C.IsCurrent = 1
UNION
SELECT CONCAT_WS('|', 'ICONI', C.engagement_id) AS CaseKey
     , CONCAT_WS('|', 'ICONI', P.individual_id) AS ParticipantKey
     , 'ICONI.Individual_Refugee'               AS RecordSource
     , P.ValidFrom
     , P.ValidTo
     , P.IsCurrent
FROM ICONI.vBICommon_Individual            AS P
    INNER JOIN ICONI.vBIRefugee_Engagement AS C
        ON P.individual_id = C.eng_tran_individual_id
WHERE P.IsCurrent = 1
      AND C.IsCurrent = 1
Go