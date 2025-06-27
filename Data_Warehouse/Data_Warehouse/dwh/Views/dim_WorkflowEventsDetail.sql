CREATE VIEW [dwh].[dim_WorkflowEventsDetail]
AS 
-- Author: 
-- Create date: DD/MM/YYY
-- Ticket Reference:  <Dev Ops Ticket Reference>
-- Description: <Description regarding object>
-- Revisions:
-- 09/10/2023 - <SK> - <27218> - <Adding Pioneer contracts in the filter>
select			cas.CaseHash
				,cas.CaseId
				,par.ParticipantId
				,dac.InteractionType
				--,dac.InteractionHash
				--,dac.InteractionKey
				,dac.InteractionName
				,dac.InteractionStartDate
				,dac.InteractionEndDate
from			(select		lcd.CaseHash						as CaseHash
							,'Document'							as InteractionType
							,dac.DocumentHash					as InteractionHash
							,dac.DocumentKey					as InteractionKey
							,dac.DocumentName					as InteractionName
							,dac.SentDate						as InteractionStartDate
							,dac.CompletedDate					as InteractionEndDate
				from		dv.SAT_Document_Adapt_Core			dac
				join		dv.link_Case_Document				lcd on lcd.DocumentHash = dac.DocumentHash
				where		dac.IsCurrent = 1
				union all
				select		lca.CaseHash						as CaseHash
							,'Activity'							as InteractionType
							,aac.ActivityHash					as InteractionHash
							,aac.ActivityKey					as InteractionKey
							,aac.ActivityName					as InteractionName
							,aac.ActivityStartDate				as InteractionStartDate
							,aac.ActivityCompleteDate			as InteractionEndDate
				from		dv.sat_Activity_Adapt_core			aac
				join		dv.link_Case_Activity				lca on lca.ActivityHash = aac.ActivityHash
				where		aac.IsCurrent = 1
				union all
				select		lcc.CaseHash						as CaseHash
							,'Correspondence'					as InteractionType
							,cac.CorrespondenceHash				as InteractionHash
							,cac.CorrespondenceKey				as InteractionKey
							,cac.CorrespondenceNotes			as InteractionName
							,cac.CorrespondenceDate				as InteractionStartDate
							,null								as InteractionEndDate
				from		dv.sat_Correspondence_Adapt_core	cac
				join		dv.link_Case_Correspondence			lcc on lcc.CorrespondenceHash = cac.CorrespondenceHash
				where		cac.isCurrent = 1
				)					dac
join			dwh.Fact_Case		cas  on cas.CaseHashBin		= dac.CaseHash
left join		dwh.dim_Programme	pro on pro.ProgrammeHash	= cas.ProgrammeHash
left join		dwh.dim_Participant par on par.ParticipantHash	= cas.ParticipantHash
where			pro.ProgrammeName in ('WHP Wales','WHP London','Pioneer Wales','Pioneer London');-- 09/10/2023 - <SK> - <27218>