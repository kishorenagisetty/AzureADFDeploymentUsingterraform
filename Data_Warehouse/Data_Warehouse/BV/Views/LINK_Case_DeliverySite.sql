CREATE VIEW [BV].[LINK_Case_DeliverySite] 
AS 
-- Author: 
-- Create date: DD/MM/YYY
-- Ticket Reference:  <Dev Ops Ticket Reference>
-- Description: <Description regarding object>
-- Revisions:
-- 10/07/23 - <MK> - <25841> - <Ranking logic changed to use ValidFrom field instead of DeliverySiteHash>

WITH cte_test AS 
(
SELECT
*
--,ROW_NUMBER() OVER (PARTITION BY CaseHash ORDER BY DeliverySiteHash) AS Test 
,ROW_NUMBER() OVER (PARTITION BY CaseHash ORDER BY ValidFrom Desc) AS RN -- 10/07/23 <MK> <25841>
FROM DV.LINK_Case_DeliverySite
)
SELECT * FROM cte_test WHERE RN = 1;
GO