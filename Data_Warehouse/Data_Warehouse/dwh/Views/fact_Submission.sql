CREATE VIEW [dwh].[fact_Submission] 
AS 
-- Author: 
-- Create date: DD/MM/YYY
-- Ticket Reference:  <Dev Ops Ticket Reference>
-- Description: <Description regarding object>
-- Revisions:
-- 12/07/2023 - <MK> - <26307> - <Changed column data type from datetime to date>
-- 18/07/2023 - <SK> - <26494> - <Adding Hub_Submissions table and changing the refernce of submissionHash columns>
-- 30/08/2023 - <SK> - <27396> - <Add the Customer name and customer Id columns>
-- 05/09/2023 - <SK> - <27396> - <Added the Programmename, DeliverySiteName and EA AdvisorName columns>
-- 06/09/2023 - <SK> - <27396> - <Eliminating the duplicates in the deliversites and Advisorname columns>
SELECT		
			 hs.SubmissionHash														 AS SubmissionHashBin -- 18/07/23 <SK> <26494>
			,CONVERT(CHAR(66),ISNULL(hs.SubmissionHash,CAST(0x0 AS BINARY(32))),1)	 AS SubmissionHash -- 18/07/23 <SK> <26494>
			,lvs.VacancyHash														 AS VacancyHashBin
			,CONVERT(CHAR(66),ISNULL(lvs.VacancyHash,CAST(0x0 AS BINARY(32))),1)	 AS VacancyHash
			,lsp.ParticipantHash													 AS ParticipantHashBin
			,CONVERT(CHAR(66),ISNULL(lsp.ParticipantHash,CAST(0x0 AS BINARY(32))),1) AS ParticipantHash
			,REPLACE(CAST(ssa.SubmissionKey AS VARCHAR(25)),'ADAPT|','')			 AS SubmissionKey -- 05/09/2023 - <SK> - <27396>
			,REPLACE(CAST(ssa.SubmissionReferenceKey AS VARCHAR(25)),'ADAPT|','')	 AS SubmissionReferenceKey -- 05/09/2023 - <SK> - <27396>
			,CAST(ssa.CreatedDate AS DATE)											 AS CreatedDate -- 12/07/23 <MK> <26307>
			,CAST(ssa.UpdatedDate AS DATE)											 AS UpdatedDate -- 12/07/23 <MK> <26307>
			,CAST(ssa.DeletedDate AS DATE)											 AS DeletedDate -- 12/07/23 <MK> <26307>
			,ssa.SubmissionStatus													 AS SubmissionStatus
			,spp.FullName															 AS CustomerFullName    -- 30/08/23 <SK> <27396>
			,REPLACE(CAST(spp.ParticipantKey AS VARCHAR(25)),'ADAPT|','')			 AS ParticipantIDNumber -- 30/08/23 <SK> <27396>
			,sea.EmployeeName														 AS AdvisorName         -- 05/09/2023 - <SK> - <27396>
			,ssa.ProgrammeName														 AS ProgrammeName       -- 05/09/2023 - <SK> - <27396>
			,d.DeliverySiteName														 AS DeliverySiteName    -- 05/09/2023 - <SK> - <27396>
FROM		DV.HUB_Submission hs																	-- 18/07/23 <SK> <26494>
JOIN		DV.Link_Vacancy_Submission				lvs	ON hs.SubmissionHash   = lvs.SubmissionHash
LEFT JOIN	DV.SAT_Submission_Adapt_Core			ssa	ON ssa.SubmissionHash  = lvs.SubmissionHash AND ssa.IsCurrent = 1
LEFT JOIN	DV.LINK_Submission_Participant			lsp	ON lsp.SubmissionHash  = lvs.SubmissionHash
LEFT JOIN	DV.SAT_Participant_Adapt_Core_PersonGen spp ON lsp.participantHash = spp.participantHash AND spp.IsCurrent = 1-- 30/08/23 <SK> <27396>
LEFT JOIN	DV.SAT_Employee_Adapt_Core				sea ON sea.userRefKey	   = ssa.ShortListBy AND sea.employeeEmail IS NOT NULL AND sea.IsCurrent = 1 -- 06/09/2023 - <SK> - <27396>-- 05/09/2023 - <SK> - <27396>
--LEFT JOIN   DV.SAT_DeliverySite_Adapt_Core			d	ON d.DeliverySiteKey   = ssa.DeliverySiteId AND d.iscurrent=1;  -- 05/09/2023 - <SK> - <27396>
LEFT JOIN   (SELECT DeliverySiteKey
				   ,DeliverySiteName FROM DV.SAT_DeliverySite_Adapt_Core d
			 WHERE d.IsCurrent=1
			 GROUP BY DeliverySiteKey
					 ,DeliverySiteName
			) d	 ON d.DeliverySiteKey   = ssa.DeliverySiteId; -- 06/09/2023 - <SK> - <27396>