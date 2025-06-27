-- Author: 
-- Create date: DD/MM/YYY
-- Ticket Reference:  <Dev Ops Ticket Reference>
-- Description: <Description regarding object>
-- Revisions:
-- 13/10/2023 - <CH> - remove getdate

CREATE VIEW [ADAPT].[LINK_Case_JournalEntries] AS SELECT
CONCAT_WS('|','ADAPT',CAST(P.WIZPROG AS INT))          AS CaseKey,
CONCAT_WS('|','ADAPT',CAST(JE.Journal_ID AS INT))      AS JournalEntriesKey,
'[ADAPT].[vw_Journal_Entries_Delta2]'                         AS RecordSource,
P.ValidFrom,
P.ValidTo,
P.IsCurrent
FROM [ADAPT].[PROP_X_CAND_WP] P
      INNER JOIN [ADAPT].[PROP_PERSON_GEN] PP ON PP.REFERENCE = P.CANDIDATE AND PP.IsCurrent = '1'
      INNER JOIN [ADAPT].[vw_Journal_Entries_Delta2] JE on PP.REFERENCE = JE.EntityID_1 AND JE.IsCurrent = '1'
WHERE NULLIF(CAST(P.WIZPROG AS INT),'') IS NOT NULL AND NULLIF(CAST(PP.PERSON_ID AS INT),'') IS NOT NULL;
GO