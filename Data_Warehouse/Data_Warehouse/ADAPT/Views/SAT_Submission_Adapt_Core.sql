CREATE VIEW [ADAPT].[SAT_Submission_Adapt_Core] 
AS 
-- Author: 
-- Create date: DD/MM/YYY
-- Ticket Reference:  <Dev Ops Ticket Reference>
-- Description: <Description regarding object>
-- Revisions:
-- 05/09/2023 - <SK> - <27396> - <Add the ProgrammeName,CaseKey,ShortListBy and DeliverySiteKey columns>
SELECT SubmissionKey
	  ,SubmissionReferenceKey
	  ,CreatedDate
	  ,UpdatedDate
	  ,DeletedDate
	  ,SubmissionStatus
	  ,ProgrammeName        -- 05/09/2023 - <SK> - <27396>
	  ,CaseId              -- 05/09/2023 - <SK> - <27396>
	  ,ShortListBy          -- 05/09/2023 - <SK> - <27396>
	  ,DeliverySiteId      -- 05/09/2023 - <SK> - <27396>
	  ,ValidFrom
	  ,ValidTo
	  ,IsCurrent
FROM
(SELECT CONCAT_WS('|', 'ADAPT', CAST(Sub.SHORTLIST AS INT))	AS SubmissionKey,
	sht.short_id											AS SubmissionReferenceKey,						
	et.createddate											AS CreatedDate,
	et.updateddate											AS UpdatedDate,
	et.deleteddate											AS DeletedDate,
	code.description										AS SubmissionStatus,
	sub.validfrom,
	sub.validto,
	sub.iscurrent,
	cas.name												AS ProgrammeName,  -- 05/09/2023 - <SK> - <27396>
	cas.reference											AS CaseId,         -- 05/09/2023 - <SK> - <27396>
	CONCAT_WS('|', 'ADAPT', CAST(sht.short_by AS INT))		AS ShortListBy,    -- 05/09/2023 - <SK> - <27396>
	CONCAT_WS('|', 'ADAPT', CAST(cas.core_provid AS INT))	AS DeliverySiteId, -- 05/09/2023 - <SK> - <27396>
	ROW_NUMBER() OVER(PARTITION BY per.person_id,sht.short_id ORDER BY cas.start_date DESC) AS rn -- 05/09/2023 - <SK> - <27396>
FROM		adapt.prop_x_short_cand sub
INNER JOIN	adapt.prop_short_gen    sht			ON sht.reference	 = sub.shortlist AND sht.iscurrent = 1
INNER JOIN	adapt.prop_person_gen	per			ON sub.candidate	 = per.reference AND per.iscurrent = 1
INNER JOIN	adapt.entity_table		et			ON et.entity_id		 = sub.shortlist AND et.iscurrent = 1
LEFT  JOIN	adapt.prop_x_cand_wp	wp			ON per.reference	= wp.candidate	 AND wp.iscurrent=1 -- 05/09/2023 - <SK> - <27396>
LEFT  JOIN	adapt.prop_wp_gen		cas			ON cas.reference	= wp.wizprog	 AND wp.iscurrent=1 -- 05/09/2023 - <SK> - <27396>
LEFT  JOIN	(
			 SELECT c.Code_ID
				  , mu1.DESCRIPTION
			 FROM		adapt.codes						c
			 INNER JOIN dv.sat_references_mdmultinames	mu1		ON mu1.ID = C.CODE_ID and mu1.IsCurrent = 1  and mu1.Type = 'Code' 
			) code ON code.Code_ID = sht.[Status]
) sub -- 05/09/2023 - <SK> - <27396>
WHERE sub.rn=1;-- 05/09/2023 - <SK> - <27396>