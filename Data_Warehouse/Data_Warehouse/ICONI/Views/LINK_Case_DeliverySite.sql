CREATE VIEW [ICONI].[LINK_Case_DeliverySite]
-- ===============================================================
-- Author:	Sagar Kadiyala
-- Create date: 23/01/2024
-- Ticket Ref: #30330
-- Name: [ICONI].[LINK_Case_DeliverySite]
-- Description: Runs the Hub DeliverySite Data
-- Revisions:
-- 30330 - SK - 23/01/2024 - Amended view to bring in Refugee data via Union
-- ===============================================================
AS 
SELECT DISTINCT
    CONCAT_WS('|', 'ICONI', DS.engagement_id)    AS CaseKey
  , CONCAT_WS('|', 'ICONI', DS.eng_tran_site_id) AS DeliverySiteKey
  , 'ICONI.Engagement_Restart'                   AS RecordSource
  , DS.ValidFrom
  , DS.ValidTo
  , DS.IsCurrent
FROM ICONI.vBIRestart_Engagement AS DS
WHERE DS.IsCurrent = 1
UNION
SELECT DISTINCT
    CONCAT_WS('|', 'ICONI', DS.engagement_id)    AS CaseKey
  , CONCAT_WS('|', 'ICONI', DS.eng_tran_site_id) AS DeliverySiteKey
  , 'ICONI.Engagement_Refugee'                   AS RecordSource
  , DS.ValidFrom
  , DS.ValidTo
  , DS.IsCurrent
FROM ICONI.vBIRefugee_Engagement AS DS
WHERE DS.IsCurrent = 1;
GO
