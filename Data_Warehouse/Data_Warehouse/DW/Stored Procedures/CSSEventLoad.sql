CREATE PROC [DW].[CSSEventLoad] AS

-- =======================================================================================================================================================
-- Author: Sagar Kadiyala
-- Modified date: 07/09/2023
-- Ticket Reference:  #27867
-- Description: Pioneer Wales CSS Logic Stored Proc
-- Revisions:
-- 08/09/2023 - SK - 27867 - Created a new SP for the Pioneer Wales CSS and added the execution call
-- 08/09/2023 - SK - 27410 - Created a new SP to load the CSS rules config using external table and load to the ELT table, added the execution call
-- 02/10/2023 - SK - 28516 - Created a new SP for the Pioneer London CSS and added the execution call
-- 14/02/2024 - MK - 32062 - Added claim date to criteria for job starts where no verification date
-- =======================================================================================================================================================

-- Delete temporary table if present.
if object_id ('stg.Meta_WorkflowEventsStaging','U') is not null  drop table stg.Meta_WorkflowEventsStaging;

with maintemp as (

select			cas.CaseHash																as CaseHashBin
				,convert(char(66),isnull(cas.CaseHash ,cast(0x0 as binary(32))),1)			as CaseHash
				,convert(char(66),isnull(ref.ReferralHash ,cast(0x0 as binary(32))),1)		as ReferralHash
				,convert(char(66),isnull(pro.ProgrammeHash ,cast(0x0 as binary(32))),1)		as ProgrammeHash
				,cast(sad.StartDate as date)												as StartDate
				,cast(sad.LeaveDate as date)												as LeaveDate
				,cast(sad.ProjectedLeaveDate as date)										as ProjectedLeaveDate
				,cast(rac.ReferralDate as date)												as ReferralDate
				,cast(prn.ProgrammeName as varchar(250))									as ProgrammeName
				,cast(fcd.FirstCorrespondenceDate as date)									as FirstCorrespondenceDate
				,cast(fjd.FirstJobStartDate as date)										as FirstJobStartDate
				,cast(fcd.BotWelcomePackDate as date)										as BotWelcomePackDate
				,cast(fcd.BotFTADate as date)												as BotFTADate
				,case when iow.CaseHash is null then 'Unemployed' else 'Employed' end		as InOutWork
				,cas.RecordSource															as RecordSource
				,cast(mu1.Description as varchar(250))										as LeaveReason
from			DV.HUB_Case								cas
left join		DV.SAT_Case_Adapt_Dates					sad on sad.CaseHash = cas.CaseHash and sad.IsCurrent = 1
left join		DV.LINK_Case_Referral					ref on ref.CaseHash = cas.CaseHash
left join		(select * from 
						(select sr1.*,row_number() over (partition by sr1.ReferralHash order by sr1.ReferralHash, sr1.ReferralDate desc) as rn
						from	DV.SAT_Referral_Adapt_Core sr1 where sr1.IsCurrent = 1) sr2
						where sr2.rn = 1)				rac on rac.ReferralHash		= ref.ReferralHash		and rac.IsCurrent = 1
left join		DV.LINK_Referral_Programme				pro on pro.ReferralHash		= ref.ReferralHash
left join		DV.SAT_Programme_Adapt_Core				prn on prn.ProgrammeHash	= pro.ProgrammeHash		and	prn.IsCurrent = 1
left join		BV.LINK_Case_DeliverySite				dsi on dsi.CaseHash			= cas.CaseHash 
join			DV.LINK_Case_Participant				par	on par.CaseHash			= cas.CaseHash
left join		DV.SAT_Participant_Adapt_Core_PersonGen	pac on pac.ParticipantHash	= par.ParticipantHash	and pac.IsCurrent = 1
left join		DV.SAT_Case_Adapt_Core					cac on cac.CaseHash			= cas.CaseHash			and cac.IsCurrent = 1
left join		DV.SAT_References_MDMultiNames			mu1 on mu1.ID				= cac.LeaveReason		and mu1.IsCurrent = 1  and mu1.Type = 'Code'
left join		(select			cas.CaseHash
								,min(cac.CorrespondenceDate)		as FirstCorrespondenceDate
								,min(case	when MD.Description = 'BOT - Welcome Pack' -- CorrespondenceMethod = 36028897018949718 
											then cac.CorrespondenceDate
											else null 
									 end)							as BotWelcomePackDate
								,max(case	when MD.Description = 'BOT - FTA' 			-- CorrespondenceMethod = 36028897018949717 
											then cac.CorrespondenceDate
											else null 
									 end)							as BotFTADate
				from			DV.HUB_Case							cas
				left join		DV.link_case_Correspondence			cor on cor.CaseHash = cas.CaseHash
				left join		DV.SAT_Correspondence_Adapt_Core	cac on cac.CorrespondenceHash = cor.CorrespondenceHash and cac.IsCurrent = 1
				left join 		DV.SAT_References_MDMultiNames		md	on md.id = cac.CorrespondenceMethod
				group by		cas.CaseHash)						fcd on fcd.CaseHash			= cas.CaseHash		
left join		(select			lca.CaseHash
				from			DV.LINK_Case_Assignment				lca
				join			DV.SAT_Assignment_Adapt_Core		sac on sac.AssignmentHash = lca.AssignmentHash and sac.IsCurrent = 1
				where			IsNull(sac.AssignmentStartVerificationDate,sac.AssignmentStartClaimDate) is not null -- 14/02/24 <MK> <32062>
				and				sac.AssignmentLeaveDate							is null
				and				isnull(sac.AssignmentOutcomeOneClaimYear,'')	not like 'DNC%'
				group by		lca.CaseHash)						iow on iow.CaseHash			= cas.CaseHash
left join		(select			lca.CaseHash
								,min(sac.AssignmentStartDate)		as FirstJobStartDate
				from			DV.LINK_Case_Assignment				lca
				join			DV.SAT_Assignment_Adapt_Core		sac on sac.AssignmentHash = lca.AssignmentHash and sac.IsCurrent = 1
				where			sac.AssignmentStartDate	is not null
				group by		lca.CaseHash)						fjd on fjd.CaseHash			= cas.CaseHash
where			cas.RecordSource = 'ADAPT.PROP_WP_GEN'   --This line is Temp until we add other sources
and not exists	(select		1
				 from		DV.SAT_Entity_SoftDelete_Adapt_Core csa
				 where		csa.IsCurrent = 1 
							and (csa.EntityHash		= cas.CaseHash
								or csa.EntityHash	= ref.ReferralHash
								or csa.EntityHash	= dsi.DeliverySiteHash
								or csa.EntityKey	= pac.ParticipantEntityKey))
and				(mu1.description != 'Deceased' or cac.LeaveReason is null)
)

select *
into stg.Meta_WorkflowEventsStaging
from maintemp;

truncate table DV.SAT_WorkFlowEvents_Meta_Core_New;

exec ELT.sp_Load_CSS_Catalogue; -- 08/09/2023 - <SK> - <27867>

exec DW.CSSEventLoad_WalesCSS;

exec DW.CSSEventLoad_LondonCSS;

exec DW.CSSEventLoad_PioneerWalesCSS; -- 08/09/2023 - <SK> - <27410>

exec DW.CSSEventLoad_PioneerLondonCSS; -- 02/10/2023 - <SK> - <28516>

Go
