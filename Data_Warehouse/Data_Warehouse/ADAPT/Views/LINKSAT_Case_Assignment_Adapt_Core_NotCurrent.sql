CREATE VIEW [ADAPT].[LINKSAT_Case_Assignment_Adapt_Core_NotCurrent]
AS 
-- ===============================================================
-- Author: Shaz Rehman
-- Create date: 02/08/2023
-- Ticket Reference:  #25904
-- Description: Procedure builds LinksStats
-- Revisions:
--02/08/2023 - SR - #25904 - Various amendments to change the functionality of the procedure to run in bulk or net change.
-- ===============================================================
SELECT DISTINCT
CONCAT(
	CONCAT_WS('|','ADAPT', CAST(C.CONTRACT AS INT)),	-- CaseKey
	CONCAT_WS('|','ADAPT', CAST(P.ASSIG_ID AS INT))		-- AssignmentKey
	) AS Case_AssignmentKey,
CONCAT_WS('|','ADAPT', CAST(C.CONTRACT AS INT)) AS CaseKey,
CONCAT_WS('|','ADAPT', CAST(P.ASSIG_ID AS INT)) AS AssignmentKey,
'ADAPT.PROP_X_CAND_WP' AS RecordSource,
C.ValidFrom, 
C.ValidTo, 
C.IsCurrent
FROM ADAPT.PROP_ASSIG_GEN P
INNER JOIN ADAPT.PROP_X_ASSIG_CAND C
ON C.Assignment = P.REFERENCE  WHERE C.CONTRACT IS NOT NULL AND C.IsCurrent = 0;
GO